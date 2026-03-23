// Added by Darshan R on 19/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/helpers/password_strength.dart';
//import 'package:myapp/services/password_strength_service.dart'; Migrated By Yasindu Ganegoda.
import 'package:myapp/theme/app_colors.dart';

/// Password strength indicator widget with gradient bar
/// 
/// Displays a visual representation of password strength with:
/// - Gradient-filled progress bar (cyan → blue → purple)
/// - Strength label (Weak, Fair, Good, Strong)
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final EdgeInsetsGeometry? padding;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final strengthData = PasswordStrength.calculate(password);
    final strength = strengthData['strength'] as double;
    final label = strengthData['label'] as String;

// Modified By Yasindu Ganegoda
  return Padding(
  padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. THE STRENGTH BAR
      LayoutBuilder(
        builder: (context, constraints) {
          final fullWidth = constraints.maxWidth;
          final double progress = (strength / 7).clamp(0.0, 1.0);
          return Container(
            height: 8,
            width: fullWidth,
            decoration: BoxDecoration(
              color: AppColors.grey300, // Background track color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: fullWidth * progress,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: OverflowBox(
                      minWidth: fullWidth,
                      maxWidth: fullWidth,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.passwordStrengthBarIndicatorColors,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      // 2. STRENGTH LABEL
      Text(
        'Password Strength: $label',
        style: TextStyle(
          color: AppColors.grey700,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ],
  ),
);
  }
}