import 'package:flutter/material.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget title;

  const CustomCheckboxTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0XFF3359A7), // Match button color
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce padding
          visualDensity: VisualDensity.compact, // Further reduce padding
        ),
        Expanded(child: title),
      ],
    );
  }
}