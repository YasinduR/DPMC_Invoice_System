import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/services/firebase_notification_service.dart';

import 'package:myapp/services/notification_services.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;

// NEW: Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Top-level function to handle background messages from Firebase
// It must not be an anonymous function, and it must be a top-level function outside of any class.
@pragma('vm:entry-point') // Required for Flutter 3.3+ for background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // NEW: Ensure Firebase is initialized for background messages
  await Firebase.initializeApp();
  print('FCM Background: Handling a background message: ${message.messageId}');
  // You can perform heavy work here, like saving to a database,
  // or showing a local notification using flutter_local_notifications.
  // We'll use NotificationService to show a local notification here.
  if (message.notification != null) {
    await FirebaseNotificationService.showNotification(
      id: message.hashCode, // A unique ID for this notification
      title: message.notification!.title,
      body: message.notification!.body,
      payload: message.data.toString(), // Pass data as payload
    );
  }
}


Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications

  // NEW: Initialize Firebase
  await Firebase.initializeApp();

  // NEW: Set the top-level background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



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
      //navigatorKey: FirebaseNotificationService.navigatorKey,
      title: 'Invoice App',
      theme: appTheme(context),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}