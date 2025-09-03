import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart'; // Make sure the path is correct

enum MessageType { success, error, warning }

// The GlobalKey is no longer needed for this specific function,
// but we can leave it in case other parts of your app use it.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// MODIFIED FUNCTION
// void showSnackBar({
//   required BuildContext context, // 1. Context is now required
//   required String message,
//   required MessageType type,
//   Duration duration = const Duration(seconds: 3),
//   SnackBarAction? action,
// }) {
//   // --- Color selection logic remains the same ---
//   Color backgroundColor;
//   switch (type) {
//     case MessageType.success:
//       backgroundColor = AppColors.success;
//       break;
//     case MessageType.error:
//       backgroundColor = AppColors.danger;
//       break;
//     case MessageType.warning:
//       backgroundColor = AppColors.warning;
//       break;
//   }

//   // 2. We will now build the SnackBar with new properties
//   final snackBar = SnackBar(
//     content: Text(
//       message,
//       style: const TextStyle(color: AppColors.white),
//     ),
//     backgroundColor: backgroundColor,
//     duration: duration,
//     action: action,

//     // =======================================================
//     // ========= NEW PROPERTIES TO MOVE IT TO THE TOP ========
//     // =======================================================

//     // Makes the SnackBar "float" instead of being fixed to the bottom
//     behavior: SnackBarBehavior.floating,

//     // Pushes the floating SnackBar up from the bottom.
//     // We calculate a margin that leaves space only for the SnackBar itself at the top.
//     margin: EdgeInsets.only(
//       bottom: MediaQuery.of(context).size.height - 150, // Pushes it way up
//       left: 10,
//       right: 10,
//     ),
//     // =======================================================
//   );

//   // 3. We now use the context to show the SnackBar.
//   // This is the standard way when you have context available.
//   ScaffoldMessenger.of(context)
//     ..removeCurrentSnackBar()
//     ..showSnackBar(snackBar);
// }

void showSnackBar({
  required BuildContext context,
  required String message,
  required MessageType type,
  String? title,
  Duration duration = const Duration(seconds: 4),
}) {
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
