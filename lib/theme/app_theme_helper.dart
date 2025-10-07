import 'package:flutter/material.dart';
import 'app_colors.dart'; 

/// Defines the different common types of rounded borders for AppTextField.
enum AppBorderType {
  none,
  /// A standard border, typically for the enabled state.
  standard,
  /// A primary-colored border, typically for the focused state.
  primaryFocused,
  /// A danger-colored border, typically for error states (focused or unfocused).
  error,
}

// Improve this later to Get custom themes outside main theme.dart file
class AppThemeHelpers {
  AppThemeHelpers._(); 

  // Base border radius for all text fields
  static const double _defaultBorderRadius = 12.0;

  static OutlineInputBorder getAppRoundedBorder({
    AppBorderType type = AppBorderType.standard,
    Color? color,
    double? width,
  }) {
    BorderSide borderSide;

    switch (type) {
      case AppBorderType.none:
        borderSide = BorderSide.none;
        break;
      case AppBorderType.standard:
        borderSide = BorderSide(
          color: color ?? AppColors.borderDark,
          width: width ?? 1.0,
        );
        break;
      case AppBorderType.primaryFocused:
        borderSide = BorderSide(
          color: color ?? AppColors.primary,
          width: width ?? 2.0,
        );
        break;
      case AppBorderType.error:
        borderSide = BorderSide(
          color: color ?? AppColors.danger,
          width: width ?? 2.0,
        );
        break;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_defaultBorderRadius),
      borderSide: borderSide,
    );
  }

  // Floating Label of Text Fields
  static TextStyle getFloatingLabelStyle(Set<MaterialState> states) {
    if (states.contains(MaterialState.error)) {
      return const TextStyle(color: AppColors.danger);
    }
    if (states.contains(MaterialState.focused)) {
      return const TextStyle(color: AppColors.primary);
    }
    return const TextStyle(color: AppColors.borderDark);
  }

  static ButtonStyle getHelperIconButtonStyle() { // Helper Icon Button Style ( ? )
    return IconButton.styleFrom(
      backgroundColor:  AppColors.primary,
      foregroundColor:  AppColors.white,
      padding: const EdgeInsets.all(14),
    );
  }
  // Add more similar methods for other styles to make styles more centralize

}