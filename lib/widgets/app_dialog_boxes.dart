import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart'; // Make sure the path is correct

/// A helper widget to create the styled, full-width dialog buttons.
Widget _buildDialogButton({
  required String text,
  required VoidCallback onPressed,
  required Color backgroundColor,
  Color textColor = AppColors.white,
}) {
  return SizedBox(
    width: double.infinity, // Make button take full width
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Fully rounded corners
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

/// A generic dialog function. All other dialogs are based on this.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  Widget? content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false, // User must interact to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // Center the title text
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // The main message content
        content: content,
        // The buttons at the bottom, wrapped in a Column
        actions:
            actions != null && actions.isNotEmpty
                ? [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        actions.map((action) {
                          // Add spacing between buttons
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: action,
                          );
                        }).toList(),
                  ),
                ]
                : null,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      );
    },
  );
}

/// Shows a styled confirmation dialog.
///
/// Returns `true` if the user confirms, `false` otherwise.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? content,
  String confirmButtonText = 'Yes', // New default
  String cancelButtonText = 'No', // New default
}) async {
  final result = await showAppDialog<bool>(
    context: context,
    title: title,
    content:
        content != null ? Text(content, textAlign: TextAlign.center) : null,
    actions: [
      // The "Confirm" button (e.g., "Yes, Log out")
      _buildDialogButton(
        text: confirmButtonText,
        backgroundColor: AppColors.danger,
        onPressed: () {
          Navigator.of(context).pop(true); // Return true
        },
      ),
      // The "Cancel" button (e.g., "No, I'm Staying")
      _buildDialogButton(
        text: cancelButtonText,
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.of(context).pop(false); // Return false
        },
      ),
    ],
  );
  // Return false if dialog is dismissed by other means (e.g., back button)
  return result ?? false;
}

/// Shows a simple informational (success or error) dialog with a single action button.
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'Ok', //default
  bool isError = false,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: Text(content, textAlign: TextAlign.center),
    actions: [
      _buildDialogButton(
        text: buttonText,
        backgroundColor: isError ? AppColors.danger : AppColors.primary,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}
