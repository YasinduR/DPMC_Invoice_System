import 'package:az_notification_hub/az_notification_hub.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app_router.dart';
// import 'package:myapp/screens/login/login_screen.dart';
// import 'package:myapp/screens/main_menu/main_menu_screen.dart';
import 'package:myapp/services/notification_services.dart';
// import 'package:myapp/services/push_notification_service.dart';
//import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
//import 'package:myapp/providers/auth_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

// import 'package:firebase_messaging/firebase_messaging.dart'; // Required for FirebaseMessaging.onBackgroundMessage



// Future<void> main() async {
//   // Ensure that Flutter bindings are initialized before calling native code
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // Time Zone for scheduled notifications
//   await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
//   await AppRoutes.initialize(); // Collect Screen data from db and create App Routes 
//   runApp(const ProviderScope(child: MyApp())); // Run app with riverpod provider scope
// }

@pragma('vm:entry-point')
Future<void> _onBackgroundMessageReceived(Map<String, dynamic> message) async {
  print('onBackgrounMessage: $message');
  NotificationService.showNotification(title: 'DPMC Invoice System', body: message.toString());
}

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase Core as early as possible
  //await Firebase.initializeApp();

  AzureNotificationHub.instance.registerBackgroundMessageHandler(_onBackgroundMessageReceived);
  await AzureNotificationHub.instance.start();

  // 3. Initialize Time Zones for scheduled notifications (if your existing NotificationService uses it)
  tz.initializeTimeZones();

  // 4. Initialize your existing Local Notification Service
  await NotificationService.initialize();

  // 5. Initialize the new Push Notification Service (FCM & Azure)
  //await PushNotificationService().initialize();

  // 6. Collect Screen data from db and create App Routes
  await AppRoutes.initialize();

  // Run app with riverpod provider scope
  runApp(const ProviderScope(child: MyApp()));
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
