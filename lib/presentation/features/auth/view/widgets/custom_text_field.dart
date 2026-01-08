import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomLabeledTextField({
    super.key,
    required this.label,
    this.hintText = '',
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0XFF3359A7),
                width: 2.0,
              ),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
