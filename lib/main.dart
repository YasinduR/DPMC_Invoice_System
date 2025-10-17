import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/services/local_storage_service.dart';
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
  //int counter = 0;

  // Initialize FlutterLocalNotificationsPlugin and create channel ONCE here
  final FlutterLocalNotificationsPlugin _backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'DPMC-Invoice-System',
    'Notification Channel',
    description: 'DPMC Invoice System notifications',
    importance: Importance.max,
    playSound: true,
  );

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

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'DPMC-Invoice-System',
        'Notification Channel',
        channelDescription: 'DPMC Invoice System',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: '@mipmap/launcher_icon',
      );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
 
 
 Timer.periodic(const Duration(seconds: 30), (timer) async {
    try {
      //counter++;
      final LocalStorageService localStorageService = LocalStorageService(); // Instantiate here
      final String today = localStorageService.getCurrentDateFormatted();
      final DateTime now = DateTime.now();
      final nowFormatted = DateFormat('HH:mm').format(now);
      final String? currentStatus = await localStorageService.getAttendanceStatusForDate(today);

      print('Background task update: at ${DateFormat('HH:mm:ss').format(DateTime.now())}. Current Status: $currentStatus');

      // --- Always cancel all attendance-related notifications at the beginning of each cycle
      //     to prevent stale notifications, then re-show the relevant one.
      // This is the most aggressive way to prevent reappearing notifications.
      await _backgroundNotificationsPlugin.cancel(0); // Pending Reminder
      await _backgroundNotificationsPlugin.cancel(1); // Started / Not Ended
      await _backgroundNotificationsPlugin.cancel(2); // Overtime / Urgent End
      //await _backgroundNotificationsPlugin.cancel(3); // Auto-Marked Absent

      // --- ATTENDANCE CHECK LOGIC (8 AM to 8 PM) ---
      if (now.hour >= 8 && now.hour < 20) { // 8 AM (inclusive) to 8 PM (exclusive, meaning up to 7:59 PM)

        if (currentStatus == null || currentStatus == 'Pending') {
          // If status is null, explicitly set to Pending in local storage
          if (currentStatus == null) {
            await localStorageService.updateAttendanceStatus(today, 'Pending');
            print('Attendance status changed from null to Pending.');
            // Notify UI about the change if needed
          }

          // Send reminder notification for Pending status (e.g., every 5 minutes)
             await _backgroundNotificationsPlugin.show(
                0, // Consistent ID for "Pending" reminder
                "Attendance Reminder",
                "It is $nowFormatted now. Please mark your attendance for today! $currentStatus.",
                platformChannelSpecifics,
                payload: 'attendance_pending_reminder',
              );

        } else if (currentStatus == 'Started') {
          // If attendance is 'Started' within the window, remind to end it (e.g., every 10 minutes)
              await _backgroundNotificationsPlugin.show(
                1, // Consistent ID for "Not Ended" reminder
                "Attendance Still Active",
                "It is $nowFormatted now. Don't forget to End your attendance!",
                platformChannelSpecifics,
                payload: 'attendance_not_ended_reminder',
              );
              print('Sent "Not Ended" reminder for $today.');

        } else if (currentStatus == 'Ended' || currentStatus == 'Absent') {
          // If attendance is already Ended or Absent, do nothing within this window,
          // as all reminders were cancelled at the start of this cycle.
          print('Attendance already Finalized ($currentStatus) for $today. No reminders needed.');
        }

      } else { // --- Logic for OUTSIDE 8 AM to 8 PM window (Before 8 AM or After 8 PM) ---

        if (currentStatus == 'Started') {
          // If it's outside the work window and still 'Started', strongly remind to end.
          await _backgroundNotificationsPlugin.show(
            2, // Consistent ID for "End Attendance" urgency (Overtime)
            "Attendance Not Ended (Overtime?)",
            "It is $nowFormatted now. Your attendance is still active. Please End it!",
            platformChannelSpecifics,
            payload: 'attendance_end_urgent',
          );
          print('Urgent "Not Ended" reminder sent for $today.');

        } else if (currentStatus == 'Pending') {
          //  If it's past the marking window and still pending, mark as Absent.
          //  This should ideally run only once when the hour crosses 8 PM (20).
          //  if (now.hour == 20 && now.minute == 0 && now.second < 30) {
          //    await localStorageService.updateAttendanceStatus(today, 'Absent');
          //    await _backgroundNotificationsPlugin.show(
          //      3, // Consistent ID for "Auto-Absent" notification
          //      "Attendance Auto-Marked Absent",
          //      "Attendance was not marked for today, now set to Absent.",
          //      platformChannelSpecifics,
          //      payload: 'attendance_auto_absent',
          //    );
          //   // print('Attendance marked Absent for $today due to timeout at 8 PM.');
          // }
        } else if (currentStatus == 'Ended' || currentStatus == 'Absent')
         {
           print('Attendance is Finalized ($currentStatus) for $today. No reminders needed.');
        }
      }

  // Timer.periodic(const Duration(seconds: 30), (timer) async { // You can adjust this interval for checking
  //   try {
  //    // counter++;
  //     final String today = localStorageService.getCurrentDateFormatted();
  //     final DateTime now = DateTime.now();
  //     final nowFormatted = DateFormat('HH:mm').format(now);
  //     final String? currentStatus = await localStorageService.getAttendanceStatusForDate(today);
  //     // --- ATTENDANCE CHECK LOGIC (8 AM to 8 PM) ---
  //     if (now.hour >= 8 && now.hour < 20) { 
  //       // If attendance is not yet marked or is absent, set it to 'Pending'
  //       if (currentStatus == null ) {
  //         await localStorageService.updateAttendanceStatus(today, 'Pending');
  //         await _backgroundNotificationsPlugin.show(
  //           0, // Unique ID for this specific notification
  //           "Attendance Reminder",
  //           "It is $nowFormatted now. Please mark your attendance for today!",
  //           platformChannelSpecifics,
  //           payload: 'attendance_pending_reminder',
  //         );
  //         //print('Attendance set to Pending for $today and reminder sent.');
  //       } else if (currentStatus == 'Pending') {
  //           await _backgroundNotificationsPlugin.show(
  //             1, // Different unique ID for repeated reminders
  //             "Attendance Still Pending",
  //             "It is $nowFormatted now. Don't forget to mark your attendance!",
  //             platformChannelSpecifics,
  //             payload: 'attendance_repeat_reminder',
  //           );
  //           //print('Attendance still Pending for $today, sending repeat reminder.');
  //         //}
  //       }
  //     }
  //     else if(currentStatus=='Started')
  //     {
  //           await _backgroundNotificationsPlugin.show(
  //             2, // Different unique ID for repeated reminders
  //             "Attendance not Ended",
  //             "Don't forget to end your attendance!",
  //             platformChannelSpecifics,
  //             payload: 'attendance_repeat_reminder',
  //           );
  //     }

      // --- End of Day Attendance Check (e.g., after 10 PM, once) ---
      // This part ensures that if attendance is still 'Pending' after the window, it's marked 'Absent'.
      // This should ideally run only once after the marking window closes.
      // We'll trigger it for 10 PM precisely if it's still Pending.
      // if (now.hour == 22 && now.minute == 0) { // At 10:00 PM
      //    final String? currentStatus = await localStorageService.getAttendanceStatusForDate(today);
      //    if (currentStatus == 'Pending') {
      //      await localStorageService.updateAttendanceStatus(today, 'Absent');
      //      await _backgroundNotificationsPlugin.show(
      //        2, // Different unique ID
      //        "Attendance Auto-Marked Absent",
      //        "Attendance was not marked for today, now set to Absent.",
      //        platformChannelSpecifics,
      //        payload: 'attendance_auto_absent',
      //      );
      //      print('Attendance marked Absent for $today due to timeout at 10 PM.');
      //    }
      // }

      // ... existing notification and service.setForegroundNotificationInfo logic ...

      // if (service is AndroidServiceInstance) {
      //   final isForeground = await service.isForegroundService();
      //   final nowFormatted = DateFormat('HH:mm:ss').format(DateTime.now());
      //   if (isForeground) {
      //     await service.setForegroundNotificationInfo(
      //       title: "Service Active",
      //       content: "Update #$counter at $nowFormatted",
      //     );

      //     await _backgroundNotificationsPlugin.show(
      //       DateTime.now().millisecondsSinceEpoch % 100000 + 100, // Ensure unique ID, e.g., +100
      //       "Foreground Service Status",
      //       "UI visible, background task running: $nowFormatted",
      //       platformChannelSpecifics,
      //       payload: 'foreground_periodic_status',
      //     );
      //   } else {
      //     await _backgroundNotificationsPlugin.show(
      //       DateTime.now().millisecondsSinceEpoch % 100000 + 200, // Ensure unique ID, e.g., +200
      //       "Background Service Status",
      //       "UI not visible, background task running: $nowFormatted",
      //       platformChannelSpecifics,
      //       payload: 'background_periodic_status',
      //     );
      //   }
      // }

      print('Background task update:  at ${DateFormat('HH:mm:ss').format(DateTime.now())}');
    } catch (e) {
      print('Background task error within periodic timer: $e');
    }
  });
}

// void _startPeriodicTasks(ServiceInstance service) {
//   int counter = 0;

//   final FlutterLocalNotificationsPlugin _backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/launcher_icon'); // Confirm if 'app_icon' or 'ic_launcher'

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'DPMC-Invoice-System', // Channel ID - MUST match what show() uses below
//     'Notification Channel',
//     description: 'DPMC Invoice System notifications',
//     importance: Importance.max,
//     playSound: true,
//   );

//   // Create the channel for Android 8.0+
//   _backgroundNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   _backgroundNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (response) async {
//       // Handle notification tap when app is in foreground from background service
//     },
//     onDidReceiveBackgroundNotificationResponse: (response) async {
//       // Handle notification tap when app is in background/killed from background service
//     },
//   );
//   // End of one-time notification setup for background isolate


//   // Define notification details ONCE for re-use
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//         'DPMC-Invoice-System', // MUST match the channel ID created above!
//         'Notification Channel',
//         channelDescription: 'DPMC Invoice System',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: false,
//         icon: '@mipmap/launcher_icon', // Confirm if 'app_icon' or 'ic_launcher'
//       );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);


//   Timer.periodic(const Duration(seconds: 30), (timer) async {
//     try {
//       counter++;

//       if (service is AndroidServiceInstance) {
//         //final isForeground = await service.isForegroundService();
//         //if (isForeground) {
//           final now = DateFormat('HH:mm').format(DateTime.now());

//           // await service.setForegroundNotificationInfo(
//           //   title: "Service Active",
//           //   content: "Update #$counter at $now",
//           // );

//           // Direct call to show notification
//           await _backgroundNotificationsPlugin.show(
//             DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
//             "Attendance Start Reminder",
//             "It is $now ! Please Start your attendance",
//             platformChannelSpecifics, // Use the defined details
//             payload: 'foreground_periodic',
//           );
//           service.invoke('update', {
//             "counter": counter,
//             "time": now,
//           });
//       //  } else {
//           //final now = DateFormat('HH:mm:ss').format(DateTime.now());
//           // Direct call to show notification
//           // await _backgroundNotificationsPlugin.show(
//           //   DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
//           //   "Background Update",
//           //   "Service running in Background at $now",
//           //   platformChannelSpecifics, // Use the defined details
//           //   payload: 'background_periodic',
//           // );
//        // }
//       }

//       print('Background task update: #$counter at ${DateFormat('HH:mm:ss').format(DateTime.now())}');
//     } catch (e) {
//       print('Background task error within periodic timer: $e');
//       // The PlatformException from permission_handler should now be gone.
//     }
//   });
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
