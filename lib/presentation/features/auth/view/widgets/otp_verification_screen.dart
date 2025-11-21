import 'package:flutter/material.dart';
import 'dart:async';

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
  // Controllers for each OTP digit
  late List<TextEditingController> _otpControllers;
  // Focus nodes to manage movement between fields
  late List<FocusNode> _focusNodes;
  // State to hold the countdown timer
  late Timer _timer;
  int _secondsRemaining = resendTimeout;
  bool _canResend = false;
  
  // Storage for the complete OTP value
  String get _currentOtp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes for 6 digits
    _otpControllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());
    
    // Start the resend timer
    _startTimer();

    // Add listeners to handle auto-focus movement
    for (int i = 0; i < otpLength; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1) {
          // Move to the next field if a digit is entered
          if (i < otpLength - 1) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          } else {
            // If the last field is filled, submit or unfocus
            FocusScope.of(context).unfocus();
          }
        } else if (_otpControllers[i].text.isEmpty && i > 0) {
          // Move to the previous field if backspace is pressed and field is empty
          FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        }
        setState(() {}); // Update state to enable/disable the submit button
      });
    }
  }

  void _startTimer() {
    _secondsRemaining = resendTimeout;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onResendOtp() {
    if (_canResend) {
      print('OTP Resent to ${widget.phoneNumber}');
      // Clear the current OTP inputs
      for (var controller in _otpControllers) {
        controller.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
      _startTimer();
    }
  }

  void _onSubmit() {
    if (_currentOtp.length == otpLength) {
      print('OTP Submitted: ${_currentOtp}');
      // Implement verification logic here
    } else {
      print('Please enter the full OTP.');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isOtpComplete = _currentOtp.length == otpLength;
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        // Use a back button to mimic navigation flow back to the login screen
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
                  style: TextStyle(
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

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(otpLength, (index) {
                    return _buildOtpField(index);
                  }),
                ),
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
                  onPressed: isOtpComplete ? _onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ).copyWith(
                    // Style for disabled state
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return primaryBlue.withOpacity(0.5); // Grey out when disabled
                        }
                        return primaryBlue; // Use primary color when enabled
                      },
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
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
                    // Pop back to the login screen to change the number
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

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 48,
      child: AspectRatio(
        aspectRatio: 1.0, // Ensures the container is square
        child: TextFormField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1, // Only one digit allowed
          decoration: InputDecoration(
            counterText: '', // Hide the 1/1 counter text
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: primaryBlue,
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}