// Function to get your Material 3 ThemeData
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_fonts.dart';
import 'package:myapp/theme/app_theme_helper.dart';

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
    // headlineLarge: TextStyle(
    //   fontSize: 28,
    //   fontWeight: FontWeight.bold,
    //   color: customColorScheme.primary,
    // ),
    headlineLarge: TextStyle(
      //fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      fontSize: 28,
      color: customColorScheme.primary,
    ),
    // headlineLarge: GoogleFonts.poppins(
    //   fontSize: 28,
    //   fontWeight: FontWeight.bold,
    //   color: AppColors.danger,
    // ),

    // ex- 'Welcome back.'
    headlineMedium: TextStyle(
      //fontFamily: 'Montserrat',
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),

    // ex- 'Log in to your account'
    headlineSmall: TextStyle(
      //fontFamily: 'Montserrat',
      fontSize: 16,
      color: AppColors.textFaded,
    ),

    // // ex- 'Welcome back.'
    // headlineMedium: TextStyle(
    //   fontSize: 26,
    //   fontWeight: FontWeight.bold,
    //   color: AppColors.text,
    // ),

    // // ex- 'Log in to your account'
    // headlineSmall: TextStyle(fontSize: 16, color: AppColors.textFaded),

    // App Bar Title
    titleLarge: TextStyle(
      //fontFamily: 'Montserrat',
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

    labelSmall: TextStyle(fontSize: 14, color: customColorScheme.primary), //  ex - Forget Password text Button

    // Menucard Captions
    labelMedium: TextStyle(
      fontSize: 14,
      color: AppColors.text,
      fontWeight: FontWeight.w500,
    ),

    // bodyMedium: TextStyle(
    //   fontSize: 16,
    //   color: customColorScheme.onSurfaceVariant,
    // ),

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

  // Ex-Submit buttn
  final ElevatedButtonThemeData
  customElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: customColorScheme.primary, // Default background color
      foregroundColor: customColorScheme.onPrimary, // Default text/icon color
      minimumSize: const Size(double.infinity, 50), // Default size
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ), // Default shape
      textStyle: TextStyle(
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
      textStyle: TextStyle(fontSize: 14, color: customColorScheme.primary),
    ),
  );

  final DialogThemeData customDialogTheme = DialogThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: customColorScheme.onSurface,
    ),
    contentTextStyle: TextStyle(
      fontSize: 14,
      color: customColorScheme.onSurface,
    ),
    alignment: Alignment.center,
    shadowColor: AppColors.dialogShadowColor,
    elevation: 16,
  );

  final InputDecorationTheme customInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white, // Default fill color
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: AppColors.borderDark),
    hintStyle: const TextStyle(color: AppColors.borderDark),
    errorStyle: const TextStyle(color: AppColors.danger),

    enabledBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.standard,
    ),
    focusedBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.primaryFocused,
    ),
    errorBorder: AppThemeHelpers.getAppRoundedBorder(type: AppBorderType.error),
    focusedErrorBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.error,
    ),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      AppThemeHelpers.getFloatingLabelStyle,
    ),
  );

  // Add suitable themedata for switch here
  final SwitchThemeData customSwitchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return customColorScheme.onSurface.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return customColorScheme.primary;
      }
      return customColorScheme.outline;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return customColorScheme.onSurface.withOpacity(0.12);
      }
      if (states.contains(MaterialState.selected)) {
        return customColorScheme.primary.withOpacity(0.5);
      }
      return customColorScheme.surfaceContainerHigh;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.hovered)) {
        return customColorScheme.primary.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return customColorScheme.primary.withOpacity(0.12);
      }
      if (states.contains(MaterialState.pressed)) {
        return customColorScheme.primary.withOpacity(0.12);
      }
      return null; // No overlay by default
    }),
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
    inputDecorationTheme: customInputDecorationTheme,
    switchTheme: customSwitchTheme,
    fontFamily: AppFonts.primaryFont,
    // Add other theme properties as needed
  );
}
