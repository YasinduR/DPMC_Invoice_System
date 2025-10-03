import 'package:flutter/material.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';

// Tin Information card

class TinInfoDisplay extends StatelessWidget {
  final TinData tinData;
  final VoidCallback? onInfoPressed;
  const TinInfoDisplay({super.key, required this.tinData, this.onInfoPressed});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              tinData.tinNumber,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: onInfoPressed != null ? AppColors.primary : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.question_mark,
              color: AppColors.white,
              size: 20,
            ),
            onPressed: onInfoPressed,
          ),
        ),
      ],
    );
  }
}
