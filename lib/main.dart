import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_router.dart';
// import 'package:myapp/screens/login/login_screen.dart';
// import 'package:myapp/screens/main_menu/main_menu_screen.dart';
import 'package:myapp/services/notification_services.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
//import 'package:myapp/providers/auth_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications
  await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
  await AppRoutes.initialize(); // Collect Screen data from db and create App Routes 
  runApp(const ProviderScope(child: MyApp())); // Run app with riverpod provider scope
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primary,             // Color of the blinking cursor
            selectionColor: AppColors.textSelection,    // Color of the selected text background
            selectionHandleColor:  AppColors.primary,   // Color of the draggable selection handles
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    //  home: authState.isLoggedIn && !authState.requiresPasswordChange ? const MainMenuScreen() : const LoginScreen(),
      //home: authState.isLoggedIn ? const MainMenuScreen() : const LoginScreen(),
      initialRoute: AppRoutes.login,       
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
