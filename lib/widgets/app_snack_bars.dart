import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

enum MessageType { success, error, warning }

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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

  final snackBar = SnackBar(
    backgroundColor:
        Colors.transparent, 
    elevation: 0, 
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom:
          MediaQuery.of(context).size.height * 0.75,
      left: 16,
      right: 16,
    ),

    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor, 
        borderRadius: BorderRadius.circular(12), 
        boxShadow: [
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
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(Icons.close, color: AppColors.white, size: 24),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
    
}
