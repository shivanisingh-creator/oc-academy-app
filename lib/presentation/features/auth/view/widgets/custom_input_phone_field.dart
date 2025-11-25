import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CustomPhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isValid; // To control the checkmark visibility
  final bool readOnly;

  const CustomPhoneInputField({
    super.key,
    required this.controller,
    this.label = 'Phone Number',
    this.isValid = false,
    this.readOnly = false,
  });

  @override
  State<CustomPhoneInputField> createState() => _CustomPhoneInputFieldState();
}

class _CustomPhoneInputFieldState extends State<CustomPhoneInputField> {
  String _selectedCountryCode = '+91'; // Default to India

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Row(
            children: [
              CountryCodePicker(
                onChanged: (CountryCode countryCode) {
                  setState(() {
                    _selectedCountryCode = countryCode.dialCode!;
                  });
                },
                initialSelection: 'IN', // Initial country selection
                favorite: const ['+91', 'IN'], // Show India at the top
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                showFlagDialog: true,
                alignLeft: false,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                dialogTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '82354-02876', // Example number as hint
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Hide default border
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: widget.isValid
                        ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                        : null,
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
      ],
    );
  }
}