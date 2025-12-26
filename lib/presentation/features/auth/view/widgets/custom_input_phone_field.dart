import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isValid; // To control the checkmark visibility
  final bool readOnly;
  final bool onlyIndia;

  const CustomPhoneInputField({
    super.key,
    required this.controller,
    this.label = 'Phone Number',
    this.isValid = false,
    this.readOnly = false,
    this.onlyIndia = false,
  });

  @override
  State<CustomPhoneInputField> createState() => _CustomPhoneInputFieldState();
}

class _CustomPhoneInputFieldState extends State<CustomPhoneInputField> {
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
                  // If we need to bubble this up, we would add a callback to the widget
                },
                initialSelection: 'IN', // Initial country selection
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                showFlagDialog: true,
                alignLeft: false,
                enabled: !widget.readOnly, // Disable when read-only
                countryFilter: widget.onlyIndia
                    ? const ['IN']
                    : null, // Conditional filter
                textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Only allow digits
                    LengthLimitingTextInputFormatter(10), // Max 10 digits
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter phone number', // Example number as hint
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Hide default border
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: widget.isValid
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
