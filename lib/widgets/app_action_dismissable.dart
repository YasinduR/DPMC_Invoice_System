import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme_helper.dart';

// Assuming the enum is defined globally or imported
 enum ActionDismissableType { primary, secondary, tertiary, custom }

class ActionDismissible extends StatelessWidget {
  final Widget child; // The item being swiped (e.g., ListTile)
  final String label;
  final IconData? icon;
  final VoidCallback onAction; // Callback when swipe is completed
  final ActionDismissableType type;
  final Color? color;
  final bool disabled;
  final bool minsize;
  final Key dismissKey; // Required for Dismissible

  const ActionDismissible({
    super.key,
    required this.dismissKey,
    required this.child,
    required this.label,
    required this.onAction,
    this.icon,
    this.type = ActionDismissableType.primary,
    this.color,
    this.minsize = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine the base color using your ActionButton logic
    Color baseColor;
    switch (type) {
      case ActionDismissableType.primary:
        baseColor = Theme.of(context).colorScheme.primary;
        break;
      case ActionDismissableType.secondary:
        baseColor = Theme.of(context).colorScheme.secondary;
        break;
      case ActionDismissableType.tertiary:
        baseColor = Theme.of(context).colorScheme.tertiary;
        break;
      case ActionDismissableType.custom:
        baseColor = color ?? Theme.of(context).colorScheme.primary;
        break;
    }

    if (disabled) {
      baseColor = Theme.of(context).disabledColor;
    }

    // 2. Determine Height and Border Radius (matches your minsize logic)
    final double height = minsize ? 36 : 48; // Standard ElevatedButton height is approx 48
    final double borderRadius = minsize ? 18 : 8; // Adjust based on your theme's default

    // 3. Create the Background (The "Button" revealed behind the swipe)
    Widget actionBackground = Container(
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft, // Swipe Right to trigger
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: minsize ? 18 : 24),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppThemeHelpers.getActionButtonTextStyle().copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return Dismissible(
      key: dismissKey,
      direction: disabled ? DismissDirection.none : DismissDirection.startToEnd,
      background: actionBackground,
      // Logic when swiped
      confirmDismiss: (direction) async {
        onAction();
        return false; // Return false so the item doesn't disappear from the list
      },
      child: child,
    );
  }
}