import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool disabled; // 1. Added the new property

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        disabled ? AppColors.disabled : (color ?? AppColors.primary);

    const textStyle = TextStyle(color: AppColors.white, fontSize: 16);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
    return (icon != null)
        ? ElevatedButton.icon(
          icon: Icon(icon, color: AppColors.white),
          label: Text(label, style: textStyle),
          onPressed: disabled ? null : onPressed,
          style: buttonStyle,
        )
        : ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: buttonStyle,
          child: Text(label, style: textStyle),
        );
  }
}
