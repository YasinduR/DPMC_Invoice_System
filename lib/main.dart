import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/services/notification_services.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;



// --- Background Service Entry Point ---
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  try {
    if (service is AndroidServiceInstance) {
    }

    service.invoke('update'); // This is a general 'update' event to the UI

    _startPeriodicTasks(service); // This function will now handle its own notification setup

  } catch (e) {
   // print('onStart error during initialization: $e');
    service.stopSelf();
  }

  service.on('stopService').listen((event) {
    //print("Background process is now stopped via UI request.");
    service.stopSelf();
  });
}

// ... rest of initializeService() remains the same ...

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      initialNotificationTitle: "DPMC Invoice System",
      initialNotificationContent: "DPMC Invoice System Services Initialized",
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false, // Change to false for iOS
      onForeground: onStart,
    ),
  );
  await FlutterBackgroundService().startService(); // Calls the static startService
}


void _startPeriodicTasks(ServiceInstance service) {
  int counter = 0;

  final FlutterLocalNotificationsPlugin _backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon'); // Confirm if 'app_icon' or 'ic_launcher'

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'DPMC-Invoice-System', // Channel ID - MUST match what show() uses below
    'Notification Channel',
    description: 'DPMC Invoice System notifications',
    importance: Importance.max,
    playSound: true,
  );

  // Create the channel for Android 8.0+
  _backgroundNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  _backgroundNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) async {
      // Handle notification tap when app is in foreground from background service
    },
    onDidReceiveBackgroundNotificationResponse: (response) async {
      // Handle notification tap when app is in background/killed from background service
    },
  );
  // End of one-time notification setup for background isolate


  // Define notification details ONCE for re-use
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'DPMC-Invoice-System', // MUST match the channel ID created above!
        'Notification Channel',
        channelDescription: 'DPMC Invoice System',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: '@mipmap/launcher_icon', // Confirm if 'app_icon' or 'ic_launcher'
      );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);


  Timer.periodic(const Duration(seconds: 30), (timer) async {
    try {
      counter++;

      if (service is AndroidServiceInstance) {
        //final isForeground = await service.isForegroundService();
        //if (isForeground) {
          final now = DateFormat('HH:mm:ss').format(DateTime.now());

          // await service.setForegroundNotificationInfo(
          //   title: "Service Active",
          //   content: "Update #$counter at $now",
          // );

          // Direct call to show notification
          await _backgroundNotificationsPlugin.show(
            DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
            "Attendance Start Reminder",
            "It is $now ! Please Start your attendance",
            platformChannelSpecifics, // Use the defined details
            payload: 'foreground_periodic',
          );
          service.invoke('update', {
            "counter": counter,
            "time": now,
          });
      //  } else {
          //final now = DateFormat('HH:mm:ss').format(DateTime.now());
          // Direct call to show notification
          // await _backgroundNotificationsPlugin.show(
          //   DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
          //   "Background Update",
          //   "Service running in Background at $now",
          //   platformChannelSpecifics, // Use the defined details
          //   payload: 'background_periodic',
          // );
       // }
      }

      print('Background task update: #$counter at ${DateFormat('HH:mm:ss').format(DateTime.now())}');
    } catch (e) {
      print('Background task error within periodic timer: $e');
      // The PlatformException from permission_handler should now be gone.
    }
  });
}



// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//       initialNotificationTitle: "Periodic Service",
//       initialNotificationContent: "Service is running in background",
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//     ),
//   );
  
//   service.startService();
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
  
//   // Initialize time zones for this isolate
//   tz.initializeTimeZones();

//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: "Periodic Service Active",
//       content: "Service started",
//     );
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // More robust timer implementation
//   Timer.periodic(const Duration(minutes: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         final now = DateFormat('HH:mm:ss').format(DateTime.now());
//         service.setForegroundNotificationInfo(
//           title: "Periodic Task Running",
//           content: "Last update at $now",
//         );
        
//         // Show notification (remove if causing issues)
//         // await NotificationService.showNotification(
//         //   title: "Background Update",
//         //   body: "Service running at $now",
//         // );
//       }
//     }
//   });
// }

// // --- Background Service Entry Point ---
// @pragma('vm:entry-point') // Required for Flutter Background Service
// void onStart(ServiceInstance service) async {
//   // Ensure that DartPluginRegistrant.ensureInitialized() is called for the background isolate
//   // This is crucial for plugins to work correctly in the background isolate.
//   DartPluginRegistrant.ensureInitialized();
//   // // Initialize NotificationService for THIS isolate.
//   // await NotificationService.initialize();

//   // // --- Add the one-time notification here ---
//   // await NotificationService.showNotification(
//   //   title: "Service Started!",
//   //   body: "Your periodic notification service is now active.",
//   // );

//   // For Android, cast to AndroidServiceInstance to access Android-specific methods
//   if (service is AndroidServiceInstance) {
//     // This is where you can update the persistent foreground notification details.
//     // The service is ALREADY set as foreground due to 'isForegroundMode: true' in configure.
//     // We update the notification content here.
//     service.setForegroundNotificationInfo(
//       title: "Periodic Service Active",
//       content: "Service started",
//     );
//   }

//   // Listen for stop requests from the UI
//   // This allows your UI to tell the background service to stop itself.
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // --- Schedule the 1-minute task ---
//   Timer.periodic(const Duration(minutes: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       // You can check if it's still a foreground service (though for this setup, it should be)
//       if (await service.isForegroundService()) {
//         final now = DateFormat('HH:mm:ss').format(DateTime.now());
//         // Update the persistent foreground notification content
//         service.setForegroundNotificationInfo(
//           title: "Periodic Task Running",
//           content: "Last notification sent at $now",
//         );
//       }
//     }

//     // Call your notification function. It will use the _notificationsPlugin
//     // that was initialized for THIS background isolate.
//     // await NotificationService.showNotification(
//     //   title: "1-Minute Reminder",
//     //   body:
//     //       "It's been a minute! Current time: ${DateFormat('HH:mm:ss').format(DateTime.now())}",
//     // );
//   });
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true, // Essential for persistent background execution
//       autoStart: true, // <--- CHANGED THIS TO TRUE
//       initialNotificationTitle: "Periodic Service",
//       initialNotificationContent: "Service is running in background",
//       foregroundServiceNotificationId:888, // Unique ID for the foreground notification
//     ),
//     iosConfiguration: IosConfiguration(), // Keep or remove, as per previous discussion
//   );
//   await FlutterBackgroundService().startService(); // <--- Corrected this line
// }

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications
  //await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
  await AppRoutes.initialize(); // Collect Screen data from db and create App Routes
  //AttendanceReminderManager.setupDailyAttendanceNotifications();
  await initializeService();
  // Initialize NotificationService
  await NotificationService.initialize();

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
