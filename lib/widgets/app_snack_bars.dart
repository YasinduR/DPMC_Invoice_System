import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart'; // Make sure the path is correct

enum MessageType { success, error, warning }

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar({
  required BuildContext context,
  required String message,
  required MessageType type,
  String? title,
  Duration duration = const Duration(seconds: 4),
}) {


  if (MediaQuery.of(context).viewInsets.bottom > 0) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // --- 1. Color and Title Logic ---
  Color backgroundColor;
  String finalTitle;

  switch (type) {
    case MessageType.success:
      backgroundColor = AppColors.success;
      finalTitle = title ?? 'SUCCESS';
      break;
    case MessageType.error:
      backgroundColor = AppColors.danger;
      finalTitle = title ?? 'ERROR';
      break;
    case MessageType.warning:
      backgroundColor = AppColors.warning;
      finalTitle = title ?? 'WARNING';
      break;
  }

  // --- 2. Build the SnackBar ---
  final snackBar = SnackBar(
    // Core properties for a custom layout
    backgroundColor:
        Colors.transparent, // Make the default background transparent
    elevation: 0, // Remove the default shadow
    behavior: SnackBarBehavior.floating,

    // Push the SnackBar to the top of the screen
    margin: EdgeInsets.only(
      bottom:
          MediaQuery.of(context).size.height * 0.75, // Adjust as needed later
      left: 16,
      right: 16,
    ),

    // The content is our custom-designed widget
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor, // The real background color
        borderRadius: BorderRadius.circular(12), // Rounded edges
        boxShadow: [
          // Optional: add a subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The Title and Message section
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  finalTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // The 'X' Close Button
          GestureDetector(
            onTap: () {
              // Hides the current SnackBar when tapped
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(Icons.close, color: AppColors.white, size: 24),
          ),
        ],
      ),
    ),
  );

  // --- 3. Show the SnackBar ---
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
