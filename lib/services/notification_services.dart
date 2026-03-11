import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz; // Import timezone

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();


  static Future<void> initialize() async {
    // First, ask for permission
    final bool hasPermission = await _requestPermissions();

    // Only initialize the plugin if permission was granted
    if (hasPermission) {
      await _initializePlugin();
    }
  }


  static Future<bool> _requestPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }


  static Future<void> _initializePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
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
    const NotificationDetails platformChannelSpecifics = 
    NotificationDetails(
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

  // --- FOR SCHEDULED NOTIFICATIONS ---//
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // --- FOR SCHEDULED NOTIFICATIONS ---//
  static Future<void> scheduleNotification({
    required int id, // Unique ID for each scheduled notification
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'DPMC-Invoice-System',
          'Notification Channel',
          channelDescription: 'DPMC Invoice System',
          importance: Importance.max,
          priority: Priority.high,
          
          //visibility: NotificationVisibility.public, // Ensure visible on lock screen
          // icon: '@mipmap/ic_launcher', // Optional: Custom small icon
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //payload: payload,
     // matchDateTimeComponents: DateTimeComponents.time, // Match time component only for daily repeats if needed
    );
  }

 static Future<void> periodicallyShow({
    required int id, // Unique ID for this periodic notification
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    //String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'DPMC-Invoice-System',
          'Notification Channel',
          channelDescription: 'DPMC Invoice System',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false, // Typically not shown for repeating notifications
        );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
     // payload: payload,
    );
  }
  /// Cancels a specific scheduled notification by its ID.
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancels all pending notifications. Use with caution as it clears all types.
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Retrieves a list of all pending scheduled notifications.
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }




}
