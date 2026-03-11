import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_page.dart';

// Common Screen For Errors
class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const ErrorScreen({super.key, this.title = 'Error', required this.message});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: title,
      contentPadding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


