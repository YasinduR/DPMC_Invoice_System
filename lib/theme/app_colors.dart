import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Main Theme Colors
  // static const Color primary = Color(0xFF0D47A1); // Dark Blue
  // static const Color background = Color(0xFFE3F2FD); // Light Blue  Previous Dont Remove
  static const Color primary = Color(0xFF0D47A1); // Dark Blue
  static const Color background = Color(
    0xFFF0F5F9,
  ); // Light Blue: Changed to a more muted, professional light blue-grey
  static const Color secondary = Color(0xff546e7a);
  static const Color tertiary = Color(0xFF90A4AE); // Blue Grey 300
  //static const Color disabled = Colors.grey;
  static const Color disabled = Color(0xFFD6E0EA);
  static const Color ondisabled = Color(0xFF7A94B5);
  static const Color white = Colors.white;
  static const Color text = Colors.black87;
  static const Color textSelection = Color(0xFFBBDEFB);
  static const Color textFaded = Colors.black54;
  static const Color textSecondary = Colors.black54;
  static const Color overlayBackground = Colors.black54;
  static const Color lightLavender = Color(
    0xFFF8F7FA,
  ); // 0xFF prefix for opaque color

  // Border Colors
  static const Color border = Color(0xFFE0E0E0); // Light Gray
  static const Color borderDark = Color(0xFFBDBDBD); // Dark Gray

  // Button/Snack Colors
  static const Color success = Color(0xFF2E7D32); // Dark Green
  static const Color danger = Color(0xFFC62828); // Dark Red
  static const Color warning = Color(0xFFFFA500);

  // Other Colors
  static const Color transparent = Colors.transparent;
  static Color dialogShadowColor = Colors.black.withOpacity(0.4); //

  static const Color successLight = Color(
    0xFFE8F5E9,
  ); // A very light green, suitable for backgrounds
  static const Color dangerLight = Color(
    0xFFFFEBEE,
  ); // A very light red/pink, suitable for backgrounds

  // Grid Button Icon Colors
  static const Color removebtnColor = disabled;
  static const Color editbtnColor = disabled;

}
