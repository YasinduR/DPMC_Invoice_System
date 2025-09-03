// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// //import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:myapp/firebase_options.dart';

// // This must be a top-level function for background message handling
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print("Handling a background message: ${message.messageId}");
// }

// class NotificationService {
//   // Singleton pattern to ensure only one instance of the service
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Initialize Firebase
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     // Set the background messaging handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Subscribe this device to the "minute_tests" topic
//     // Any message sent to this topic will be received by this app.
//     await _firebaseMessaging.subscribeToTopic("minute_tests");
//     print("Successfully subscribed to topic: minute_tests");

//     // Request notification permissions for iOS and other platforms
//     await _requestPermissions();

//     // Initialize local notifications plugin (for showing foreground messages)
//     await _initializeLocalNotifications();

//     // Set up the handler for messages received while the app is in the foreground
//     _handleForegroundMessages();
//   }

//   Future<void> _requestPermissions() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher'); // Default app icon
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotificationsPlugin.initialize(initializationSettings);
//   }

//   // This method handles showing a notification when the app is OPEN.
//   // Background notifications are handled automatically by FCM.
//   void _handleForegroundMessages() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');

//         // Use the local notifications plugin to display the foreground notification.
//         _localNotificationsPlugin.show(
//           message.hashCode,
//           message.notification!.title,
//           message.notification!.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'high_importance_channel', // Channel ID
//               'High Importance Notifications', // Channel name
//               channelDescription: 'This channel is used for important notifications.',
//               importance: Importance.max,
//               priority: Priority.high,
//               icon: '@mipmap/ic_launcher', // Explicitly use default app icon
//             ),
//           ),
//         );
//       }
//     });
//   }
// }