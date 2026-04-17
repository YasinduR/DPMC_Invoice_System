import 'package:flutter/material.dart';

class AppColorScheme {
  final Color primary;
  final Color background;
  final Color secondary;
  final Color tertiary;
  final Color disabled;
  final Color onDisabled;
  final Color surface;
  final Color onSurface;
  final Color text;
  final Color textSelection;
  final Color textFaded;
  final Color textSecondary;
  final Color overlayBackground;
  final Color gridBackgroundColor;
  final Color border;
  final Color borderIntense;
  final Color success;
  final Color danger;
  final Color warning;
  final Color successLight;
  final Color dangerLight;
  final Color dialogShadowColor;
  final Color removeBtnColor;
  final Color editBtnColor;
  // Grey Variations
  final Color neutralLight;
  final Color neutralMedium;
  final Color neutralStrong;
  //
  final List<Color> menuTileColors;
  final List<Color> passwordStrengthBarIndicatorColors;

  final Color cardBackground;

  const AppColorScheme({
    required this.primary,
    required this.background,
    required this.secondary,
    required this.tertiary,
    required this.disabled,
    required this.onDisabled,
    required this.surface,
    required this.onSurface,
    required this.text,
    required this.textSelection,
    required this.textFaded,
    required this.textSecondary,
    required this.overlayBackground,
    required this.border,
    required this.borderIntense,
    required this.success,
    required this.danger,
    required this.warning,
    required this.successLight,
    required this.dangerLight,
    required this.dialogShadowColor,
    required this.removeBtnColor,
    required this.editBtnColor,
    required this.menuTileColors,
    required this.passwordStrengthBarIndicatorColors,
    required this.neutralLight,
    required this.neutralMedium,
    required this.neutralStrong,
    required this.gridBackgroundColor,
    required this.cardBackground,
  });
}

//     static const Color neutralLight = Color(0xFFE0E0E0); 
//     static const Color neutralMedium = Color(0xFF757575);
//     static const Color neutralStrong = Color(0xFF616161); 