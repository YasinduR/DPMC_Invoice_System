

import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

// Common Loading Screen of the application On API calls

class AppLoadingOverlay {
  OverlayEntry? _overlayEntry;
  final Color indicatorColor;
  final double indicatorSize;
  final double indicatorStrokeWidth;
  final Color? backgroundColor;

 AppLoadingOverlay({
    this.indicatorColor = AppColors.primary, // Default to AppColors.primary
    this.indicatorSize = 60.0,
    this.indicatorStrokeWidth = 6.0,
    this.backgroundColor = Colors.black54, // Default to semi-transparent black
  });
  void show(BuildContext context) {
    if (_overlayEntry != null) {
      // Overlay is already shown
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Optional: A semi-transparent background to dim the screen
          if (backgroundColor != null)
            Positioned.fill(
              child: Container(
                color: backgroundColor!,
              ),
            ),
          Center(
            child: SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                strokeWidth: indicatorStrokeWidth,
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  bool get isShowing => _overlayEntry != null;
}