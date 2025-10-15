// import 'package:intl/intl.dart';
// Remove Later Depriated : Tried to include noridiction to mark attendence
// class AttendanceService {
//   /// Simulates an API call to get working days.
//   /// For this example, it returns the next 30 days, excluding weekends.
//   static Future<List<DateTime>> getWorkingDays({int daysAhead = 30}) async {
//     List<DateTime> workingDays = [];
//     DateTime now = DateTime.now();

//     for (int i = 0; i < daysAhead; i++) {
//       DateTime date = now.add(Duration(days: i));
//       // Exclude Saturday (6) and Sunday (7)
//       if (date.weekday != DateTime.saturday &&
//           date.weekday != DateTime.sunday) {
//         workingDays.add(date);
//         print(date);
//       }
//     }
//     return workingDays;
//   }

//   /// Simulates an API call to check if attendance is marked for a specific date.
//   // /// Replace with your actual attendance check API.
//   static Future<bool> isAttendanceMarked(DateTime date) async {
//     DateTime today = DateTime.now();
//     // Compare only dates, not time
//     if (date.year < today.year ||
//         (date.year == today.year && date.month < today.month) ||
//         (date.year == today.year &&
//             date.month == today.month &&
//             date.day < today.day)) {
//       return true; // Assume attendance for past days is marked
//     }
//     return false; // Placeholder: Assume not marked for future/current day
//   }

// }
