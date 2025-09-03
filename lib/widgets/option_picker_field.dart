import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class PickerFormField extends StatelessWidget {
  final String labelText;
  final String displayValue;
  final VoidCallback onTap;

  const PickerFormField({
    super.key,
    required this.labelText,
    required this.displayValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. The centered, styled label.
        Center(
          child: Text(
            labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayValue,
                  style: TextStyle(fontSize: 14, color: AppColors.borderDark),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
    // return InkWell(
    //   onTap: onTap,
    //   child: InputDecorator(
    //     decoration: InputDecoration(
    //       labelText: labelText,
    //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    //       contentPadding: const EdgeInsets.symmetric(
    //         horizontal: 12,
    //         vertical: 16,
    //       ),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(displayValue, style: const TextStyle(fontSize: 16)),
    //         const Icon(Icons.arrow_drop_down),
    //       ],
    //     ),
    //   ),
    // );
  }
}
