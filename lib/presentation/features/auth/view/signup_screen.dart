import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/auth/create_profile_request.dart';
import 'package:oc_academy_app/data/models/profession_response.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';
import 'package:oc_academy_app/data/repositories/profession_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_checkbox_list.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_input_phone_field.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_phone_field.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_text_field.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/home_page_screen.dart';

class SignupScreen extends StatefulWidget {
  final String phoneNumber;
  final String preAccessToken;
  final String? email;
  const SignupScreen({
    super.key,
    required this.phoneNumber,
    required this.preAccessToken,
    this.email,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Text controllers for all input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  final ProfessionRepository _professionRepository = ProfessionRepository();
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger _logger = Logger();

  // State for dropdown and checkbox
  Profession? _selectedProfession;
  bool _agreedToTerms = false;
  List<Profession> _professionsList = [];
  bool _isLoadingProfessions = true;
  bool _hasError = false;

  // Example state for phone number validation (for the checkmark)
  bool _isPhoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phoneNumber;
    _phoneController.addListener(_validatePhoneNumber);
    _fetchProfessions();

    // Prefill email if provided (from Google Sign-In)
    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
    }
  }

  void _fetchProfessions() async {
    setState(() {
      _isLoadingProfessions = true;
    });
    final response = await _professionRepository.getProfessions();
    if (response != null) {
      _logger.i("Fetched ${response.professions.length} professions.");
      setState(() {
        _professionsList = response.professions;
        _isLoadingProfessions = false;
        _hasError = false;
      });
    } else {
      _logger.w("Get Professions returned null.");
      setState(() {
        _isLoadingProfessions = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load professions. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber() {
    // Simple validation: check if phone number has at least 5 digits
    setState(() {
      _isPhoneNumberValid = _phoneController.text.length >= 5;
    });
  }

  void _submitForm() async {
    if (_formIsValid()) {
      final request = CreateProfileRequest(
        currentDevice: "device name",
        deviceToken: "device token",
        fcmToken: "fcm_token",
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        mobileNumber: _phoneController.text,
        countryId: 1, // Defaulting to 1 for now
        email: _emailController.text,
        registrationSource: "webapp",
        preAccessToken: widget.preAccessToken,
        professionId: _selectedProfession!
            .id, // Assuming 1-based indexing for profession IDs
        title: _selectedProfession?.name == 'Doctor'
            ? 'Dr.'
            : '', // Example: Set title based on profession
      );

      final response = await _authRepository.createProfile(request);
      if (response != null && response.response?.accessToken != null) {
        await _tokenStorage.saveApiAccessToken(response.response!.accessToken!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and agree to terms.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _formIsValid() {
    return _selectedProfession != null &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _agreedToTerms;
  }

  @override
  Widget build(BuildContext context) {
    final professionItems = _professionsList.map((p) => p.name).toList();
    _logger.i("Building dropdown with items: $professionItems");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... other imports ...
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouteConstants.login);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            const Text(
              'Sign up and start learning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // Profession Dropdown
            _hasError
                ? Row(
                    children: [
                      const Text('Failed to load professions'),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _fetchProfessions,
                      ),
                    ],
                  )
                : CustomDropdownField(
                    label: 'Profession*',
                    value: _selectedProfession?.name,
                    items: professionItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProfession = _professionsList.firstWhere(
                          (p) => p.name == newValue,
                        );
                      });
                    },
                    hintText: _isLoadingProfessions
                        ? 'Loading...'
                        : 'Select your profession',
                  ),
            const SizedBox(height: 20),

            // First Name and Last Name
            Row(
              children: [
                Expanded(
                  child: CustomLabeledTextField(
                    label: 'First Name*',
                    hintText: 'Enter first name',
                    controller: _firstNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomLabeledTextField(
                    label: 'Last Name*',
                    hintText: 'Enter last name',
                    controller: _lastNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Phone Number Field
            CustomPhoneInputField(
              controller: _phoneController,
              isValid: _isPhoneNumberValid,
              readOnly: widget.phoneNumber.isNotEmpty,
            ),
            const SizedBox(height: 20),

            // Email Address Field
            CustomLabeledTextField(
              label: 'Email Address *',
              hintText: 'Enter your email address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: widget.email != null && widget.email!.isNotEmpty,
            ),
            const SizedBox(height: 20),

            // Terms and Privacy Checkbox
            CustomCheckboxTile(
              value: _agreedToTerms,
              onChanged: (bool? newValue) {
                setState(() {
                  _agreedToTerms = newValue ?? false;
                });
              },
              title: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(text: 'I agree to '),
                    TextSpan(
                      text: 'terms of use',
                      style: TextStyle(
                        color: Color(0XFF3359A7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'privacy policy.',
                      style: TextStyle(
                        color: Color(0XFF3359A7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _formIsValid() ? _submitForm : null,
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF3359A7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color(0XFF3359A7).withOpacity(0.5);
                          }
                          return const Color(0XFF3359A7);
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
            ),
            const SizedBox(height: 20),

            // Already have an account? Login here
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  children: <TextSpan>[
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Login here',
                      style: const TextStyle(
                        color: Color(0XFF3359A7),
                        fontWeight: FontWeight.bold,
                      ),
                      // onTap for navigation (e.g., Navigator.push for LoginScreen)
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Navigate to Login Screen');
                          // Example: Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
