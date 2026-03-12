import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme_helper.dart';

// Define an enum for button types
enum ActionButtonType { primary, secondary, tertiary, custom }

class ActionButton extends StatelessWidget {
  final String label; // Label
  final VoidCallback onPressed; // OnPress Call Back fn
  final IconData? icon; // Icon is optional
  final ActionButtonType type; // New: Button type (primary, secondary, tertiary, custom)
  final Color? color; // Used only if type is custom
  final bool disabled; // Disabled state
  final bool? minsize;
  final bool isInDialog; // whether it is in a dialog box or not
    // New: Secondary action
  final VoidCallback? onSecondaryPressed;
  final IconData? secondaryIcon;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = ActionButtonType.primary, // Default to primary
    this.color, // Custom color for ActionButtonType.custom
    this.minsize = false,
    this.disabled = false,
    this.isInDialog = false,
      this.onSecondaryPressed,
    this.secondaryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? defaultButtonStyle =
        Theme.of(context).elevatedButtonTheme.style;
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
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 36),
        ),
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

        // Build the main button
    Widget buildMainButton() {
      return (icon != null)
          ? ElevatedButton.icon(
              icon: Icon(icon),
              label: AutoSizeText(
                label,
                maxLines: 1,
                minFontSize: 8,
                overflow: TextOverflow.ellipsis,
                style: AppThemeHelpers.getActionButtonTextStyle(),
              ),
              onPressed: disabled ? null : onPressed,
              style: effectiveButtonStyle,
            )
          : ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: effectiveButtonStyle,
              child: AutoSizeText(
                label,
                maxLines: 1,
                minFontSize: 8,
                overflow: TextOverflow.ellipsis,
                style: AppThemeHelpers.getActionButtonTextStyle(),
              ),
            );
    }

    // If no secondary action, just return the main button
    if (onSecondaryPressed == null && secondaryIcon == null) {
      return Center(
        child: FractionallySizedBox(
          widthFactor: isInDialog ? 0.9 : 0.65,
          child: buildMainButton(),
        ),
      );
    }

    // With secondary action on the right
    return Center(
      child: FractionallySizedBox(
        widthFactor: isInDialog ? 1.0 : 0.75,
        child: Row(
          children: [
            Expanded(child: buildMainButton()),
            const SizedBox(width: 18),
            Container(
              // width: 36,
              // height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade200,
              ),
              child: IconButton(
                icon: Icon(secondaryIcon),
                color: baseColor,

                onPressed: onSecondaryPressed,
                //iconSize: 20,
                //padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );

// return Center(
//   child: FractionallySizedBox(
//     widthFactor: isInDialog ? 0.9 : 0.65, // x100% of available width
//     child: (icon != null)
//         ? ElevatedButton.icon(
//             icon: Icon(icon),
//             label: 
//             // Text(
//             //   label,
//             //   style: AppThemeHelpers.getActionButtonTextStyle(),
//             // )
//             AutoSizeText(
//               label,
//               maxLines: 1,
//               minFontSize: 8,
//               overflow: TextOverflow.ellipsis,
//               style: AppThemeHelpers.getActionButtonTextStyle(),
//               )
//             ,
//             onPressed: disabled ? null : onPressed,
//             style: effectiveButtonStyle,
//           )
//         : ElevatedButton(
//             onPressed: disabled ? null : onPressed,
//             style: effectiveButtonStyle,
//             child: 
//             // Text(
//             //   label,
//             //   style: AppThemeHelpers.getActionButtonTextStyle(),
//             // )
//             AutoSizeText(
//   label,
//   maxLines: 1,
//   minFontSize: 8,
//   overflow: TextOverflow.ellipsis,
//   style: AppThemeHelpers.getActionButtonTextStyle(),
//     )
//             ,
//           ),
//   ),
// );


    // return (icon != null)
    //     ? ElevatedButton.icon(
    //       icon: Icon(icon),
    //       label: Text(label, style: AppThemeHelpers.getActionButtonTextStyle()),
    //       onPressed: disabled ? null : onPressed,
    //       style: effectiveButtonStyle,
    //     )
    //     : ElevatedButton(
    //       onPressed: disabled ? null : onPressed,
    //       style: effectiveButtonStyle,
    //       child: Text(label, style: AppThemeHelpers.getActionButtonTextStyle()),
    //     );
  }
}
