// services/notification_services.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart'; // For GlobalKey, debugPrint
import 'dart:convert'; // For jsonDecode
import 'package:firebase_messaging/firebase_messaging.dart'; // NEW: Firebase Messaging

// A global key to access the navigator state if needed for routing
// Make sure this is properly initialized and passed to your MaterialApp
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // --- Local Notifications Setup ---
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // For iOS, onDidReceiveLocalNotification is deprecated in newer versions,
    // but useful for older iOS or for context.
    // const DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    //   onDidReceiveLocalNotification: _onDidReceiveLocalNotification, // Renamed for clarity
    // );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
     // iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse, // Renamed for clarity
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse, // Renamed for clarity
    );

    // --- Firebase Messaging Setup ---
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS and Android 13+
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('FCM: User granted notification permission: ${settings.authorizationStatus}');

    // Get the FCM token (this token is needed for sending targeted messages)
    String? fcmToken = await messaging.getToken();
    print("FCM: Token: $fcmToken");
    // IMPORTANT: You will need to send this 'fcmToken' to your backend/Azure Notification Hub
    // for registering the device to receive push notifications.

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FCM: Got a message whilst in the foreground!');
      print('FCM: Message data: ${message.data}');

      if (message.notification != null) {
        print('FCM: Message also contained a notification: ${message.notification}');
        // Show a local notification using flutter_local_notifications for foreground messages
        // This makes sure the user sees a heads-up notification even when the app is open.
        showNotification(
          id: message.hashCode, // A unique ID for this notification
          title: message.notification!.title,
          body: message.notification!.body,
          // Convert data map to a JSON string to pass as payload
          payload: jsonEncode(message.data),
        );
      }
    });

    // Handle messages when the app is opened from a background state (user taps on notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('FCM: A new onMessageOpenedApp event was published!');
      _handleNotificationClick(message.data);
    });

    // Handle initial message (app launched from terminated state by a notification)
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print('FCM: App launched from terminated state by a notification!');
      _handleNotificationClick(initialMessage.data);
    }
  }

  // --- Local Notifications Callbacks ---
  static void _onDidReceiveLocalNotification( // Renamed
      int id, String? title, String? body, String? payload) async {
    // Handle specific logic for iOS foreground notifications (deprecated in newer versions)
    debugPrint('Local Notification (iOS) received: id=$id, title=$title, body=$body, payload=$payload');
    // For older iOS, you might show an alert dialog here.
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) { // Renamed
    debugPrint('Local Notification tapped: payload=${response.payload}');
    if (response.payload != null) {
      // For local notifications, payload is already a String, potentially JSON.
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        _handleNotificationClick(data);
      } catch (e) {
        print('Error parsing local notification payload: $e');
        // Handle non-JSON payloads if necessary
        // You might have a simple string payload that directly means a route
        // navigatorKey.currentState?.pushNamed(response.payload!);
      }
    }
  }

  // Handle background notification response (for local notifications, not FCM)
  @pragma('vm:entry-point') // Required for Flutter 3.3+
  static void _onDidReceiveBackgroundNotificationResponse(NotificationResponse response) { // Renamed
    debugPrint('Local Background Notification tapped: payload=${response.payload}');
    if (response.payload != null) {
      // This runs in an isolate, so be careful with context.
      // If you need to navigate, you might send a message to the main isolate
      // or directly use a global key if your setup supports it safely.
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        _handleNotificationClick(data); // Attempt to handle similarly to FCM
      } catch (e) {
        print('Error parsing local background notification payload: $e');
      }
    }
  }

  // --- Helper for handling notification clicks (both FCM and Local) ---
  static void _handleNotificationClick(Map<String, dynamic> data) {
    print('FCM/Local: Notification clicked with data: $data');
    // Example: Navigate to a specific screen based on the notification data
    if (data.containsKey('route')) {
      final routeName = data['route'];
      // Use the global navigator key to navigate
      navigatorKey.currentState?.pushNamed(routeName, arguments: data);
    }
    // You can add more complex logic here based on your notification payload structure.
    // For example, if you have an 'invoiceId', you might navigate to a detail page.
    // if (data.containsKey('invoiceId')) {
    //   navigatorKey.currentState?.pushNamed(AppRoutes.invoiceDetail, arguments: data['invoiceId']);
    // }
  }

  // --- Method to display a local notification (can be called by FCM foreground messages) ---
  static Future<void> showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // id: Must be unique for your app
      'High Importance Notifications', // name: Visible to the user in settings
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      // To show custom icon, specify it here, e.g., 'mipmap/ic_notification'
      // icon: '@mipmap/ic_launcher', // or a custom icon
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // --- Other local notification methods (e.g., schedule, cancel) can remain here ---
  // ... your existing scheduleNotification, cancelNotification methods
}









// Add this feature Later

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