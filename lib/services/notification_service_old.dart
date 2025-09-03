// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   // Singleton pattern to ensure only one instance of this service
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Initialization and permission request
//   Future<void> init() async {
//     // 1. INITIALIZATION SETTINGS
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher'); // Default app icon

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // 2. REQUEST PERMISSIONS
//     await _requestPermissions();
//   }

//   Future<void> _requestPermissions() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await androidImplementation?.requestNotificationsPermission();

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   // YOUR FUNCTION TO SHOW REPEATING NOTIFICATION
// Future<void> showRepeatingNotification() async {
//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'repeating_channel_id',
//     'Repeating Notifications',
//     channelDescription: 'Channel for repeating notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   const NotificationDetails notificationDetails = NotificationDetails(
//     android: androidDetails,
//   );

//   print("Scheduling notification to repeat every minute...");

//   // CORRECTED CODE
//   await _flutterLocalNotificationsPlugin.periodicallyShow(
//     0, // Notification ID
//     'Repeating Title',
//     'This notification shows every minute.',
//     RepeatInterval.everyMinute,
//     notificationDetails,
//     // REMOVED: androidAllowWhileIdle: true,
//     // ADDED the required parameter:
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   );
// }

//   // Function to cancel notifications
//   Future<void> cancelAllNotifications() async {
//     print("Cancelling all notifications...");
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }
// }