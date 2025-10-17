import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_router.dart';

import 'package:myapp/services/notification_services.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;




Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications
  //await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
  await AppRoutes.initialize(); // Collect Screen data from db and create App Routes
  //AttendanceReminderManager.setupDailyAttendanceNotifications();

  // Initialize NotificationService
  await NotificationService.initialize();

  // Register the WorkManager task once at app startup
  //await registerSimpleWorkManagerReminder();

  runApp(
    const ProviderScope(child: MyApp()),
  ); // Run app with riverpod provider scope
    // Initialize Workmanager


}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Invoice App',
      theme: appTheme(context),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}