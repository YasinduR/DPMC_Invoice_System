import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

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
