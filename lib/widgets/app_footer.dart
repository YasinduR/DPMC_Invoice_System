import 'package:flutter/material.dart';


// Common footer for all views

class AppFooter extends StatelessWidget {
  final double height;
  const AppFooter({
    super.key,
    this.height = 60.0 // Default height
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dpmc_footer.png'),
          fit: BoxFit.contain,
          onError: _handleImageError,
        ),
      ),
    );
  }
  static void _handleImageError(Object exception, StackTrace? stackTrace) {
    debugPrint("Footer image failed to load: $exception");
  }
}
