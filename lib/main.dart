import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/screens/login/login_screen.dart';
import 'package:myapp/screens/main_menu/main_menu_screen.dart';
import 'package:myapp/screens/profile/profile_screen.dart';
import 'package:myapp/screens/reciept/reciept_screen.dart';
import 'package:myapp/screens/reprint/reprint_screen.dart';
import 'package:myapp/screens/returns/return_screen.dart';
import 'package:myapp/screens/route_selection/route_selection.dart';
import 'package:myapp/screens/setup_print/setup_print_screen.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/screens/invoice/invoice_screen.dart';
import 'package:myapp/screens/print_invoice/print_invoice_screen.dart';
//import 'package:myapp/services/notification_service.dart';
//import 'package:provider/provider.dart'; replaced with river pod
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/test_notify/test_notify.dart';
import 'package:myapp/services/notification_services.dart';
import 'package:myapp/widgets/app_snack_bars.dart'; // snack bar

import 'package:timezone/data/latest.dart' as tz;

// Import our new notification service
//import 'package:myapp/services/notification_service.dart'; ENABLE THIS LATER FIBASE CLOUD NOTIFICATION

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();

  // Initialize our notification service.
  // This will handle Firebase setup and topic subscription.
  // await NotificationService().initialize();

  // Initialize our notification service once when the app starts
  //await NotificationService().init();

  // Wrap the entire app in a ProviderScope
  runApp(const ProviderScope(child: MyApp()));
  // Now, run the app.
  //runApp(
  ///   ChangeNotifierProvider(
  //   create: (context) => AuthProvider(),
  //   child: const MyApp(),
  //  ),
  // );
}

// void main() {
//    runApp(
//     ChangeNotifierProvider(

//       create: (context) => AuthProvider(), // <-- Use the new AuthProvider
//       child: const MyApp(),
//     ),
//   );
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: authState.isLoggedIn ? const MainMenuScreen() : const LoginScreen(),
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.mainMenu: (context) => const MainMenuScreen(),
        AppRoutes.setupPrint: (context) => const SetupPrintScreen(),
        AppRoutes.invoice: (context) => const InvoiceScreen(),
        AppRoutes.printInvoice: (context) => const PrintInvoiceScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.testNotify: (context) => const TestPage(),
        AppRoutes.reciept: (context) => const RecieptScreen(),
        AppRoutes.returns: (context) => const ReturnScreen(),
        AppRoutes.reprint: (context) => const ReprintScreen(),
        AppRoutes.region: (context) => const RouteSelectionScreen(),

      },
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
