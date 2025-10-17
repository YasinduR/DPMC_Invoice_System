import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kBiometricEnabled = 'biometricEnabled';
  static const _kSavedUsername = 'savedUsername';
  static const _kSavedPwd = 'savedPassword';
  static const _kSavedAttendance = 'savedAttendance';

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

  // --- NEW ATTENDANCE METHODS ---

  /// Saves or updates the attendance status for a specific date.
  /// Date format is expected to be 'yyyy-MM-dd'.
  /// Example: {'2025-10-26': 'Marked'}
  Future<void> _saveAttendanceMap(Map<String, String> attendanceMap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSavedAttendance, jsonEncode(attendanceMap));
  }

  Future<Map<String, String>> getAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? attendanceJson = prefs.getString(_kSavedAttendance);
    if (attendanceJson == null) {
      return {};
    }
    try {
      final Map<String, dynamic> decodedMap = jsonDecode(attendanceJson);
      return decodedMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      print('Error decoding attendance data: $e');
      return {}; // Return empty map on error
    }
  }

  Future<void> updateAttendanceStatus(String date, String status) async {
    final Map<String, String> currentAttendance = await getAttendanceData();
    currentAttendance[date] = status; // Update or add the entry
    await _saveAttendanceMap(currentAttendance);
    print('Attendance updated for $date: $status');
  }

  /// Gets the attendance status for a specific date.
  /// Returns null if no attendance record is found for the date.
  Future<String?> getAttendanceStatusForDate(String date) async {
    final Map<String, String> currentAttendance = await getAttendanceData();
    return currentAttendance[date];
  }

  /// Clears all saved attendance data.
  Future<void> clearAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSavedAttendance);
    print('All attendance data cleared.');
  }

  // --- Utility method for date formatting ---
  // You might already have this elsewhere, but it's useful for consistency.
  String getCurrentDateFormatted() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }



}
