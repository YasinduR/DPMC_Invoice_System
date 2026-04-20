import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme_helper.dart';


class LoginButton extends StatelessWidget {
  final VoidCallback onPressed; // Login Button press
  final bool disabled; // Disabled state
  final VoidCallback? onSecondaryPressed; // Fingerprint Button press

  const LoginButton({
    super.key,
    required this.onPressed,
    this.disabled = false,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? defaultButtonStyle = Theme.of(context).elevatedButtonTheme.style;
    ButtonStyle? effectiveButtonStyle = defaultButtonStyle;
    Color baseColor = Theme.of(context).colorScheme.primary;
    if (!disabled) {
      effectiveButtonStyle = effectiveButtonStyle?.copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(baseColor),
      );
    }
    Widget buildMainButton() {
      return ElevatedButton.icon(
              icon: Icon(Icons.check_circle_outline),
              label: Text(
                'Login',
                style: AppThemeHelpers.getActionButtonTextStyle(),
              ),
              onPressed: disabled ? null : onPressed,
              style: effectiveButtonStyle,
            );
    }
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: Row(
          children: [
            Expanded(child: buildMainButton()),
            const SizedBox(width: 18),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.blueGrey,
              ),
              child: IconButton(
                icon: Icon(Icons.fingerprint),
                color: AppColors.white,
                onPressed: onSecondaryPressed,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
