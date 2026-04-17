import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Information card with ?

class InfoDisplay extends StatelessWidget {
  final String info;
  final VoidCallback? onInfoPressed;
  const InfoDisplay({super.key, required this.info, this.onInfoPressed});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              info,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: onInfoPressed != null ? AppColors.primary :AppColors.borderIntense,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.question_mark,
              color: AppColors.surface,
              size: 20,
            ),
            onPressed: onInfoPressed,
          ),
        ),
      ],
    );
  }
}
