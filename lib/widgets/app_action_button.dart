import 'package:flutter/material.dart';

// Define an enum for button types
enum ActionButtonType {
  primary,
  secondary,
  tertiary,
  custom,
}

class ActionButton extends StatelessWidget {
  final String label; // Label
  final VoidCallback onPressed; // OnPress Call Back fn
  final IconData? icon; // Icon is optional
  final ActionButtonType type; // New: Button type (primary, secondary, tertiary, custom)
  final Color? color; // Used only if type is custom
  final bool disabled; // Disabled state
  final bool? minsize;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = ActionButtonType.primary, // Default to primary
    this.color, // Custom color for ActionButtonType.custom
    this.minsize = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {

    final ButtonStyle? defaultButtonStyle = Theme.of(context).elevatedButtonTheme.style;
    ButtonStyle? effectiveButtonStyle = defaultButtonStyle;
    
    // Determine the base color based on the type
    Color? baseColor;
    switch (type) {
      case ActionButtonType.primary:
        break;
      case ActionButtonType.secondary:
        baseColor = Theme.of(context).colorScheme.secondary;
        break;
      case ActionButtonType.tertiary:
        baseColor = Theme.of(context).colorScheme.tertiary;
        break;
      case ActionButtonType.custom:
        baseColor = color; // Use the provided color
        break;
    }
    if (minsize == true) {
      effectiveButtonStyle = effectiveButtonStyle?.copyWith(
        minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 36)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      );
    }
    if (baseColor != null && !disabled) { 
      effectiveButtonStyle = effectiveButtonStyle?.copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(baseColor),
         );
    }

    return (icon != null)
        ? ElevatedButton.icon(
            icon: Icon(
              icon,
            ), 
            label: Text(
              label,
            ), 
            onPressed: disabled ? null : onPressed,
            style: effectiveButtonStyle,
          )
        : ElevatedButton(
            onPressed: disabled ? null : onPressed,
            style: effectiveButtonStyle,
            child: Text(
              label,
            ), 
          );
  }
}