import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hintText, style: const TextStyle(color: Colors.grey)),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black87,
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
