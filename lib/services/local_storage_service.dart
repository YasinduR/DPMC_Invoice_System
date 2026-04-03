import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/models/activity_model.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kBiometricEnabled = 'biometricEnabled';
  static const _kSavedUsername = 'savedUsername';
  static const _kSavedPwd = 'savedPassword';
  static const _kIconStyle = 'iconStyle';

  Future<void> saveBiometricPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, enabled);
  }

  Future<bool> getBiometricPreference(BuildContext context) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kBiometricEnabled) ?? false;
    } catch (e) {
      return false;
    } finally{
    if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }


  Future<void> saveUsernameForBiometric(
    String username,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, true);
    await prefs.setString(_kSavedUsername, username);
    await prefs.setString(_kSavedPwd, password);
  }

  Future<void> setBiometricPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, value);
  }

  Future<String?> getSavedUsernameForBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSavedUsername);
  }

  Future<String?> getSavedPasswordForBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSavedPwd);
  }

  Future<void> clearSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kBiometricEnabled);
    await prefs.remove(_kSavedUsername);
    await prefs.remove(_kSavedPwd);
  }

  // Icon Style - Added by Darshan R on 2026-04-03
  Future<void> saveIconStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kIconStyle, style);
  }

  Future<String> getIconStyle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kIconStyle) ?? 'Apple Glass';
  }

  // Activity Loging

static const String _kActivities = "activities";
static const _kActivityHistoryClear = "activityHistoryEnabledClear";  // Activity History Clear Preferance

Future<void> saveActivity(Activity activity) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> stored = prefs.getStringList(_kActivities) ?? [];

  stored.add(jsonEncode(activity.toMap()));

  await prefs.setStringList(_kActivities, stored);
}

// Future<List<Activity>> getActivities() async {
//   final prefs = await SharedPreferences.getInstance();

//   List<String> stored = prefs.getStringList(_kActivities) ?? [];

//   return stored
//       .map((e) => Activity.fromJson(jsonDecode(e)))
//       .toList()
//       .reversed
//       .toList();
// }

Future<List<Activity>> getActivities(String userId) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> stored = prefs.getStringList(_kActivities) ?? [];

  return stored
      .map((e) => Activity.fromJson(jsonDecode(e)))
      .where((activity) => activity.user == userId) // ✅ filter here
      .toList()
      .reversed
      .toList();
}


 Future<bool> getHistoryClearPreference(BuildContext context) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kActivityHistoryClear) ?? false;
    } catch (e) {
      return false;
    } finally{
    if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

    Future<void> setActivityHistoryClearPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kActivityHistoryClear, enabled);
  }

  Future<void> clearOldActivities() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> stored = prefs.getStringList(_kActivities) ?? [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final filtered = stored.where((e) {
    final activity = Activity.fromJson(jsonDecode(e));
    final activityDate = DateTime(
      activity.timestamp.year,
      activity.timestamp.month,
      activity.timestamp.day,
    );
    return activityDate.isAtSameMomentAs(today) ||
        activityDate.isAtSameMomentAs(yesterday);
  }).toList();
  await prefs.setStringList(_kActivities, filtered);
}
//






  // // --- New methods for Attendance Reminders --- THIS SECTION WAS TO MANAGE ATTENDANCE NOTIFICATION RELATED DATA
  //   // Prefix for attendance reminder keys in SharedPreferences
  // static const String _kScheduledAttendanceRemindersPrefix = 'scheduledAttendanceReminders_';
  // /// Generates a unique key for storing attendance reminder IDs for a specific date.
  // /// Format: 'scheduledAttendanceReminders_YYYY-MM-DD'
  // String _getReminderKeyForDate(DateTime date) {
  //   return '$_kScheduledAttendanceRemindersPrefix${DateFormat('yyyy-MM-dd').format(date)}';
  // }

  // /// Saves a list of scheduled notification IDs for attendance reminders on a given date.
  // /// Converts the list of integers to a list of strings for SharedPreferences.
  // Future<void> saveScheduledReminderIds(DateTime date, List<int> ids) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String key = _getReminderKeyForDate(date);
  //   await prefs.setStringList(key, ids.map((e) => e.toString()).toList());
  //   print("Saved reminder IDs for ${DateFormat('yyyy-MM-dd').format(date)}: $ids");
  // }

  // /// Retrieves a list of scheduled notification IDs for attendance reminders on a given date.
  // /// Returns an empty list if no IDs are stored for that date.
  // Future<List<int>> getScheduledReminderIds(DateTime date) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String key = _getReminderKeyForDate(date);
  //   final List<String>? idsAsString = prefs.getStringList(key);
  //   if (idsAsString != null) {
  //     final List<int> ids = idsAsString.map((e) => int.tryParse(e)).whereType<int>().toList();
  //     print("Retrieved reminder IDs for ${DateFormat('yyyy-MM-dd').format(date)}: $ids");
  //     return ids;
  //   }
  //   return [];
  // }

  // /// Removes the stored scheduled notification IDs for attendance reminders on a given date.
  // Future<void> removeScheduledReminderIds(DateTime date) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String key = _getReminderKeyForDate(date);
  //   await prefs.remove(key);
  //   print("Removed reminder IDs for ${DateFormat('yyyy-MM-dd').format(date)} from local storage.");
  // }

  // /// Retrieves all keys used for attendance reminders.
  // Future<List<String>> getAllAttendanceReminderKeys() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final Set<String> keys = prefs.getKeys();
  //   return keys
  //       .where((key) => key.startsWith(_kScheduledAttendanceRemindersPrefix))
  //       .toList();
  // }

  // /// Clears all stored attendance reminder IDs from local storage.
  // Future<void> clearAllScheduledReminderIds() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String> keysToRemove = await getAllAttendanceReminderKeys();
  //   for (String key in keysToRemove) {
  //     await prefs.remove(key);
  //   }
  //   print("Cleared all attendance reminder IDs from local storage.");
  // }
}
