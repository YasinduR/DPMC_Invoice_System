import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config/app_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz; // Import timezone
import 'package:uuid/uuid.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Firebase Messaging related codes added by Darshan R on 16/04/2026
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const String _installIdKey = 'push_installation_id';
  static const String _currentUserIdKey = 'push_current_user_id';
  static const Uuid _uuid = Uuid();

  static String? _lastToken;
  static String _pushStatusMessage = 'Not initialized';
  static String? _currentAppUserId;
  static String? _currentAppDisplayName;

  static String? get lastToken => _lastToken;
  static String get pushStatusMessage => _pushStatusMessage;


  static Future<void> initialize() async {
    // First, ask for permission
    final bool hasPermission = await _requestPermissions();

    // Only initialize the plugin if permission was granted
    if (hasPermission) {
      await _initializePlugin();
    }

    await _initializeRemotePush();
  }

  static Future<void> _initializeRemotePush() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      _pushStatusMessage =
          'Firebase init failed. Add Firebase platform config files first. $error';
      developer.log(_pushStatusMessage, name: 'NotificationService');
      // ignore: avoid_print
      print(_pushStatusMessage);
      return;
    }

    try {
      await _messaging.setAutoInitEnabled(true);
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (error) {
      developer.log('FCM permission request failed: $error',
          name: 'NotificationService');
    }

    await refreshRemoteToken();

    Timer(const Duration(seconds: 5), () {
      refreshRemoteToken();
    });

    _messaging.onTokenRefresh.listen((token) async {
      _lastToken = token;
      developer.log('FCM token refreshed: $token', name: 'NotificationService');
      // ignore: avoid_print
      print('FCM token refreshed: $token');
      await _registerToken(token);
    });

    // Handle incoming messages when the app is in the Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log('Got a message whilst in the foreground!', name: 'NotificationService');

      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? 'New Notification',
          body: message.notification!.body ?? '',
        );
      }
    });
  }

  // Refresh remote token - added by Darshan R on 16/04/2026
  static Future<String?> refreshRemoteToken() async {
    try {
      final token = await _messaging.getToken();
      _lastToken = token;

      if (token == null || token.isEmpty) {
        _pushStatusMessage = 'No FCM token returned yet';
        developer.log(_pushStatusMessage, name: 'NotificationService');
        // ignore: avoid_print
        print(_pushStatusMessage);
        return null;
      }

      developer.log('FCM token: $token', name: 'NotificationService');
      // ignore: avoid_print
      print('FCM token: $token');

      final registered = await _registerToken(token, name: _currentAppDisplayName);
      _pushStatusMessage =
          registered ? 'Token fetched and registered' : 'Token fetched but backend registration failed';
      // ignore: avoid_print
      print(_pushStatusMessage);
      return token;
    } catch (error) {
      _pushStatusMessage = 'Failed to fetch FCM token: $error';
      developer.log(_pushStatusMessage, name: 'NotificationService');
      // ignore: avoid_print
      print(_pushStatusMessage);
      return null;
    }
  }

  // Register token - added by Darshan R on 10/04/2026
  static Future<bool> _registerToken(String token, {String? name}) async {
    final baseUrl = Config.notificationBackendUrl;

    if (baseUrl.isEmpty) {
      _pushStatusMessage = 'Notification backend URL is missing';
      return false;
    }

    try {
      final userId = await _resolveUserId();
      final installId = await _getInstallId();
      final uri = Uri.parse('$baseUrl/api/register');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'installId': installId,
          'fcmToken': token,
          'name': name,
        }),
      );

      return resp.statusCode == 200;
    } catch (error) {
      _pushStatusMessage = 'Backend registration failed: $error';
      developer.log(_pushStatusMessage, name: 'NotificationService');
      return false;
    }
  }

  // Resolve user ID - added by Darshan R on 10/04/2026
  static Future<String> _resolveUserId() async {
    // If current app user is set, use it
    if (_currentAppUserId != null && _currentAppUserId!.isNotEmpty) {
      return _currentAppUserId!;
    }

    // Otherwise return the install ID
    return await _getInstallId();
  }

  // Get install ID - added by Darshan R on 10/04/2026
  static Future<String> _getInstallId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_installIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated = 'device_${_uuid.v4()}';
    await prefs.setString(_installIdKey, generated);
    return generated;
  }

  /// Call this after user login to enable user-level notification targeting - added by Darshan R on 10/04/2026
  static Future<void> setCurrentAppUser(String appUserId, {String? displayName}) async {
    _currentAppUserId = appUserId;
    _currentAppDisplayName = displayName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, appUserId);

    // Re-register token with the new user ID
    if (_lastToken != null) {
      await _registerToken(_lastToken!, name: displayName);
      developer.log('Notification service updated for user: $appUserId ($displayName)',
          name: 'NotificationService');
    }
  }

  /// Clear the current user (call on logout) - added by Darshan R on 10/04/2026
  static Future<void> clearCurrentAppUser() async {
    _currentAppUserId = null;
    _currentAppDisplayName = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);

    // Re-register with device ID only
    if (_lastToken != null) {
      await _registerToken(_lastToken!);
      developer.log('Notification service cleared for user',
          name: 'NotificationService');
    }
  }

  /// Get the current user ID (app user if set, otherwise device ID) - added by Darshan R on 10/04/2026
  static Future<String> getCurrentUserId() async {
    return await _resolveUserId();
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
