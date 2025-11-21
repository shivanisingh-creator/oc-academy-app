import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/data/repositories/auth_repository.dart';
import 'package:oc_academy_app/domain/entities/keycloak_service.dart';

class LoginPage extends StatefulWidget {
  final AppConfig config;
  const LoginPage({super.key, required this.config});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

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
    const Color gradientStart = Color(0xFFEFF6FF); // White at the top
    const Color gradientEnd = Color(
      0xFFF0F2F5,
    ); // Light grey/off-white at the bottom
    const Color logoPink = Color(0xFFEC407A); // Pink for the 'OC' logo

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Prevents keyboard from overflowing content
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [gradientStart, gradientStart],
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
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Phone Number Input Field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
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
                    // Fetch a fresh Keycloak token
                    await KeycloakService().getKeycloakToken(
                      clientId: widget.config.keycloakClientId,
                      clientSecret: widget.config.keycloakClientSecret,
                    );
                    // Then, call the signupLoginMobile endpoint
                    _authRepository.signupLoginMobile(_phoneNumberController.text);
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
                  onPressed: () {
                    // Implement Google Sign-in logic here
                    print('Continue with Google');
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