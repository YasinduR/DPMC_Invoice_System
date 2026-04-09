// Function to get your Material 3 ThemeData
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_fonts.dart';
import 'package:myapp/theme/app_theme_helper.dart';

// Function intialize all Theme Data (Material 3 ThemeData)
ThemeData appTheme(BuildContext context, {String themeMode = 'Light'}) {
  ColorPalette palette;
  if (themeMode == 'Dark') {
    palette = DarkPalette();
  } else if (themeMode == 'Nordic Dark') {
    palette = NordicPalette();
  } else {
    palette = LightPalette();
  }

  final bool isDark = themeMode != 'Light';

  // Main ColorScheme
  final ColorScheme customColorScheme = ColorScheme.fromSeed(
    seedColor: palette.primary,
    primary: palette.primary,
    secondary: palette.secondary,
    tertiary: palette.tertiary,
    surface: palette.background,
    onPrimary: palette.white,
    onSecondary: palette.white,
    onTertiary: palette.white,
    onSurface: palette.text,
    brightness: isDark ? Brightness.dark : Brightness.light, // Or Brightness.dark for a dark theme
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
      color: palette.primary,
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
      color: palette.text,
    ),
    // ex- 'Log in to your account'
    headlineSmall: TextStyle(
      //fontFamily: 'Montserrat',
      fontSize: 16,
      color: palette.textFaded,
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
      color: palette.primary, // Or onBackground, depending on contrast
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: palette.white, // Text/icon color on primary button
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      color: palette.primary,
    ), //  ex - Forget Password text Button
    // Menucard Captions
    labelMedium: TextStyle(
      fontSize: 14,
      color: palette.text,
      //fontWeight: FontWeight.w500,
      fontWeight: FontWeight.bold,
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
        cursorColor: palette.primary,
        selectionColor: palette.textSelection,
        selectionHandleColor: palette.primary,
      );

  final AppBarTheme customAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0, // No shadow under the AppBar
    centerTitle: true, // Center title for consistency with your previous choice
    titleTextStyle: customTextTheme.titleLarge,
    iconTheme: IconThemeData(
      // Define the style for AppBar icons (like back button)
      color: palette.primary,
    ),
  );

  // Ex-Submit buttn
  // final ElevatedButtonThemeData
  // customElevatedButtonTheme = ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: customColorScheme.primary, // Default background color
  //     foregroundColor: customColorScheme.onPrimary, // Default text/icon color
  //     minimumSize: const Size(double.infinity, 50), // Default size
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(30),
  //     ), // Default shape
  //     textStyle: TextStyle(
  //       fontSize: 16,
  //       fontWeight: FontWeight.bold,
  //       color: customColorScheme.onPrimary, // Text/icon color on primary button
  //     ), // Default text style for button labels
  //   ),
  // );

  final ElevatedButtonThemeData customElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, 50),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          //  Background color (enabled & disabled)
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return palette.disabled; // Disabled background
            }
            return palette.primary; // Enabled
          }),
          // Text & icon color (enabled & disabled)
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return palette.ondisabled; // Disabled text
            }
            return palette.white; // Enabled
          }),
          //  Text style (AutoSizeText will inherit this)
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // Optional: remove elevation when disabled
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            return 2;
          }),
        ),
      );

  // EX- Forget pwd
  final TextButtonThemeData customTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: palette.primary,
      textStyle: TextStyle(fontSize: 14, color: palette.primary),
    ),
  );

  final DialogThemeData customDialogTheme = DialogThemeData(
    backgroundColor: palette.white,
    surfaceTintColor: palette.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: palette.text,
    ),
    contentTextStyle: TextStyle(
      fontSize: 14,
      color: palette.text,
    ),
    alignment: Alignment.center,
    shadowColor: palette.dialogShadowColor,
    elevation: 16,
  );

  final InputDecorationTheme customInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: palette.white, // Default fill color
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: palette.borderDark),
    hintStyle: TextStyle(color: palette.borderDark),
    errorStyle: TextStyle(color: palette.danger),
    enabledBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.standard,
      color: palette.borderDark,
    ),
    focusedBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.primaryFocused,
      color: palette.primary,
    ),
    errorBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.error,
      color: palette.danger,
    ),
    focusedErrorBorder: AppThemeHelpers.getAppRoundedBorder(
      type: AppBorderType.error,
      color: palette.danger,
    ),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      (states) => AppThemeHelpers.getFloatingLabelStyle(states, palette: palette),
    ),
  );

  // Add suitable themedata for switch here
  final SwitchThemeData customSwitchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return palette.text.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return palette.primary;
      }
      return palette.borderDark;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return palette.text.withOpacity(0.12);
      }
      if (states.contains(MaterialState.selected)) {
        return palette.primary.withOpacity(0.5);
      }
      return palette.disabled;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.hovered)) {
        return palette.primary.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return palette.primary.withOpacity(0.12);
      }
      if (states.contains(MaterialState.pressed)) {
        return palette.primary.withOpacity(0.12);
      }
      return null; // No overlay by default
    }),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: customColorScheme,
    scaffoldBackgroundColor: palette.background,
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
    extensions: [
      AppColorsExtension(palette: palette),
    ],
  );
}
