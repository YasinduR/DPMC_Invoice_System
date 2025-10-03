import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Common Radio Option Group
class TitledRadioGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const TitledRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children:
              options.map((option) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(option, style: const TextStyle(fontSize: 12)),
                    value: option,
                    groupValue: selectedValue,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
