import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz; // Import timezone

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //   static Future<void> initialize() async {

  //   // --- 2. ADD PERMISSION REQUEST LOGIC ---
  //   final PermissionStatus status = await Permission.notification.request();
  //   if (status.isDenied || status.isPermanentlyDenied) {
  //     // Handle the case where the user denies the permission.
  //     // You might want to show a dialog explaining why the permission is needed.
  //     print('Notification permission denied.');
  //     // You could open app settings here for the user to manually enable it.
  //     // openAppSettings();
  //     return; // Exit if permission is not granted
  //   }

  // static Future<void> initialize() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/launcher_icon');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await _notificationsPlugin.initialize(initializationSettings);
  // }

  static Future<void> initialize() async {
    // First, ask for permission
    final bool hasPermission = await _requestPermissions();

    // Only initialize the plugin if permission was granted
    if (hasPermission) {
      await _initializePlugin();
    }
  }

  /// --- 2. A PRIVATE METHOD FOR PERMISSIONS ---
  /// This method is only responsible for checking and requesting notification permissions.
  /// It returns `true` if permission is granted, and `false` otherwise.
  static Future<bool> _requestPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      //print('Notification permission granted.');
      return true;
    } else {
      // Handle the case where the user denies the permission.
      //print('Notification permission denied.');
      // You could open app settings here for the user to manually enable it.
      // openAppSettings();
      return false;
    }
  }

  /// --- 3. A PRIVATE METHOD FOR PLUGIN INITIALIZATION ---
  /// This is the code you wanted to separate. It's now in its own method
  /// and only runs if permissions are successfully granted.
  static Future<void> _initializePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
    // print('FlutterLocalNotificationsPlugin initialized.');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'DPMC-Invoice-System',
          'Notification Channel',
          channelDescription: 'DPMC Invoice System',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // --- NEW: METHOD FOR SCHEDULED NOTIFICATIONS ---
  static Future<void> showScheduledNotification({
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      1, // Use a different ID for this notification
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'DPMC-Invoice-System',
          'Notification Channel',
          channelDescription: 'DPMC Invoice System',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // --- ADD THIS REQUIRED PARAMETER ---
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
