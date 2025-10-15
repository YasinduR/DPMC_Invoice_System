import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app_router.dart';
import 'package:timezone/timezone.dart' as tz;
//import 'package:workmanager/workmanager.dart';

/// import 'package:myapp/services/attendance_service.dart';
// import 'package:myapp/screens/login/login_screen.dart';
// import 'package:myapp/screens/main_menu/main_menu_screen.dart';
import 'package:myapp/services/notification_services.dart';
//import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/app_routes.dart';
//import 'package:myapp/providers/auth_provider.dart';
import 'package:timezone/data/latest.dart' as tz;



// Define a unique name for the WorkManager task
//const String simpleWorkManagerTaskName = "Attendence_Start_Reminder";

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     //print("Workmanager: Executing task: $taskName");

//     // Initialize notification service in background context if it hasn't been.
//     // This is important because the background isolate is separate.
//     await NotificationService.initialize();

//     if (taskName == "Attendence_Start_Reminder") {
//       final DateTime now = DateTime.now();
//       final String formattedTime = DateFormat('hh:mm a').format(now);

//       // Define the reminder window (8:30 AM to 5:00 PM)
//       const int startHour = 8;
//       const int startMinute = 30;
//       const int endHour = 17; // 5 PM
//       const int endMinute = 0;

//       // Create TZDateTime for comparison to handle local time correctly
//       final tz.TZDateTime nowInLocal = tz.TZDateTime.now(tz.local);
//       final tz.TZDateTime reminderStartTime = tz.TZDateTime(
//         tz.local,
//         nowInLocal.year,
//         nowInLocal.month,
//         nowInLocal.day,
//         startHour,
//         startMinute,
//       );
//       final tz.TZDateTime reminderEndTime = tz.TZDateTime(
//         tz.local,
//         nowInLocal.year,
//         nowInLocal.month,
//         nowInLocal.day,
//         endHour,
//         endMinute,
//       );

//       // Check if current time is within the reminder window
//       final bool isWithinReminderWindow = nowInLocal.isAfter(reminderStartTime) && nowInLocal.isBefore(reminderEndTime);

//       //print("Workmanager: Current time: ${DateFormat('HH:mm').format(now)}, within window: $isWithinReminderWindow");

//       if (isWithinReminderWindow) {
//         // --- NO VALIDATION / EXTRA METHODS ---
//         // Just show the notification if within the time bracket
//         await NotificationService.showNotification(
//           //id: 101, // A fixed ID for this simple WorkManager-triggered notification
//           title: 'Simple Reminder',
//           body: 'It\'s $formattedTime. This is your reminder to Start Attendence !',
//         );
//         //print("Workmanager: Simple reminder notification shown at $formattedTime.");
//       } else {
//         //print("Workmanager: Outside reminder window. No notification shown.");
//       }
//       return Future.value(true); // Indicate successful execution
//     } else {
//       //print("Workmanager: Unknown task: $taskName");
//       return Future.value(false); // Indicate failure or unhandled task
//     }
//   });
// }

// // Function to register the WorkManager task
// Future<void> registerSimpleWorkManagerReminder() async {
//   print("Registering simple 15-min WorkManager reminder task...");
//   await Workmanager().registerPeriodicTask(
//     "Attendence_Start_Reminder",
//     "Attendence_Start_Reminder", // The task name to be executed in callbackDispatcher
//     frequency: const Duration(seconds: 30),    // constraints: Constraints(
//     //   networkType: NetworkType.connected, // Only run when there's an active network
//     // ),
//     existingWorkPolicy: ExistingWorkPolicy.replace, // Replace if already exists
//   );
//   //print("WorkManager periodic task '$simpleWorkManagerTaskName' registered.");
//   await NotificationService.showNotification(
//     title: 'WorkManager Test',
//     body: '15-min reminders registered (8:30 AM - 5:00 PM).',
//   );
// }

// // Function to cancel the WorkManager task
// Future<void> cancelSimpleWorkManagerReminder() async {
//   //print("Attempting to cancel simple WorkManager reminder...");
//   await Workmanager().cancelByUniqueName("Attendence_Start_Reminder");
//   //print("Successfully cancelled WorkManager task '$simpleWorkManagerTaskName'.");
//   await NotificationService.showNotification(
//     title: 'WorkManager Test',
//     body: '15-min reminders cancelled.',
//   );
// }






Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Time Zone for scheduled notifications
  //await NotificationService.initialize(); // Local Nofication Service // Integrate Firebase notifications later
  await AppRoutes.initialize(); // Collect Screen data from db and create App Routes
  //AttendanceReminderManager.setupDailyAttendanceNotifications();
  
  // Initialize Workmanager
  // await Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true, // Set to false for production
  // );

  // Initialize NotificationService
  await NotificationService.initialize();

  // Register the WorkManager task once at app startup
  //await registerSimpleWorkManagerReminder();

  runApp(
    const ProviderScope(child: MyApp()),
  ); // Run app with riverpod provider scope
    // Initialize Workmanager


}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Invoice App',
      theme: appTheme(context),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}