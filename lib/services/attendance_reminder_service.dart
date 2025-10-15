//// Remove Later Depriated : Tried to include noridiction to mark attendence

// lib/services/attendance_reminder_manager.dart
// import 'package:myapp/services/attendance_service.dart';
// import 'package:myapp/services/notification_services.dart';
// import 'package:myapp/services/local_storage_service.dart'; // Import LocalStorageService
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart'; // For date formatting for logging

// class AttendanceReminderManager {
//   // Base ID for attendance notifications.
//   // This will now identify the *single periodic reminder* for a given day.
//   static const int _attendanceNotificationIdBase = 10000;

//   static final LocalStorageService _localStorageService = LocalStorageService();

//   /// Generates a unique notification ID for a daily periodic reminder.
//   /// Combines base ID with day of year to create a unique ID for each day's periodic reminder.
//   static int _generateDailyPeriodicNotificationId(DateTime date) {
//     final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
//     final int dayOfYear =
//         normalizedDate.difference(DateTime(normalizedDate.year)).inDays +
//         1; // 1-366
//     return _attendanceNotificationIdBase + dayOfYear;
//   }

//   /// Sets up attendance notifications for upcoming working days using a periodic reminder.
//   /// This function should be called on app startup and potentially after attendance is marked.
//   static Future<void> setupDailyAttendanceNotifications() async {
//     print("Setting up daily attendance notifications (periodic approach)...");

//     try {
//       // 1. Get all pending notifications within our ID range and cancel them.
//       // This ensures we clean up any old individual 1-min reminders or previous periodic ones.
//       final List<PendingNotificationRequest> pendingNotifications =
//           await NotificationService.getPendingNotifications();
//       List<int> cancelledNotificationIds = [];
//       for (var notification in pendingNotifications) {
//         // Our periodic IDs will be between _attendanceNotificationIdBase and _attendanceNotificationIdBase + 366 (max day of year)
//         if (notification.id >= _attendanceNotificationIdBase &&
//             notification.id <= _attendanceNotificationIdBase + 366) {
//           await NotificationService.cancelNotification(notification.id);
//           cancelledNotificationIds.add(notification.id);
//         }
//       }
//       if (cancelledNotificationIds.isNotEmpty) {
//         print(
//           "Cancelled ${cancelledNotificationIds.length} previous attendance notifications based on ID range.",
//         );
//       } else {
//         print(
//           "No previous attendance notifications (within ID range) to cancel.",
//         );
//       }

//       // 2. Clear all previously stored attendance reminder IDs from local storage.
//       // Assuming LocalStorageService only manages attendance reminder IDs.
//       await _localStorageService.clearAllScheduledReminderIds();

//       // 3. Get the list of working days for the next specified days from your API
//       final List<DateTime> workingDays = await AttendanceService.getWorkingDays(
//         daysAhead: 1, // Set to 1 as in original, adjust for production if needed.
//       );
//       print("Fetched ${workingDays.length} working days.");

//       // Define the start and end times for the periodic reminders as in your original request/code
//       const int startHour = 8;
//       const int startMinute = 30;
//       const int endHour = 17;
//       const int endMinute = 30;

//       for (DateTime day in workingDays) {
//         // Normalize the date to avoid time components affecting checks
//         final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
//         final String formattedDay = DateFormat(
//           'yyyy-MM-dd',
//         ).format(normalizedDay);

//         // 4. Check if attendance is already marked for this day
//         final bool marked = await AttendanceService.isAttendanceMarked(
//           normalizedDay,
//         );

//         // Get current time to determine if reminders should be active or cancelled
//         tz.TZDateTime now = tz.TZDateTime.now(tz.local);

//         // Define the reminder window for the current day
//         tz.TZDateTime potentialStartTime = tz.TZDateTime(
//           tz.local,
//           normalizedDay.year,
//           normalizedDay.month,
//           normalizedDay.day,
//           startHour,
//           startMinute,
//         );

//         tz.TZDateTime endReminderBoundary = tz.TZDateTime(
//           tz.local,
//           normalizedDay.year,
//           normalizedDay.month,
//           normalizedDay.day,
//           endHour,
//           endMinute,
//         );

//         int periodicId = _generateDailyPeriodicNotificationId(normalizedDay);

//         if (!marked) {
//           // Only schedule reminders if attendance is NOT marked
//           print(
//             "Attendance not marked for $formattedDay.",
//           );

//           // If current time is past the end boundary, cancel any active periodic reminder for this day.
//           // This handles cases where the app is relaunched after the reminder window has passed.
//           if (now.isAfter(endReminderBoundary)) {
//              final List<PendingNotificationRequest> currentPending =
//               await NotificationService.getPendingNotifications();
//              if (currentPending.any((element) => element.id == periodicId)) {
//                 await NotificationService.cancelNotification(periodicId);
//                 await _localStorageService.removeScheduledReminderIds(normalizedDay);
//                 print("  Cancelled periodic reminder (ID: $periodicId) for $formattedDay as it's past the end time.");
//              } else {
//                 print("  No active periodic reminder (ID: $periodicId) for $formattedDay to cancel (past end time).");
//              }
//              continue; // Move to the next working day
//           }

//           // If the potential start time for the reminder has passed, set it to 1 minute from now
//           if (potentialStartTime.isBefore(now)) {
//             potentialStartTime = tz.TZDateTime(
//               tz.local,
//               now.year,
//               now.month,
//               now.day,
//               now.hour,
//               now.minute,
//             ).add(const Duration(minutes: 1));
//           }

//           // Ensure the (recalculated) potential start time is still within the active window
//           if (potentialStartTime.isBefore(endReminderBoundary) || potentialStartTime.isAtSameMomentAs(endReminderBoundary)) {
//             await NotificationService.periodicallyShow(
//               id: periodicId,
//               title: 'Attendance Reminder',
//               body: 'Please log your attendance!',
//               repeatInterval: RepeatInterval.everyMinute,
//             );

//             // Store the ID of this single periodic reminder for the day
//             // We store it as a list because `getScheduledReminderIds` expects a list.
//             await _localStorageService.saveScheduledReminderIds(
//               normalizedDay,
//               [periodicId],
//             );

//             // Show an immediate confirmation notification
//             NotificationService.showNotification(
//               title: 'DPMC Invoice System',
//               body: 'Attendance reminders scheduled periodically for $formattedDay.',
//             );
//             print(
//               "  Scheduled periodic reminder with ID $periodicId for $formattedDay, starting at ${DateFormat('hh:mm a').format(potentialStartTime)}.",
//             );
//           } else {
//             print(
//               "  No periodic reminders to schedule for $formattedDay (outside allowed time window or all times passed).",
//             );
//           }
//         } else {
//           print(
//             "Attendance already marked for $formattedDay. No reminders scheduled.",
//           );
//           // Ensure no stray periodic reminders are in local storage for marked days.
//           // This also attempts to cancel any currently active periodic reminder for this day.
//           final List<int> storedIds = await _localStorageService.getScheduledReminderIds(normalizedDay);
//           if (storedIds.isNotEmpty && storedIds.first == periodicId) {
//              final List<PendingNotificationRequest> currentPending =
//               await NotificationService.getPendingNotifications();
//              if (currentPending.any((element) => element.id == periodicId)) {
//                 await NotificationService.cancelNotification(periodicId);
//                 print("  Cancelled active periodic reminder (ID: $periodicId) for $formattedDay due to marked attendance.");
//              }
//           }
//           await _localStorageService.removeScheduledReminderIds(normalizedDay);
//         }
//       }
//       print("Attendance notification setup complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to set up daily attendance notifications: $e");
//       print("Stacktrace: $stacktrace");
//       NotificationService.showNotification(
//         title: 'Notification Setup Failed',
//         body: e.toString(),
//       );
//     }
//   }

//   /// Call this method when a user successfully logs their attendance for the current day.
//   /// It will cancel the active periodic attendance reminder for that specific day and remove its ID from local storage.
//   static Future<void> cancelTodayAttendanceReminders() async {
//     final DateTime today = DateTime.now();
//     final DateTime normalizedToday = DateTime(
//       today.year,
//       today.month,
//       today.day,
//     );
//     final String formattedToday = DateFormat(
//       'yyyy-MM-dd',
//     ).format(normalizedToday);
//     print(
//       "Attempting to cancel today's ($formattedToday) periodic attendance reminders...",
//     );

//     try {
//       // 1. Retrieve the stored periodic ID for today from local storage
//       final List<int> idsToCancel = await _localStorageService
//           .getScheduledReminderIds(normalizedToday);

//       if (idsToCancel.isNotEmpty) {
//         // We expect only one ID for the periodic reminder
//         int periodicId = idsToCancel.first;

//         final List<PendingNotificationRequest> pending =
//             await NotificationService.getPendingNotifications();
//         if (pending.any((element) => element.id == periodicId)) {
//           await NotificationService.cancelNotification(periodicId);
//           print("  Cancelled periodic attendance reminder with ID: $periodicId for today.");
//         } else {
//           print(
//             "  Periodic notification with ID: $periodicId for today was not found pending (already delivered/cancelled or not scheduled).",
//           );
//         }

//         // 2. Remove the stored ID for today from local storage
//         await _localStorageService.removeScheduledReminderIds(normalizedToday);
//         print(
//           "Successfully cancelled periodic reminder for today ($formattedToday).",
//         );
//       } else {
//         print(
//           "No scheduled periodic attendance reminders found for today ($formattedToday) in local storage.",
//         );
//       }
//       print("Cancellation of today's attendance reminders complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to cancel today's attendance reminders: $e");
//       print("Stacktrace: $stacktrace");
//       NotificationService.showNotification(
//         title: 'Reminder Cancellation Failed',
//         body: 'Could not cancel attendance reminders. Please contact support.',
//       );
//     }
//   }
// }
// class AttendanceReminderManager {
//   // Base ID for attendance notifications to ensure uniqueness per day and time
//   static const int _attendanceNotificationIdBase = 10000;
//   // A distinct ID for a general, non-repeating confirmation notification
//   static const int _dailySetupConfirmationNotificationId = 9999;
//   static final LocalStorageService _localStorageService = LocalStorageService();

//   /// Generates a unique notification ID for a specific reminder time on a given date.
//   /// Combines day of year, hour, and minute to create a unique ID.
//   static int _generateNotificationId(DateTime date, int hour, int minute) {
//     // We only care about the date part for ID generation
//     final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
//     final int dayOfYear =
//         normalizedDate.difference(DateTime(normalizedDate.year)).inDays +
//         1; // 1-366
//     return _attendanceNotificationIdBase +
//         (dayOfYear * 10000) + // Max 366 days * 10000 = 3,660,000
//         (hour * 100) + // Max 23 hours * 100 = 2300
//         minute; // Max 59 minutes
//   }

//   /// Sets up attendance notifications for upcoming working days.
//   /// This function should be called on app startup and potentially after attendance is marked.
//   static Future<void> setupDailyAttendanceNotifications() async {
//     print("Setting up daily attendance notifications (1-min interval)...");

//     try {
//       // Removed the 'Welcome' and 'Test' notifications to avoid interference during login
//       // NotificationService.showNotification(title: 'DPMC Invoice System', body: 'Welcome');
//       // NotificationService.scheduleNotification(id: 5, title: 'Attendance Reminder', body: 'Test; Please log your attendance!', scheduledTime: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));

//       // 1. Get all pending notifications and cancel only our attendance-related ones
//       final List<PendingNotificationRequest> pendingNotifications =
//           await NotificationService.getPendingNotifications();
//       List<int> cancelledNotificationIds = [];
//       for (var notification in pendingNotifications) {
//         if (notification.id >= _attendanceNotificationIdBase) {
//           await NotificationService.cancelNotification(notification.id);
//           cancelledNotificationIds.add(notification.id);
//         }
//       }
//       if (cancelledNotificationIds.isNotEmpty) {
//         print(
//           "Cancelled ${cancelledNotificationIds.length} previous attendance notifications based on ID range.",
//         );
//       } else {
//         print(
//           "No previous attendance notifications (within ID range) to cancel.",
//         );
//       }

//       // 2. Clear all previously stored attendance reminder IDs from local storage
//       await _localStorageService.clearAllScheduledReminderIds();

//       // 3. Get the list of working days for the next 30 days from your API
//       final List<DateTime> workingDays = await AttendanceService.getWorkingDays(
//         daysAhead: 1, // Keeping daysAhead=2 for testing, consider changing for production
//       );
//       print("Fetched ${workingDays.length} working days.");

//       // Define the start and end times for the repeating reminders
//       const int startHour = 11;
//       const int startMinute = 30;
//       const int endHour = 17; // 8 PM
//       const int endMinute = 30; // 8:30 PM
//       const Duration reminderInterval = Duration(minutes: 1);

//       for (DateTime day in workingDays) {
//         // Normalize the date to avoid time components affecting checks
//         final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
//         final String formattedDay = DateFormat(
//           'yyyy-MM-dd',
//         ).format(normalizedDay);

//         // 4. Check if attendance is already marked for this day
//         final bool marked = await AttendanceService.isAttendanceMarked(
//           normalizedDay,
//         );

//         if (!marked) {
//           // Only schedule reminders if attendance is NOT marked
//           print(
//             "Attendance not marked for $formattedDay. Scheduling 1-min interval reminders.",
//           );

//           List<int> scheduledIdsForDay = [];
//           tz.TZDateTime currentReminderTime = tz.TZDateTime(
//             tz.local,
//             normalizedDay.year,
//             normalizedDay.month,
//             normalizedDay.day,
//             startHour,
//             startMinute,
//           );

//           tz.TZDateTime endReminderBoundary = tz.TZDateTime(
//             tz.local,
//             normalizedDay.year,
//             normalizedDay.month,
//             normalizedDay.day,
//             endHour,
//             endMinute,
//           );

//           int remindersScheduledCount = 0;
//           while (currentReminderTime.isBefore(endReminderBoundary) ||
//               currentReminderTime.isAtSameMomentAs(endReminderBoundary)) {
//             // Ensure the scheduled time is in the future
//             if (currentReminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
//               int id = _generateNotificationId(
//                 currentReminderTime,
//                 currentReminderTime.hour,
//                 currentReminderTime.minute,
//               );

//               await NotificationService.scheduleNotification(
//                 id: id,
//                 title: 'Attendance Reminder',
//                 body:
//                     'It\'s ${DateFormat('hh:mm a').format(currentReminderTime)}. Please log your attendance!',
//                 scheduledTime: currentReminderTime,
//               );
//               scheduledIdsForDay.add(id);
//               remindersScheduledCount++;
//             }
//             currentReminderTime = currentReminderTime.add(reminderInterval);
//           }

//           // Save the scheduled IDs for this day to local storage
//           if (scheduledIdsForDay.isNotEmpty) {
//             await _localStorageService.saveScheduledReminderIds(
//               normalizedDay,
//               scheduledIdsForDay,
//             );
//             // Changed to showNotification with a distinct ID, as showScheduledNotification
//             // (from your original NotificationService) has a fixed ID (1) which could overwrite.
//             // This will show an immediate confirmation that notifications were scheduled.
//             NotificationService.showNotification(
//               title: 'DPMC Invoice System',
//               body: 'Attendance reminders scheduled for $formattedDay.',
//             );
//             print(
//               "  Scheduled $remindersScheduledCount reminders for $formattedDay.",
//             );
//           } else {
//             print(
//               "  No future reminders to schedule for $formattedDay (all times passed).",
//             );
//           }
//         } else {
//           print(
//             "Attendance already marked for $formattedDay. No reminders scheduled.",
//           );
//           // Ensure no stray reminders are in local storage for marked days
//           await _localStorageService.removeScheduledReminderIds(normalizedDay);
//         }
//       }
//       print("Attendance notification setup complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to set up daily attendance notifications: $e");
//       print("Stacktrace: $stacktrace");
//       // You might want to show a general error notification to the user here
//       NotificationService.showNotification(
//         title: 'Notification Setup Failed',
//         body: e.toString(),
//       );
//       // Re-throw the error if you want the calling context (like LoginScreen) to handle it further
//      // rethrow;
//     }
//   }

//   /// Call this method when a user successfully logs their attendance for the current day.
//   /// It will cancel any outstanding attendance reminders for that specific day and remove them from local storage.
//   static Future<void> cancelTodayAttendanceReminders() async {
//     final DateTime today = DateTime.now();
//     final DateTime normalizedToday = DateTime(
//       today.year,
//       today.month,
//       today.day,
//     );
//     final String formattedToday = DateFormat(
//       'yyyy-MM-dd',
//     ).format(normalizedToday);
//     print(
//       "Attempting to cancel today's ($formattedToday) 1-min attendance reminders...",
//     );

//     try { // Added try-catch for cancellation as well
//       // 1. Retrieve the stored IDs for today from local storage
//       final List<int> idsToCancel = await _localStorageService
//           .getScheduledReminderIds(normalizedToday);

//       if (idsToCancel.isNotEmpty) {
//         for (int id in idsToCancel) {
//           // Check if the notification is actually pending before trying to cancel
//           final List<PendingNotificationRequest> pending =
//               await NotificationService.getPendingNotifications();
//           if (pending.any((element) => element.id == id)) {
//             await NotificationService.cancelNotification(id);
//             print("  Cancelled attendance reminder with ID: $id for today.");
//           } else {
//             print(
//               "  Notification with ID: $id for today was not found pending (already delivered/cancelled).",
//             );
//           }
//         }
//         // 2. Remove the stored IDs for today from local storage
//         await _localStorageService.removeScheduledReminderIds(normalizedToday);
//         print(
//           "Successfully cancelled ${idsToCancel.length} reminders for today ($formattedToday).",
//         );
//       } else {
//         print(
//           "No scheduled attendance reminders found for today ($formattedToday) in local storage.",
//         );
//       }
//       print("Cancellation of today's attendance reminders complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to cancel today's attendance reminders: $e");
//       print("Stacktrace: $stacktrace");
//       NotificationService.showNotification(
//         title: 'Reminder Cancellation Failed',
//         body: 'Could not cancel attendance reminders. Please contact support.',
//       );
//       //rethrow;
//     }
//   }
// }







// import 'package:myapp/services/attendance_service.dart';
// import 'package:myapp/services/notification_services.dart';
// import 'package:myapp/services/local_storage_service.dart'; // Import LocalStorageService
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart'; // For date formatting for logging

// class AttendanceReminderManager {
//   // Base ID for attendance notifications to ensure uniqueness per day and time
//   static const int _attendanceNotificationIdBase = 10000;
//   // A distinct ID for a general, non-repeating confirmation notification
//   static const int _dailySetupConfirmationNotificationId = 9999;
//   static final LocalStorageService _localStorageService = LocalStorageService();

//   /// Generates a unique notification ID for a specific reminder time on a given date.
//   /// Combines day of year, hour, and minute to create a unique ID.
//   static int _generateNotificationId(DateTime date, int hour, int minute) {
//     // We only care about the date part for ID generation
//     final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
//     final int dayOfYear =
//         normalizedDate.difference(DateTime(normalizedDate.year)).inDays +
//         1; // 1-366
//     return _attendanceNotificationIdBase +
//         (dayOfYear * 10000) + // Max 366 days * 10000 = 3,660,000
//         (hour * 100) + // Max 23 hours * 100 = 2300
//         minute; // Max 59 minutes
//   }

//   /// Sets up attendance notifications for upcoming working days.
//   /// This function should be called on app startup and potentially after attendance is marked.
//   static Future<void> setupDailyAttendanceNotifications() async {
//     print("Setting up daily attendance notifications (1-min interval)...");

//     try {
//       // Removed the 'Welcome' and 'Test' notifications to avoid interference during login
//       // NotificationService.showNotification(title: 'DPMC Invoice System', body: 'Welcome');
//       // NotificationService.scheduleNotification(id: 5, title: 'Attendance Reminder', body: 'Test; Please log your attendance!', scheduledTime: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));

//       // 1. Get all pending notifications and cancel only our attendance-related ones
//       final List<PendingNotificationRequest> pendingNotifications =
//           await NotificationService.getPendingNotifications();
//       List<int> cancelledNotificationIds = [];
//       for (var notification in pendingNotifications) {
//         if (notification.id >= _attendanceNotificationIdBase) {
//           await NotificationService.cancelNotification(notification.id);
//           cancelledNotificationIds.add(notification.id);
//         }
//       }
//       if (cancelledNotificationIds.isNotEmpty) {
//         print(
//           "Cancelled ${cancelledNotificationIds.length} previous attendance notifications based on ID range.",
//         );
//       } else {
//         print(
//           "No previous attendance notifications (within ID range) to cancel.",
//         );
//       }

//       // 2. Clear all previously stored attendance reminder IDs from local storage
//       await _localStorageService.clearAllScheduledReminderIds();

//       // 3. Get the list of working days for the next 30 days from your API
//       final List<DateTime> workingDays = await AttendanceService.getWorkingDays(
//         daysAhead: 2, // Keeping daysAhead=2 for testing, consider changing for production
//       );
//       print("Fetched ${workingDays.length} working days.");

//       // Define the start and end times for the repeating reminders
//       const int startHour = 8;
//       const int startMinute = 30;
//       const int endHour = 20; // 8 PM
//       const int endMinute = 30; // 8:30 PM
//       const Duration reminderInterval = Duration(minutes: 1);

//       for (DateTime day in workingDays) {
//         // Normalize the date to avoid time components affecting checks
//         final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
//         final String formattedDay = DateFormat(
//           'yyyy-MM-dd',
//         ).format(normalizedDay);

//         // 4. Check if attendance is already marked for this day
//         final bool marked = await AttendanceService.isAttendanceMarked(
//           normalizedDay,
//         );

//         if (!marked) {
//           // Only schedule reminders if attendance is NOT marked
//           print(
//             "Attendance not marked for $formattedDay. Scheduling 1-min interval reminders.",
//           );

//           List<int> scheduledIdsForDay = [];
//           tz.TZDateTime currentReminderTime = tz.TZDateTime(
//             tz.local,
//             normalizedDay.year,
//             normalizedDay.month,
//             normalizedDay.day,
//             startHour,
//             startMinute,
//           );

//           tz.TZDateTime endReminderBoundary = tz.TZDateTime(
//             tz.local,
//             normalizedDay.year,
//             normalizedDay.month,
//             normalizedDay.day,
//             endHour,
//             endMinute,
//           );

//           int remindersScheduledCount = 0;
//           while (currentReminderTime.isBefore(endReminderBoundary) ||
//               currentReminderTime.isAtSameMomentAs(endReminderBoundary)) {
//             // Ensure the scheduled time is in the future
//             if (currentReminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
//               int id = _generateNotificationId(
//                 currentReminderTime,
//                 currentReminderTime.hour,
//                 currentReminderTime.minute,
//               );

//               await NotificationService.scheduleNotification(
//                 id: id,
//                 title: 'Attendance Reminder',
//                 body:
//                     'It\'s ${DateFormat('hh:mm a').format(currentReminderTime)}. Please log your attendance!',
//                 scheduledTime: currentReminderTime,
//                    );
//               scheduledIdsForDay.add(id);
//               remindersScheduledCount++;
//             }
//             currentReminderTime = currentReminderTime.add(reminderInterval);
//           }

//           // Save the scheduled IDs for this day to local storage
//           if (scheduledIdsForDay.isNotEmpty) {
//             await _localStorageService.saveScheduledReminderIds(
//               normalizedDay,
//               scheduledIdsForDay,
//             );
//             // Changed to showNotification with a distinct ID, as showScheduledNotification
//             // (from your original NotificationService) has a fixed ID (1) which could overwrite.
//             // This will show an immediate confirmation that notifications were scheduled.
//             NotificationService.showNotification(
//               title: 'DPMC Invoice System',
//               body: 'Attendance reminders scheduled for $formattedDay.',
//             );
//             print(
//               "  Scheduled $remindersScheduledCount reminders for $formattedDay.",
//             );
//           } else {
//             print(
//               "  No future reminders to schedule for $formattedDay (all times passed).",
//             );
//           }
//         } else {
//           print(
//             "Attendance already marked for $formattedDay. No reminders scheduled.",
//           );
//           // Ensure no stray reminders are in local storage for marked days
//           await _localStorageService.removeScheduledReminderIds(normalizedDay);
//         }
//       }
//       print("Attendance notification setup complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to set up daily attendance notifications: $e");
//       print("Stacktrace: $stacktrace");
//       // You might want to show a general error notification to the user here
//       NotificationService.showNotification(
//         title: 'Notification Setup Failed',
//         body: 'Could not set up attendance reminders. Please contact support.',
//       );
//       // Re-throw the error if you want the calling context (like LoginScreen) to handle it further
//       rethrow;
//     }
//   }

//   /// Call this method when a user successfully logs their attendance for the current day.
//   /// It will cancel any outstanding attendance reminders for that specific day and remove them from local storage.
//   static Future<void> cancelTodayAttendanceReminders() async {
    
//     final DateTime today = DateTime.now();
//     final DateTime normalizedToday = DateTime(
//       today.year,
//       today.month,
//       today.day,
//     );
//     final String formattedToday = DateFormat(
//       'yyyy-MM-dd',
//     ).format(normalizedToday);
//     print(
//       "Attempting to cancel today's ($formattedToday) 1-min attendance reminders...",
//     );

//     try { // Added try-catch for cancellation as well
//       // 1. Retrieve the stored IDs for today from local storage
//       final List<int> idsToCancel = await _localStorageService
//           .getScheduledReminderIds(normalizedToday);

//       if (idsToCancel.isNotEmpty) {
//         for (int id in idsToCancel) {
//           // Check if the notification is actually pending before trying to cancel
//           final List<PendingNotificationRequest> pending =
//               await NotificationService.getPendingNotifications();
//           if (pending.any((element) => element.id == id)) {
//             await NotificationService.cancelNotification(id);
//             print("  Cancelled attendance reminder with ID: $id for today.");
//           } else {
//             print(
//               "  Notification with ID: $id for today was not found pending (already delivered/cancelled).",
//             );
//           }
//         }
//         // 2. Remove the stored IDs for today from local storage
//         await _localStorageService.removeScheduledReminderIds(normalizedToday);
//         print(
//           "Successfully cancelled ${idsToCancel.length} reminders for today ($formattedToday).",
//         );
//       } else {
//         print(
//           "No scheduled attendance reminders found for today ($formattedToday) in local storage.",
//         );
//       }
//       print("Cancellation of today's attendance reminders complete.");
//     } catch (e, stacktrace) {
//       print("ERROR: Failed to cancel today's attendance reminders: $e");
//       print("Stacktrace: $stacktrace");
//       NotificationService.showNotification(
//         title: 'Reminder Cancellation Failed',
//         body: 'Could not cancel attendance reminders. Please contact support.',
//       );
//       rethrow;
//     }
//   }
// }
//   // Removed _generateNotificationIdWithSeconds as it's no longer needed for 1-minute intervals.


//   /// Call this method when a user successfully logs their attendance for the current day.
//   /// It will cancel any outstanding attendance reminders for that specific day and remove them from local storage.
//   Future<void> cancelTodayAttendanceReminders() async {
//     final DateTime today = DateTime.now();
//     final DateTime normalizedToday = DateTime(
//       today.year,
//       today.month,
//       today.day,
//     );
//     final String formattedToday = DateFormat(
//       'yyyy-MM-dd',
//     ).format(normalizedToday);
//     print(
//       "Attempting to cancel today's ($formattedToday) 1-min attendance reminders...", // Updated log message
//     );

//     // 1. Retrieve the stored IDs for today from local storage
//     final List<int> idsToCancel = await _localStorageService
//         .getScheduledReminderIds(normalizedToday);

//     if (idsToCancel.isNotEmpty) {
//       for (int id in idsToCancel) {
//         // Check if the notification is actually pending before trying to cancel
//         final List<PendingNotificationRequest> pending =
//             await NotificationService.getPendingNotifications();
//         if (pending.any((element) => element.id == id)) {
//           await NotificationService.cancelNotification(id);
//           print("  Cancelled attendance reminder with ID: $id for today.");
//         } else {
//           print(
//             "  Notification with ID: $id for today was not found pending (already delivered/cancelled).",
//           );
//         }
//       }
//       // 2. Remove the stored IDs for today from local storage
//       await _localStorageService.removeScheduledReminderIds(normalizedToday);
//       print(
//         "Successfully cancelled ${idsToCancel.length} reminders for today ($formattedToday).",
//       );
//     } else {
//       print(
//         "No scheduled attendance reminders found for today ($formattedToday) in local storage.",
//       );
//     }
//     print("Cancellation of today's attendance reminders complete.");
//   }
// }

// // class AttendanceReminderManager {
// //   // Base ID for attendance notifications to ensure uniqueness per day and time
// //   static const int _attendanceNotificationIdBase = 10000;
// //   static final LocalStorageService _localStorageService = LocalStorageService();

// //   /// Generates a unique notification ID for a specific reminder time on a given date.
// //   /// Combines day of year, hour, and minute to create a unique ID.
// //   static int _generateNotificationId(DateTime date, int hour, int minute) {
// //     // We only care about the date part for ID generation
// //     final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
// //     final int dayOfYear =
// //         normalizedDate.difference(DateTime(normalizedDate.year)).inDays +
// //         1; // 1-366
// //     return _attendanceNotificationIdBase +
// //         (dayOfYear * 10000) + // Max 366 days * 10000 = 3,660,000
// //         (hour * 100) + // Max 23 hours * 100 = 2300
// //         minute; // Max 59 minutes
// //   }

// //   /// Sets up attendance notifications for upcoming working days.
// //   /// This function should be called on app startup and potentially after attendance is marked.
// //   static Future<void> setupDailyAttendanceNotifications() async {
// //     NotificationService.showNotification(
// //       title: 'DPMC Invoice System',
// //       body: 'Welcome',
// //     );

// //     print("Setting up daily attendance notifications (10-min interval)...");

// //     // 1. Get all pending notifications and cancel only our attendance-related ones
// //     final List<PendingNotificationRequest> pendingNotifications =
// //         await NotificationService.getPendingNotifications();
// //     List<int> cancelledNotificationIds = [];
// //     for (var notification in pendingNotifications) {
// //       if (notification.id >= _attendanceNotificationIdBase) {
// //         await NotificationService.cancelNotification(notification.id);
// //         cancelledNotificationIds.add(notification.id);
// //       }
// //     }
// //     if (cancelledNotificationIds.isNotEmpty) {
// //       print(
// //         "Cancelled ${cancelledNotificationIds.length} previous attendance notifications based on ID range.",
// //       );
// //     } else {
// //       print(
// //         "No previous attendance notifications (within ID range) to cancel.",
// //       );
// //     }

// //     // 2. Clear all previously stored attendance reminder IDs from local storage
// //     await _localStorageService.clearAllScheduledReminderIds();

// //     // 3. Get the list of working days for the next 30 days from your API
// //     final List<DateTime> workingDays = await AttendanceService.getWorkingDays(
// //       daysAhead: 2,
// //     );
// //     print("Fetched ${workingDays.length} working days.");

// //     // Define the start and end times for the repeating reminders
// //     const int startHour = 8;
// //     const int startMinute = 30;
// //     const int endHour = 20; // 5 PM
// //     const int endMinute = 30; // 5:30 PM
// //     const Duration reminderInterval = Duration(minutes: 1);

// //     for (DateTime day in workingDays) {
// //       // Normalize the date to avoid time components affecting checks
// //       final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
// //       final String formattedDay = DateFormat(
// //         'yyyy-MM-dd',
// //       ).format(normalizedDay);

// //       // 4. Check if attendance is already marked for this day
// //       final bool marked = await AttendanceService.isAttendanceMarked(
// //         normalizedDay,
// //       );

// //       if (!marked) {
// //         // Only schedule reminders if attendance is NOT marked
// //         print(
// //           "Attendance not marked for $formattedDay. Scheduling 10-min interval reminders.",
// //         );

// //         List<int> scheduledIdsForDay = [];
// //         tz.TZDateTime currentReminderTime = tz.TZDateTime(
// //           tz.local,
// //           normalizedDay.year,
// //           normalizedDay.month,
// //           normalizedDay.day,
// //           startHour,
// //           startMinute,
// //         );

// //         tz.TZDateTime endReminderBoundary = tz.TZDateTime(
// //           tz.local,
// //           normalizedDay.year,
// //           normalizedDay.month,
// //           normalizedDay.day,
// //           endHour,
// //           endMinute,
// //         );

// //         int remindersScheduledCount = 0;
// //         while (currentReminderTime.isBefore(endReminderBoundary) ||
// //             currentReminderTime.isAtSameMomentAs(endReminderBoundary)) {
// //           // Ensure the scheduled time is in the future
// //           if (currentReminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
// //             int id = _generateNotificationId(
// //               currentReminderTime,
// //               currentReminderTime.hour,
// //               currentReminderTime.minute,
// //             );
// //             NotificationService.scheduleNotification(
// //               id: id,
// //               title: 'Attendance Reminder',
// //               body: 'It\'s ${DateFormat('hh:mm a').format(currentReminderTime)}. Please log your attendance!',
// //               scheduledTime: currentReminderTime,
// //               //payload:'attendance_repeat_${currentReminderTime.hour}${currentReminderTime.minute}_$formattedDay',
// //             );
// //             scheduledIdsForDay.add(id);
// //             remindersScheduledCount++;
// //           }
// //           currentReminderTime = currentReminderTime.add(reminderInterval);
// //         }

// //         // Save the scheduled IDs for this day to local storage
// //         if (scheduledIdsForDay.isNotEmpty) {
// //           await _localStorageService.saveScheduledReminderIds(
// //             normalizedDay,
// //             scheduledIdsForDay,
// //           );
// //           NotificationService.showScheduledNotification(
// //             title: 'Notifications Scheduled',
// //             body: formattedDay,
// //           );
// //           print(
// //             "  Scheduled $remindersScheduledCount reminders for $formattedDay.",
// //           );
// //         } else {
// //           print(
// //             "  No future reminders to schedule for $formattedDay (all times passed).",
// //           );
// //         }
// //       } else {
// //         print(
// //           "Attendance already marked for $formattedDay. No reminders scheduled.",
// //         );
// //         // Ensure no stray reminders are in local storage for marked days
// //         await _localStorageService.removeScheduledReminderIds(normalizedDay);
// //       }
// //     }
// //     print("Attendance notification setup complete.");
// //   }

// //   /// Call this method when a user successfully logs their attendance for the current day.
// //   /// It will cancel any outstanding attendance reminders for that specific day and remove them from local storage.
// //   static Future<void> cancelTodayAttendanceReminders() async {
// //     final DateTime today = DateTime.now();
// //     final DateTime normalizedToday = DateTime(
// //       today.year,
// //       today.month,
// //       today.day,
// //     );
// //     final String formattedToday = DateFormat(
// //       'yyyy-MM-dd',
// //     ).format(normalizedToday);
// //     print(
// //       "Attempting to cancel today's ($formattedToday) 10-min attendance reminders...",
// //     );

// //     // 1. Retrieve the stored IDs for today from local storage
// //     final List<int> idsToCancel = await _localStorageService
// //         .getScheduledReminderIds(normalizedToday);

// //     if (idsToCancel.isNotEmpty) {
// //       for (int id in idsToCancel) {
// //         // Check if the notification is actually pending before trying to cancel
// //         final List<PendingNotificationRequest> pending =
// //             await NotificationService.getPendingNotifications();
// //         if (pending.any((element) => element.id == id)) {
// //           await NotificationService.cancelNotification(id);
// //           print("  Cancelled attendance reminder with ID: $id for today.");
// //         } else {
// //           print(
// //             "  Notification with ID: $id for today was not found pending (already delivered/cancelled).",
// //           );
// //         }
// //       }
// //       // 2. Remove the stored IDs for today from local storage
// //       await _localStorageService.removeScheduledReminderIds(normalizedToday);
// //       print(
// //         "Successfully cancelled ${idsToCancel.length} reminders for today ($formattedToday).",
// //       );
// //     } else {
// //       print(
// //         "No scheduled attendance reminders found for today ($formattedToday) in local storage.",
// //       );
// //     }
// //     print("Cancellation of today's attendance reminders complete.");
// //   }
// // }
