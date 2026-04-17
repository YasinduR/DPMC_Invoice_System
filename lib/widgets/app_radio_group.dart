import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Common Radio Option Group
class TitledRadioGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final bool enabled; // New parameter to control enablement
  final bool singleColumn;

  const TitledRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.enabled = true,
    this.singleColumn = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        // Added by Darshan R on 23/03/2026
        singleColumn
            ? Column(
                children: options
                    .map((option) => RadioListTile<String>(
                          title: Text(option, style: const TextStyle(fontSize: 12)),
                          value: option,
                          groupValue: selectedValue,
                          onChanged: enabled ? onChanged : null,
                          activeColor: enabled ? AppColors.primary : AppColors.disabled,
                          contentPadding: EdgeInsets.zero,
                        ))
                    .toList(),
              )
            : Row(
                children:
                    options.map((option) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                          option, 
                          style: const TextStyle(fontSize: 12)),
                          value: option,
                          groupValue: selectedValue,
                          onChanged: enabled? onChanged : null,
                          activeColor: enabled? AppColors.primary: AppColors.disabled,
                          contentPadding: EdgeInsets.zero,
                        ),
                      );
                    }).toList(),
              ),
      ],
    );
  }
}
