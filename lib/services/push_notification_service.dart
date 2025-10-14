// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:az_notification_hub/az_notification_hub.dart';

// // Top-level function for background message handling.
// // This MUST be a top-level function or a static method that doesn't belong to a class instance.
// // It's crucial to initialize Firebase again in a background handler if you're going to access Firebase services.
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(); // Re-initialize Firebase for background processing
//   print('Handling a background message: ${message.messageId}');

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon'); // Replace 'app_icon' with your app's icon name
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   _showLocalNotification(
//     flutterLocalNotificationsPlugin,
//     message.notification?.title ?? 'Background Message',
//     message.notification?.body ?? 'You received a new background message.',
//     message.data,
//   );
// }

// // Helper function to show a local notification (used by foreground and background handlers)
// Future<void> _showLocalNotification(
//   FlutterLocalNotificationsPlugin plugin,
//   String? title,
//   String? body,
//   Map<String, dynamic> data,
// ) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'high_importance_channel', // id: Must match the channel created in NotificationService or AndroidManifest
//     'High Importance Notifications', // title
//     channelDescription: 'This channel is used for important notifications.', // description
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: false,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await plugin.show(
//     0, // Notification ID
//     title,
//     body,
//     platformChannelSpecifics,
//     payload: data['route'], // Optional: data to pass when notification is tapped
//   );
// }


// class PushNotificationService {
//   static final PushNotificationService _instance = PushNotificationService._internal();
//   factory PushNotificationService() => _instance;
//   PushNotificationService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final AzureNotificationHub _anh = AzureNotificationHub();


//   Future<void> initialize() async {
//     // 1. Initialize Flutter Local Notifications for foreground display
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon'); // Replace 'app_icon' with your app's icon name (drawable)
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       // Handle notification tap when app is in foreground
//       print('Notification tapped: ${response.payload}');
//       // You can navigate based on the payload here
//     });


//     // 2. Request FCM permissions
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted notification permission');
//     } else {
//       print('User declined or has not accepted notification permission');
//     }

//     // 3. Get FCM Token (this is required to pass to AzureNotificationHub instance methods *after* start)
//     String? fcmToken = await _firebaseMessaging.getToken();
//     print("FCM Token: $fcmToken");

//     // 4. Set Azure Notification Hub Callbacks and Start
//     // These callbacks are properties on the _anh instance, NOT parameters to start()
//     _anh.onNotificationReceived = (notification) {
//       print("Azure Notification Received (Foreground): ${notification.toMap()}");
//       // Display the notification using flutter_local_notifications
//       _showLocalNotification(
//         _flutterLocalNotificationsPlugin,
//         notification.title,
//         notification.body,
//         notification.data?.cast<String, dynamic>() ?? {},
//       );
//     };
//     _anh.onNotificationTapped = (notification) {
//       print("Azure Notification Tapped (Foreground/Background): ${notification.toMap()}");
//       // Handle navigation or specific actions when an Azure notification is tapped
//       // Example: Navigator.pushNamed(MyApp.navigatorKey.currentState!.context, notification.data?['route']);
//     };

//     // Now, call the start method with NO parameters.
//     // The plugin will internally use the AndroidManifest config and the latest FCM token it can get.
//     await _anh.start();
//     print("Azure Notification Hub started.");

//     // After starting, you can set the FCM token and tags if you need to update them.
//     // The `az_notification_hub` plugin has separate methods for this.
//     if (fcmToken != null) {
//       await _anh.setFcmRegistrationToken(fcmToken);
//       print("Azure Notification Hub FCM token set.");
//       // Example: Set initial tags after registration
//       await _anh.setTags(['all_users']);
//       print('Set initial tags for Azure Notification Hub');
//     } else {
//       print("FCM token is null. Cannot set FCM token or tags for Azure Notification Hub.");
//     }


//     // 5. Handle foreground messages from Firebase (also applies to Azure-sent messages via FCM)
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         // Display the notification using flutter_local_notifications
//         _showLocalNotification(
//           _flutterLocalNotificationsPlugin,
//           message.notification?.title,
//           message.notification?.body,
//           message.data,
//         );
//       }
//     });

//     // 6. Handle messages when the app is opened from a terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         print('App opened from terminated state with message: ${message.data}');
//         // Handle the initial message, e.g., navigate to a specific screen
//       }
//     });

//     // 7. Handle interaction when the app is in the background or foreground
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('App opened from background by tapping notification: ${message.data}');
//       // Handle when user taps on the notification, e.g., navigate
//     });
//   }

//   // Method to manually show a notification if needed (e.g., from an Azure callback not handled by FCM onMessage)
//   void showNotification(String? title, String? body, Map<String, dynamic> data) {
//     _showLocalNotification(
//       _flutterLocalNotificationsPlugin,
//       title,
//       body,
//       data,
//     );
//   }

//   // Methods for tag management, these are available on the AzureNotificationHub instance
//   Future<void> addTag(String tag) async {
//     await _anh.addTag(tag);
//     print('Added tag: $tag');
//   }

//   Future<void> removeTag(String tag) async {
//     await _anh.removeTag(tag);
//     print('Removed tag: $tag');
//   }

//   Future<void> setTags(List<String> tags) async {
//     await _anh.setTags(tags);
//     print('Set tags: $tags');
//   }
// }