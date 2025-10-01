import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/attendance/attendance_screen.dart';
import 'package:myapp/screens/change_password/change_pwd_screen.dart';
import 'package:myapp/screens/error_screen/error_screen.dart';
import 'package:myapp/screens/forget_password/forget_pwd_screen.dart';
import 'package:myapp/screens/invoice/invoice_screen.dart';
import 'package:myapp/screens/login/login_screen.dart';
import 'package:myapp/screens/main_menu/main_menu_screen.dart';
import 'package:myapp/screens/protected_screen/permission_screen.dart';
import 'package:myapp/screens/print_invoice/print_invoice_screen.dart';
import 'package:myapp/screens/profile/profile_screen.dart';
import 'package:myapp/screens/reciept/reciept_screen.dart';
import 'package:myapp/screens/reprint/reprint_screen.dart';
import 'package:myapp/screens/returns/return_screen.dart';
import 'package:myapp/screens/route_selection/route_selection.dart';
import 'package:myapp/screens/setup_print/setup_print_screen.dart';
import 'package:myapp/screens/test_screens/fraud_menu.dart';
import 'package:myapp/screens/test_screens/test_notify.dart';

// This will link main.dart with the approutes with handling permission

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings, WidgetRef ref) {
    final String? routeName = settings.name;

    //---- IMPORTANT  SECTION----//
    // Enable this Section Later

    // This SECTION to Check whether the user has logged in before routing to non public routes

    final authState = ref.read(authProvider);
    final publicRoutes = [
      AppRoutes.login,
      AppRoutes.forgetPassword,
      AppRoutes.fraudMenu,
    ];


    // if (publicRoutes.contains(routeName)) {
    // } else if (!authState.isLoggedIn) {
    //   return MaterialPageRoute(
    //     builder:
    //         (_) => const ErrorScreen(
    //           title: 'Access Denied',
    //           message: 'No User has logged in',
    //         ),
    //   );
    // }
    // 1. If not logged in AND trying to access a non-public route
    if (!authState.isLoggedIn && !publicRoutes.contains(routeName)) {
      return MaterialPageRoute(
        builder: (_) => const ErrorScreen(
          title: 'Access Denied',
          message: 'No user has logged in.',
        ),
        settings: const RouteSettings(name: AppRoutes.login), // Redirect to login
      );
    }

    // 2. If logged in but requires password change AND trying to access ANY route other than login
    if (authState.isLoggedIn && authState.requiresPasswordChange && routeName != AppRoutes.login) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(), // Redirect to LoginScreen, which will show set password form
        settings: const RouteSettings(name: AppRoutes.login), // Keep route name as login
      );
    }

    // // 3. If it's the login route and the user is already logged in (and doesn't need password change),
    // //    redirect them to the main menu. This prevents logged-in users from seeing the login screen.
    // if (routeName == AppRoutes.login && authState.isLoggedIn && !authState.requiresPasswordChange) {
    //   return MaterialPageRoute(builder: (_) => const MainMenuScreen(), settings: const RouteSettings(name: AppRoutes.mainMenu));
    // }


    //---- END OF THE SECTION----//

    final String? screenId = AppRoutes.routeToScreenIdMap[routeName];
    final String? screenTitle = AppRoutes.routeToScreenTitleMap[routeName];

    WidgetBuilder? builder = _getRouteBuilder(routeName);

    if (builder == null) {
      return MaterialPageRoute(
        builder:
            (_) => const ErrorScreen(
              message: 'Oops! The page you are looking for does not exist.',
            ),
      );
      // --------------------------
    }
    if (screenId != null) {
      // Screen Id will be assign to all menu-screens
      return MaterialPageRoute(
        builder:
            (_) => PermissionCheckScreen(
              screenId: screenId,
              screenTitle: screenTitle ?? ' ',
              destinationScreenBuilder: builder,
            ),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    ); //For Main Menu, Login Page  and Forget Password
  }

  static WidgetBuilder? _getRouteBuilder(String? routeName) {
    switch (routeName) {
      case AppRoutes.login:
        return (context) => const LoginScreen();
      case AppRoutes.mainMenu:
        return (context) => const MainMenuScreen();
      case AppRoutes.forgetPassword:
        return (context) => const ForgetPasswordScreen();
      case AppRoutes.fraudMenu:
        return (context) => const FraudMenuScreen();

      // Routes dynamically generated routes
      case '/setupPrint':
        return (context) => const SetupPrintScreen();
      case '/invoice':
        return (context) => const InvoiceScreen();
      case '/printInvoice':
        return (context) => const PrintInvoiceScreen();
      case '/profile':
        return (context) => const ProfileScreen();
      case '/testNotify':
        return (context) => const TestPage();
      case '/reciept':
        return (context) => const RecieptScreen();
      case '/returns':
        return (context) => const ReturnScreen();
      case '/reprint':
        return (context) => const ReprintScreen();
      case '/region':
        return (context) => const RouteSelectionScreen();
      case '/changePassword':
        return (context) => const ChangePasswordScreen();
      case '/attendance':
        return (context) => const AttendanceScreen();

      default:
        return null; // Return Null for the invalid routes
    }
  }
}
