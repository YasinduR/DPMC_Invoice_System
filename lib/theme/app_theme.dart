// Function to get your Material 3 ThemeData
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Function intialize all Theme Data (Material 3 ThemeData)
ThemeData appTheme(BuildContext context) {
  // Main ColorScheme
  final ColorScheme customColorScheme = ColorScheme.fromSeed(
    surface: AppColors.background, // Your custom background color for surfaces
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.danger,
    tertiary: AppColors.success,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onTertiary: AppColors.white,

    brightness: Brightness.light, // Or Brightness.dark for a dark theme
  );

  // TextTheme
  final TextTheme customTextTheme = TextTheme(
    // ex - 'Invoice System'
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: customColorScheme.primary,
    ),

    // ex- 'Welcome back.'
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),

    // ex- 'Log in to your account'
    headlineSmall: TextStyle(fontSize: 16, color: AppColors.textFaded),

    // App Bar Title
    titleLarge: TextStyle(
      // For AppBar titles
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color:
          customColorScheme.primary, // Or onBackground, depending on contrast
    ),

    
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: customColorScheme.onPrimary, // Text/icon color on primary button
    ),


    labelSmall: TextStyle(fontSize: 14, color: customColorScheme.primary),

    // Menucard Captions
    labelMedium: TextStyle(
      fontSize: 14,
      color: AppColors.text,
      fontWeight: FontWeight.w500,
    ),

    bodyMedium: TextStyle(
      fontSize: 16,
      color: customColorScheme.onSurfaceVariant,
    ),

    // You can add more text styles as needed
  );

  // Selected Text On text fields
  final TextSelectionThemeData customTextSelectionThemeData =
      TextSelectionThemeData(
        cursorColor: customColorScheme.primary,
        selectionColor: AppColors.textSelection,
        selectionHandleColor: customColorScheme.primary,
      );

  final AppBarTheme customAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.transparent,
    elevation: 0, // No shadow under the AppBar
    centerTitle: true, // Center title for consistency with your previous choice
    titleTextStyle: customTextTheme.titleLarge,
    iconTheme: const IconThemeData(
      // Define the style for AppBar icons (like back button)
      color: AppColors.primary,
    ),
  );

  final ElevatedButtonThemeData
  customElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: customColorScheme.primary, // Default background color
      foregroundColor: customColorScheme.onPrimary, // Default text/icon color
      minimumSize: const Size(double.infinity, 50), // Default size
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ), // Default shape
      textStyle:
          TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: customColorScheme.onPrimary, // Text/icon color on primary button
    ), // Default text style for button labels
    ),
  );

  // EX- Forget pwd
  final TextButtonThemeData customTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: customColorScheme.primary,
      textStyle: TextStyle(
        fontSize: 14,
        color: customColorScheme.primary,
      ),
    ),
  );

  final DialogThemeData customDialogTheme = DialogThemeData(
    backgroundColor: customColorScheme.surface,
    surfaceTintColor: customColorScheme.primary.withOpacity(0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    titleTextStyle: customTextTheme.titleLarge?.copyWith(
      color: customColorScheme.onSurface, // Ensure title text color is appropriate
    ),
    contentTextStyle: customTextTheme.bodyMedium?.copyWith(
      color: customColorScheme.onSurface.withOpacity(0.8), // Slightly subdued content color
    ),
    alignment: Alignment.center,
    elevation: 8,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: customColorScheme,
    textSelectionTheme: customTextSelectionThemeData,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: customAppBarTheme,
    textTheme: customTextTheme,
    elevatedButtonTheme: customElevatedButtonTheme,
    textButtonTheme: customTextButtonTheme,
    dialogTheme: customDialogTheme,
    // Add other theme properties as needed

  );
}
