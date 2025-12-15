import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Import this package for input formatters
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/data/models/auth/signup_login_google_request.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';
import 'package:oc_academy_app/domain/entities/keycloak_service.dart';
import 'package:oc_academy_app/domain/entities/auth/google_auth_service.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/otp_verification_screen.dart';
import 'package:oc_academy_app/core/utils/error_tooltip.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:oc_academy_app/presentation/features/auth/view/mixins/auth_navigation_helper.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  final AppConfig config;
  const LoginPage({super.key, required this.config});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  final GlobalKey _phoneFieldKey = GlobalKey();

  Future<String> _getCurrentDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'unknown';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
    }
    return deviceName;
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(() {
      ErrorTooltip.hide();
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the colors based on the design image
    const Color primaryBlue = Color(
      0XFF3359A7,
    ); // For buttons and active states
    const Color logoPink = Color(0xFFEC407A); // Pink for the 'OC' logo

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // Prevents keyboard from overflowing content
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Colors.white, Colors.white],
            stops: [0.0, 1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children horizontally
              children: <Widget>[
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/oc_academy.svg",
                        height: 100,
                        color: logoPink,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Title Text
                const Text(
                  'Sign in to accelerate your career',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle Text
                const Text(
                  'Login to continue your learning',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Phone Number Input
                Container(
                  key: _phoneFieldKey,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Country Code Selector (simplified)
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '🇮🇳', // Indian flag emoji
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+91',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Phone Number Input Field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          // --- START OF REQUIRED CHANGES ---
                          inputFormatters: [
                            // 1. Limit length to 10 digits
                            LengthLimitingTextInputFormatter(10),
                            // 2. Only allow digits (no alphabets, special chars, or spaces)
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // --- END OF REQUIRED CHANGES ---
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // Remove default border
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Send OTP Button
                ElevatedButton(
                  onPressed: () async {
                    // Trimming the text before checking length is a good practice
                    if (_phoneNumberController.text.trim().length < 10) {
                      ErrorTooltip.show(
                        context,
                        _phoneFieldKey,
                        "Oops! Invalid number. Must be 10 digits.",
                      );
                      return;
                    }
                    // Fetch a fresh Keycloak token
                    await KeycloakService().getKeycloakToken(
                      clientId: widget.config.keycloakClientId,
                      clientSecret: widget.config.keycloakClientSecret,
                    );
                    final response = await _authRepository.signupLoginMobile(
                      _phoneNumberController.text.trim(), // Use trim() here too
                    );
                    if (response != null && response.response == "OTP sent") {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(
                              phoneNumber: _phoneNumberController.text.trim(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                  ],
                ),
                const SizedBox(height: 24),

                // Continue with Google Button
                OutlinedButton(
                  onPressed: () async {
                    // print('Continue with Google');

                    await KeycloakService().getKeycloakToken(
                      clientId: widget.config.keycloakClientId,
                      clientSecret: widget.config.keycloakClientSecret,
                    );

                    final googleAuthService = GoogleAuthService();
                    final accessToken = await googleAuthService.signIn();

                    if (accessToken != null) {
                      final currentDevice = await _getCurrentDevice();
                      final request = SignupLoginGoogleRequest(
                        accessToken: accessToken,
                        currentDevice: currentDevice,
                      );
                      final response = await _authRepository.signInWithGoogle(
                        request,
                      );

                      if (response != null &&
                          (response.response!.accessToken != null ||
                              response.response!.isNewUser == true)) {
                        if (!mounted) return;
                        await AuthNavigationHelper.handleLoginSuccess(
                          // ignore: use_build_context_synchronously
                          context: context,
                          isNewUser: response.response!.isNewUser ?? false,
                          accessToken: response.response!.accessToken,
                          preAccessToken: response.response!.preAccessToken,
                          phoneNumber: response.response!.mobileNumber ?? "",
                          email: response.response!.email,
                        );
                      } else {
                        Logger().e('Google Sign-In failed');
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google logo (Placeholder/Fallback)
                      SvgPicture.asset(
                        'assets/images/google.svg',
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.g_mobiledata,
                              size: 28,
                              color: Colors.blue,
                            ), // Fallback icon
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Disclaimer Text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'By continuing, you agree to OC Academy\'s ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        // Action: Navigate to Terms
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        // Action: Navigate to Privacy
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
