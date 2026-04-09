import 'package:flutter/material.dart';

abstract class ColorPalette {
  // Main Theme Colors
  Color get primary;
  Color get background;
  Color get secondary;
  Color get tertiary;
  Color get disabled;
  Color get ondisabled;
  Color get white;
  Color get black;
  Color get text;
  Color get textSelection;
  Color get textFaded;
  Color get textSecondary;
  Color get overlayBackground;
  Color get lightLavender;

  // Border Colors
  Color get border;
  Color get borderDark;

  // Button/Snack Colors
  Color get success;
  Color get danger;
  Color get warning;

  // Other Colors
  Color get transparent => Colors.transparent;
  Color get dialogShadowColor;

  Color get successLight;
  Color get dangerLight;

  // Grid Button Icon Colors
  Color get removebtnColor;
  Color get editbtnColor;

  // Grey Colors
  Color get grey300 => const Color(0xFFE0E0E0);
  Color get grey600 => const Color(0xFF757575);
  Color get grey700 => const Color(0xFF616161);

  // Main Menu Tile Colors
  List<Color> get menuTileColors;

  // Password Strength
  List<Color> get passwordStrengthBarIndicatorColors => const [
        Colors.cyan,
        Colors.blue,
        Colors.purple,
      ];
}

// Added by Darshan R on 09/04/2026
class LightPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFF0D47A1);
  @override
  Color get background => const Color(0xFFF0F5F9);
  @override
  Color get secondary => const Color(0xff546e7a);
  @override
  Color get tertiary => const Color(0xFF90A4AE);
  @override
  Color get disabled => const Color(0xFFD6E0EA);
  @override
  Color get ondisabled => const Color(0xFF7A94B5);
  @override
  Color get white => Colors.white;
  @override
  Color get black => Colors.black;
  @override
  Color get text => Colors.black87;
  @override
  Color get textSelection => const Color(0xFFBBDEFB);
  @override
  Color get textFaded => Colors.black54;
  @override
  Color get textSecondary => Colors.black54;
  @override
  Color get overlayBackground => Colors.black54;
  @override
  Color get lightLavender => const Color(0xFFF8F7FA);

  @override
  Color get border => const Color(0xFFE0E0E0);
  @override
  Color get borderDark => const Color(0xFFBDBDBD);

  @override
  Color get success => const Color(0xFF2E7D32);
  @override
  Color get danger => const Color(0xFFC62828);
  @override
  Color get warning => const Color(0xFFFFA500);

  @override
  Color get dialogShadowColor => const Color(0x66000000);

  @override
  Color get successLight => const Color(0xFFE8F5E9);
  @override
  Color get dangerLight => const Color(0xFFFFEBEE);

  @override
  Color get removebtnColor => const Color(0xFFB26363);
  @override
  Color get editbtnColor => const Color(0xFFCEA14F);

  @override
  List<Color> get menuTileColors => const [
        Color(0xFF2F80ED),
        Color(0xFF27AE60),
        Color(0xFFF2994A),
        Color(0xFFEB5757),
        Color(0xFF9B51E0),
        Color(0xFF56CCF2),
      ];
}

// Added by Darshan R on 09/04/2026
class NordicPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFF88C0D0);
  @override
  Color get background => const Color(0xFF2E3440);
  @override
  Color get secondary => const Color(0xFF81A1C1);
  @override
  Color get tertiary => const Color(0xFF5E81AC);
  @override
  Color get disabled => const Color(0xFF3B4252);
  @override
  Color get ondisabled => const Color(0xFF4C566A);
  @override
  Color get white => const Color(0xFF3B4252); // Use a dark surface color for the 'white' property
  @override
  Color get black => const Color(0xFF2E3440);
  @override
  Color get text => const Color(0xFFE5E9F0);
  @override
  Color get textSelection => const Color(0xFF434C5E).withOpacity(0.5);
  @override
  Color get textFaded => const Color(0xFFD8DEE9);
  @override
  Color get textSecondary => const Color(0xFFD8DEE9);
  @override
  Color get overlayBackground => const Color(0xFF2E3440).withOpacity(0.7);
  @override
  Color get lightLavender => const Color(0xFF3B4252);

  @override
  Color get border => const Color(0xFF3B4252);
  @override
  Color get borderDark => const Color(0xFF4C566A);

  @override
  Color get success => const Color(0xFFA3BE8C);
  @override
  Color get danger => const Color(0xFFBF616A);
  @override
  Color get warning => const Color(0xFFEBCB8B);

  @override
  Color get dialogShadowColor => Colors.black.withOpacity(0.5);

  @override
  Color get successLight => const Color(0xFFA3BE8C).withOpacity(0.15);
  @override
  Color get dangerLight => const Color(0xFFBF616A).withOpacity(0.15);

  @override
  Color get removebtnColor => const Color(0xFFBF616A);
  @override
  Color get editbtnColor => const Color(0xFFD08770);

  @override
  List<Color> get menuTileColors => const [
        Color(0xFF88C0D0),
        Color(0xFF81A1C1),
        Color(0xFF8FBCBB),
        Color(0xFF5E81AC),
        Color(0xFFB48EAD),
        Color(0xFFD08770),
      ];
}

// Added by Darshan R on 09/04/2026
class DarkPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFF90CAF9);
  @override
  Color get background => const Color(0xFF121212);
  @override
  Color get secondary => const Color(0xFF03DAC6);
  @override
  Color get tertiary => const Color(0xFF3700B3);
  @override
  Color get disabled => Colors.white12;
  @override
  Color get ondisabled => Colors.white38;
  @override
  Color get white => const Color(0xFF1E1E1E); // Use a dark surface color for the 'white' property
  @override
  Color get black => Colors.black;
  @override
  Color get text => Colors.white.withOpacity(0.87);
  @override
  Color get textSelection => const Color(0xFF90CAF9).withOpacity(0.4);
  @override
  Color get textFaded => Colors.white60;
  @override
  Color get textSecondary => Colors.white70;
  @override
  Color get overlayBackground => Colors.black87;
  @override
  Color get lightLavender => const Color(0xFF1E1E1E);

  @override
  Color get border => Colors.white24;
  @override
  Color get borderDark => Colors.white38;

  @override
  Color get success => const Color(0xFF81C784);
  @override
  Color get danger => const Color(0xFFE57373);
  @override
  Color get warning => const Color(0xFFFFB74D);

  @override
  Color get dialogShadowColor => Colors.black;

  @override
  Color get successLight => const Color(0xFF81C784).withOpacity(0.1);
  @override
  Color get dangerLight => const Color(0xFFE57373).withOpacity(0.1);

  @override
  Color get removebtnColor => const Color(0xFFE57373);
  @override
  Color get editbtnColor => const Color(0xFFFFB74D);

  @override
  List<Color> get menuTileColors => const [
        Color(0xFF90CAF9),
        Color(0xFF81C784),
        Color(0xFFFFB74D),
        Color(0xFFF06292),
        Color(0xFFBA68C8),
        Color(0xFF4DB6AC),
      ];
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final ColorPalette palette;

  AppColorsExtension({required this.palette});

  @override
  AppColorsExtension copyWith({ColorPalette? palette}) {
    return AppColorsExtension(palette: palette ?? this.palette);
  }

  @override
  AppColorsExtension lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return this;
  }
}

class AppColors {
  // Prevent instantiation
  AppColors._();

  // KEEP STATIC CONST FOR BACKWARD COMPATIBILITY
  // Main Theme Colors
  // static const Color primary = Color(0xFF0D47A1); // Dark Blue
  // static const Color background = Color(0xFFE3F2FD); // Light Blue 

  static const Color primary = Color(0xFF0D47A1); // Dark Blue
  static const Color background = Color(0xFFF0F5F9); // professional light blue-grey
  static const Color secondary = Color(0xff546e7a);
  static const Color tertiary = Color(0xFF90A4AE); 
  static const Color disabled = Color(0xFFD6E0EA);
  static const Color ondisabled = Color(0xFF7A94B5);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color text = Colors.black87;
  static const Color textSelection = Color(0xFFBBDEFB);
  static const Color textFaded = Colors.black54;
  static const Color textSecondary = Colors.black54;
  static const Color overlayBackground = Colors.black54;
  static const Color lightLavender = Color(0xFFF8F7FA); // 0xFF prefix for opaque color

  // Border Colors
  static const Color border = Color(0xFFE0E0E0); // Light Gray
  static const Color borderDark = Color(0xFFBDBDBD); // Dark Gray

  // Button/Snack Colors
  static const Color success = Color(0xFF2E7D32); // Dark Green
  static const Color danger = Color(0xFFC62828); // Dark Red
  static const Color warning = Color(0xFFFFA500);

  // Other Colors
  static const Color transparent = Colors.transparent;
  //static Color dialogShadowColor = Colors.black.withOpacity(0.4); //

  static const Color dialogShadowColor = Color(0x66000000); // const version

  static const Color successLight = Color(0xFFE8F5E9); // A very light green, suitable for backgrounds
  static const Color dangerLight = Color(0xFFFFEBEE); // A very light red/pink, suitable for backgrounds

  // Grid Button Icon Colors
  static const Color removebtnColor = Color(0xFFB26363);
  static const Color editbtnColor = Color(0xFFCEA14F);

  // Grey Colors
    static const Color grey300 = Color(0xFFE0E0E0); 
    static const Color grey600 = Color(0xFF757575);
    static const Color grey700 = Color(0xFF616161); 

  // Main Menu Tile Colors
  static const List<Color> menuTileColors = [
    Color(0xFF2F80ED), // Blue
    Color(0xFF27AE60), // Green
    Color(0xFFF2994A), // Orange
    Color(0xFFEB5757), // Red
    Color(0xFF9B51E0), // Purple
    Color(0xFF56CCF2), // Light Blue
  ];

  // Password Strength
  static const List<Color> passwordStrengthBarIndicatorColors = [
    Colors.cyan,
    Colors.blue,
    Colors.purple,
  ];


  //[
  //   Color(0xFF1976D2), // Material Blue
  //   Color(0xFF388E3C), // Material Green
  //   Color(0xFFF57C00), // Material Orange
  //   Color(0xFFD32F2F), // Material Red
  //   Color(0xFF7B1FA2), // Material Purple
  //   Color(0xFF0097A7), // Teal
  // ];

  //  [
  //     Color(0xFFE3000B), // Red
  //     Color(0xFFFF8C42), // Orange
  //     Color(0xFF2C7A4C), // Green
  //     Color(0xFF1E5F8E), // Blue
  //   ]
}
