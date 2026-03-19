import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/services/log_text_service.dart';
//import 'package:myapp/services/location_service.dart';

import 'package:myapp/services/notification_services.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:myapp/helpers/app_nav_items.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_navigation_bar.dart';

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications
  //await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
  await Config.initialize();
  await AppRoutes.initialize(); // Collect Screen data from db and create App Routes
  //AttendanceReminderManager.setupDailyAttendanceNotifications();

  // Initialize NotificationService
  await NotificationService.initialize();
  await LogTextService.initialize(); // DPMC Folder Access

  // Register the WorkManager task once at app startup
  //await registerSimpleWorkManagerReminder();
  //final locationService = LocationService();
  // final bool locationReady = await locationService.initializeLocationAndPermissions();

  // if (locationReady) {
  runApp(
    const ProviderScope(child: MyApp()),
  ); // Run app with riverpod provider scope
  //}
  // final locationService = LocationService();
  // await locationService.initializeLocationAndPermissions();

  // runApp(
  //   const ProviderScope(child: MyApp()),
  // ); // Run app with riverpod provider scope
  //   // Initialize Workmanager
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentRoute = ref.watch(currentRouteProvider);
    
    final hideNavBarRoutes = [
      AppRoutes.login,
      AppRoutes.forgetPassword,
      AppRoutes.initializer,
    ];
    
    final shouldShowNav = authState.isLoggedIn &&
        !hideNavBarRoutes.contains(currentRoute);
    
    final int? currentIndex = currentRoute != null
        ? AppNavItems.getNavIndex(currentRoute.replaceFirst('/', ''))
        : null;
        
    //final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Invoice App',
      theme: appTheme(context),
      home: Scaffold(
        body: Navigator(
          initialRoute: AppRoutes.initializer,
          onGenerateRoute: (settings) {
            // Update current route in provider
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(currentRouteProvider.notifier).state = settings.name;
            });
            return AppRouter.onGenerateRoute(settings, ref);
          },
        ),
        bottomNavigationBar: shouldShowNav
            ? AppNavFooter(
                currentIndex: currentIndex,
                confirmOnNavigate: false,
              )
            : null,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
