import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/color_scheme_model.dart';
import 'package:myapp/providers/settings_provider.dart';

class AppColors {
  static ProviderContainer? _container;

  static void init(ProviderContainer container) {
    _container = container;
  }

  static AppColorScheme get _scheme {
    return _container!.read(settingsProvider).theme;
  }

  // Common Colors
  static Color get white => Colors.white;
  static Color get black => Colors.black;
  static Color get grey => Colors.grey;
  static Color get blueGrey => Colors.blueGrey;
  static Color get green => Colors.green;

  static Color get transparent => Colors.transparent;

  // FontAwsomeGradient Menu Icon Gradient
  static Color get gradColor1 => Colors.purpleAccent;
  static Color get gradColor2 => Colors.orangeAccent;

  static Color get primary => _scheme.primary;
  static Color get background => _scheme.background;
  static Color get secondary => _scheme.secondary;
  static Color get tertiary => _scheme.tertiary;
  static Color get disabled => _scheme.disabled;
  static Color get ondisabled => _scheme.onDisabled;
  static Color get onSurface => _scheme.onSurface;
  static Color get surface => _scheme.surface;

  static Color get text => _scheme.text;
  static Color get textSelection => _scheme.textSelection;
  static Color get textFaded => _scheme.textFaded;
  static Color get textSecondary => _scheme.textSecondary;
  static Color get overlayBackground => _scheme.overlayBackground;
  static Color get gridBackgroundColor => _scheme.gridBackgroundColor;
  static Color get border => _scheme.border;
  static Color get borderIntense => _scheme.borderIntense;
  static Color get success => _scheme.success;
  static Color get danger => _scheme.danger;
  static Color get warning => _scheme.warning;
  static Color get successLight => _scheme.successLight;
  static Color get dangerLight => _scheme.dangerLight;
  static Color get dialogShadowColor => _scheme.dialogShadowColor;
  static Color get removebtnColor => _scheme.removeBtnColor;
  static Color get editbtnColor => _scheme.editBtnColor;
  static Color get neutralLight => _scheme.neutralLight;
  static Color get neutralMedium => _scheme.neutralMedium;
  static Color get neutralStrong => _scheme.neutralStrong;
  static List<Color> get menuTileColors => _scheme.menuTileColors;
  static List<Color> get passwordStrengthBarIndicatorColors => _scheme.passwordStrengthBarIndicatorColors;
  static Color get cardBackground => _scheme.cardBackground;
}

// class AppColors {
//   // Prevent instantiation
//   AppColors._();

//   // Main Theme Colors
//   // static const Color primary = Color(0xFF0D47A1); // Dark Blue
//   // static const Color background = Color(0xFFE3F2FD); // Light Blue

//   static const Color primary = Color(0xFF0D47A1); // Dark Blue
//   static const Color background = Color(0xFFF0F5F9); // professional light blue-grey
//   static const Color secondary = Color(0xff546e7a);
//   static const Color tertiary = Color(0xFF90A4AE);
//   static const Color disabled = Color(0xFFD6E0EA);
//   static const Color ondisabled = Color(0xFF7A94B5);
//   static const Color white = Colors.white;
//   static const Color black = Colors.black;
//   static const Color text = Colors.black87;
//   static const Color textSelection = Color(0xFFBBDEFB);
//   static const Color textFaded = Colors.black54;
//   static const Color textSecondary = Colors.black54;
//   static const Color overlayBackground = Colors.black54;
//   static const Color gridBackgroundColor = Color(0xFFF8F7FA); // 0xFF prefix for opaque color

//   // Border Colors
//   static const Color border = Color(0xFFE0E0E0); // Light Gray
//   static const Color borderIntense = Color(0xFFBDBDBD); // Dark Gray

//   // Button/Snack Colors
//   static const Color success = Color(0xFF2E7D32); // Dark Green
//   static const Color danger = Color(0xFFC62828); // Dark Red
//   static const Color warning = Color(0xFFFFA500);

//   // Other Colors
//   static const Color transparent = Colors.transparent;
//   //static Color dialogShadowColor = Colors.black.withOpacity(0.4); //

//   static const Color dialogShadowColor = Color(0x66000000); // const version

//   static const Color successLight = Color(0xFFE8F5E9); // A very light green, suitable for backgrounds
//   static const Color dangerLight = Color(0xFFFFEBEE); // A very light red/pink, suitable for backgrounds

//   // Grid Button Icon Colors
//   static const Color removebtnColor = Color(0xFFB26363);
//   static const Color editbtnColor = Color(0xFFCEA14F);

//   // Grey Colors
//     static const Color neutralLight = Color(0xFFE0E0E0);
//     static const Color neutralMedium = Color(0xFF757575);
//     static const Color neutralStrong = Color(0xFF616161);

//   // Main Menu Tile Colors
//   static const List<Color> menuTileColors = [
//     Color(0xFF2F80ED), // Blue
//     Color(0xFF27AE60), // Green
//     Color(0xFFF2994A), // Orange
//     Color(0xFFEB5757), // Red
//     Color(0xFF9B51E0), // Purple
//     Color(0xFF56CCF2), // Light Blue
//   ];

//   // Password Strength
//   static const List<Color> passwordStrengthBarIndicatorColors = [
//     Colors.cyan,
//     Colors.blue,
//     Colors.purple,
//   ];

//   //[
//   //   Color(0xFF1976D2), // Material Blue
//   //   Color(0xFF388E3C), // Material Green
//   //   Color(0xFFF57C00), // Material Orange
//   //   Color(0xFFD32F2F), // Material Red
//   //   Color(0xFF7B1FA2), // Material Purple
//   //   Color(0xFF0097A7), // Teal
//   // ];

//   //  [
//   //     Color(0xFFE3000B), // Red
//   //     Color(0xFFFF8C42), // Orange
//   //     Color(0xFF2C7A4C), // Green
//   //     Color(0xFF1E5F8E), // Blue
//   //   ]
// }




// class AppColors {
//   static const AppColorScheme light = AppColorScheme(
//     primary: Color(0xFF0D47A1),
//     background: Color(0xFFF0F5F9),
//     secondary: Color(0xFF546E7A),
//     tertiary: Color(0xFF90A4AE),
//     disabled: Color(0xFFD6E0EA),
//     onDisabled: Color(0xFF7A94B5),
//     white: Colors.white,
//     black: Colors.black,
//     text: Colors.black87,
//     textSelection: Color(0xFFBBDEFB),
//     textFaded: Colors.black54,
//     textSecondary: Colors.black54,
//     overlayBackground: Colors.black54,
//     gridBackgroundColor: Color(0xFFF8F7FA),
//     border: Color(0xFFE0E0E0),
//     borderIntense: Color(0xFFBDBDBD),
//     success: Color(0xFF2E7D32),
//     danger: Color(0xFFC62828),
//     warning: Color(0xFFFFA500),
//     successLight: Color(0xFFE8F5E9),
//     dangerLight: Color(0xFFFFEBEE),
//     transparent: Colors.transparent,
//     dialogShadowColor: Color(0x66000000),
//     removeBtnColor: Color(0xFFB26363),
//     editBtnColor: Color(0xFFCEA14F),
//     neutralLight: Color(0xFFE0E0E0),
//     neutralMedium: Color(0xFF757575),
//     neutralStrong: Color(0xFF616161),
//     menuTileColors: [
//       Color(0xFF2F80ED),
//       Color(0xFF27AE60),
//       Color(0xFFF2994A),
//       Color(0xFFEB5757),
//       Color(0xFF9B51E0),
//       Color(0xFF56CCF2),
//     ],
//     passwordStrengthBarIndicatorColors: [
//       Colors.cyan,
//       Colors.blue,
//       Colors.purple,
//     ],
//   );

//   static const AppColorScheme dark = AppColorScheme(
//     primary: Color(0xFF90CAF9),
//     background: Color(0xFF121212),
//     secondary: Color(0xFFB0BEC5),
//     tertiary: Color(0xFF78909C),
//     disabled: Color(0xFF424242),
//     onDisabled: Color(0xFF9E9E9E),
//     white: Colors.white,
//     black: Colors.black,
//     text: Colors.white,
//     textSelection: Color(0xFF546E7A),
//     textFaded: Colors.white70,
//     textSecondary: Colors.white70,
//     overlayBackground: Colors.white24,
//     gridBackgroundColor: Color(0xFF1E1E2A),
//     border: Color(0xFF424242),
//     borderIntense: Color(0xFF616161),
//     success: Color(0xFF81C784),
//     danger: Color(0xFFE57373),
//     warning: Color(0xFFFFB74D),
//     successLight: Color(0xFF1B5E20),
//     dangerLight: Color(0xFFB71C1C),
//     transparent: Colors.transparent,
//     dialogShadowColor: Color(0xCC000000),
//     removeBtnColor: Color(0xFFEF9A9A),
//     editBtnColor: Color(0xFFFFCC80),
//     neutralLight: Color(0xFF424242),
//     neutralMedium: Color(0xFF9E9E9E),
//     neutralStrong: Color(0xFFBDBDBD),
//     menuTileColors: [
//       Color(0xFF64B5F6),
//       Color(0xFF81C784),
//       Color(0xFFFFB74D),
//       Color(0xFFE57373),
//       Color(0xFFBA68C8),
//       Color(0xFF4DD0E1),
//     ],
//     passwordStrengthBarIndicatorColors: [
//       Colors.lightBlueAccent,
//       Colors.lightGreenAccent,
//       Colors.purpleAccent,
//     ],
//   );
// }