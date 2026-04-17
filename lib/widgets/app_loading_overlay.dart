import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_loading_indicator.dart';

// Common Loading Screen of the application On API calls
class AppLoadingOverlay {
  OverlayEntry? _overlayEntry;
  //final Color? backgroundColor;

  AppLoadingOverlay();
  void show(BuildContext context) {
    if (_overlayEntry != null) {
      // Overlay is already shown
      return;
    }
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              //if (backgroundColor != null)
                Positioned.fill(child: Container(color: AppColors.overlayBackground)),
              AppLoadingIndicator(),
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
