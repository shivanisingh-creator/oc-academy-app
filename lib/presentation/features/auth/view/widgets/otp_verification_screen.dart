import 'package:flutter/material.dart';
import 'dart:async';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/auth/verify_otp_request.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/signup_screen.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/home_page_screen.dart';
import 'package:pinput/pinput.dart'; // Import the pinput package
import 'package:oc_academy_app/core/utils/error_tooltip.dart';

// Constants for styling
const Color primaryBlue = Color(0XFF3359A7);
const Color whiteBackground = Colors.white;
const int otpLength = 6;
const int resendTimeout = 60; // 60 seconds

class OtpVerificationScreen extends StatefulWidget {
  // The phone number passed from the previous screen
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // --- Pinput Controllers and Focus Node ---
  // We only need one controller and one focus node for Pinput
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AuthRepository _authRepository = AuthRepository();
  final TokenStorage _tokenStorage = TokenStorage();
  final GlobalKey _pinPutKey = GlobalKey();
  
  // State to hold the countdown timer
  late Timer _timer;
  int _secondsRemaining = resendTimeout;
  bool _canResend = false;
  
  // Storage for the complete OTP value (now just the text from the single controller)
  String get _currentOtp {
    return _pinController.text;
  }

  @override
  void initState() {
    super.initState();
    
    // Start the resend timer
    _startTimer();
    
    // Manual auto-focus/change listeners are no longer needed, 
    // as Pinput handles those internally.
  }

  void _startTimer() {
    _secondsRemaining = resendTimeout;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onResendOtp() {
    if (_canResend) {
      print('OTP Resent to ${widget.phoneNumber}');
      
      // Clear the current OTP input using the single controller
      _pinController.clear();
      FocusScope.of(context).requestFocus(_focusNode);
      _startTimer();
    }
  }

  void _onSubmit() async {
    if (_currentOtp.length == otpLength) {
      print('OTP Submitted: ${_currentOtp}');
      final request = VerifyOtpRequest(
        currentDevice: "device name",
        deviceToken: "Device Token",
        fcmToken: "fcm_token",
        mobileNumber: widget.phoneNumber,
        otp: _currentOtp,
        registrationSource: "webapp",
        isLead: false,
        productType: 0,
      );
      final response = await _authRepository.verifyOtp(request);
      if (!mounted) return;
      if (response != null) {
        if (response.response?.status == 'FAILED') {
          // Parse attempts left from the message
          final message = response.response?.message ?? '';
          final RegExp exp = RegExp(r'(\d+)\sAttempts Left');
          final Match? match = exp.firstMatch(message);
          int attemptsLeft = 0;
          if (match != null && match.groupCount >= 1) {
            attemptsLeft = int.tryParse(match.group(1)!) ?? 0;
          }
          
          ErrorTooltip.show(
            context,
            _pinPutKey,
            '$message. You have $attemptsLeft attempts left.',
          );
          if (attemptsLeft == 0) {
            if (!mounted) return;
            setState(() {
              _canResend = true;
            });
          }
        } else if (response.response?.isNewUser == true) {
          final preAccessToken = response.response?.preAccessToken;
          if (preAccessToken != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignupScreen(
                  phoneNumber: widget.phoneNumber,
                  preAccessToken: preAccessToken,
                ),
              ),
            );
          }
        } else if (response.response?.isNewUser == false && response.response?.accessToken != null) {
          await _tokenStorage.saveApiAccessToken(response.response!.accessToken);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        }
      } else {
        print('❌ OTP Verification Failed');
      }
    } else {
      print('Please enter the full OTP.');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    // Dispose the single controller and focus node
    _pinController.dispose();
    _focusNode.dispose();
    ErrorTooltip.hide();
    super.dispose();
  }

  // --- Pinput Styling Configuration ---
  // Define the default theme for all pin boxes
  PinTheme get _defaultPinTheme => PinTheme(
    width: 48,
    height: 48,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey.shade400,
        width: 1,
      ),
    ),
  );

  // Define the theme for the currently focused pin box
  PinTheme get _focusedPinTheme => _defaultPinTheme.copyDecorationWith(
    border: Border.all(
      color: primaryBlue,
      width: 2,
    ),
  );

  // Define the theme for all pin boxes once the full OTP is entered
  PinTheme get _submittedPinTheme => _defaultPinTheme.copyDecorationWith(
    border: Border.all(
      color: primaryBlue,
      width: 1.5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool isOtpComplete = _currentOtp.length == otpLength;
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        backgroundColor: whiteBackground,
        elevation: 0,
        title: const Text('Verify OTP', style: TextStyle(color: Colors.black87)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: whiteBackground,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Main Header
                const Text(
                  'Enter the code sent to your phone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number Display
                Text(
                  widget.phoneNumber,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Enter OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // --- NEW: Pinput Widget for OTP Input ---
                Pinput(
                  key: _pinPutKey,
                  length: otpLength,
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  
                  // Crucial for enabling platform-level autofill
                  autofocus: true, 
                  
                  // Styling based on the PinTheme getters defined above
                  defaultPinTheme: _defaultPinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  submittedPinTheme: _submittedPinTheme,
                  
                  // Automatically calls onSubmit when the full OTP is entered
                  onCompleted: (pin) => _onSubmit(),
                  
                  // Updates the state to enable/disable the submit button
                  onChanged: (value) {
                    ErrorTooltip.hide();
                    if(mounted){
                      setState(() {});
                    }
                  },
                  
                  // Ensures the keyboard suggests the one-time code on iOS
                  autofillHints: const [AutofillHints.oneTimeCode],
                ),
                // --- END Pinput Widget ---
                
                const SizedBox(height: 30),

                // Resend Timer/Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Didn\'t receive the OTP? ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    InkWell(
                      onTap: _onResendOtp,
                      child: Text(
                        _canResend
                            ? 'Resend Now'
                            : 'Resend in $_secondsRemaining sec',
                        style: TextStyle(
                          fontSize: 14,
                          color: _canResend ? primaryBlue : Colors.grey,
                          fontWeight: FontWeight.bold,
                          decoration: _canResend ? TextDecoration.underline : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Submit Button
                ElevatedButton(
                  onPressed: isOtpComplete ? (_canResend ? _onResendOtp : _onSubmit) : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return primaryBlue.withOpacity(0.5); 
                        }
                        return primaryBlue;
                      },
                    ),
                  ),
                  child: Text(
                    _canResend ? 'Resend OTP' : 'Submit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Change Phone Number Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    side: const BorderSide(color: primaryBlue, width: 2),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Change Phone Number',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}