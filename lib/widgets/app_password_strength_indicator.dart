// Added by Darshan R on 19/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/services/password_strength_service.dart';

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

    final strengthData = PasswordStrengthService.calculatePasswordStrength(password);
    final strength = strengthData['strength'] as double;
    final label = strengthData['label'] as String;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  FractionallySizedBox(
                    widthFactor: strength / 7,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.cyan,
                            Colors.blue,
                            Colors.purple,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(bounds);
                      },
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Password Strength: $label',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}