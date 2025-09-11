// // lib/utils/snackbar_utils.dart

// import 'package:flutter/material.dart';
// import 'package:myapp/theme/app_theme.dart'; // Make sure the path is correct

// // 1. Add 'warning' to the enum
// enum MessageType { success, error, warning }

// // Global key to access the ScaffoldMessengerState
// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>();

// void showSnackBar({
//   required String message,
//   required MessageType type,
//   Duration duration = const Duration(seconds: 4),
//   SnackBarAction? action, required BuildContext context,
// }) {
//   // 2. Use a switch statement to determine the background color
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

//   final snackBar = SnackBar(
//     content: Text(
//       message,
//       style: const TextStyle(color: AppColors.white), // Ensure text is readable
//     ),
//     backgroundColor: backgroundColor,
//     duration: duration,
//     action: action,
//   );

//   // Use the global key to show the SnackBar
//   // The ?.removeCurrentSnackBar() is added to dismiss any currently visible snackbar
//   // before showing the new one, which is good practice.
//   scaffoldMessengerKey.currentState
//     ?..removeCurrentSnackBar()
//     ..showSnackBar(snackBar);
// }
