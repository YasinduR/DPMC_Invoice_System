import 'package:myapp/models/screen_model.dart';
import 'package:myapp/services/api_util_service.dart';

// This will Initialize Screen routes and route related mappings
class AppRoutes {
  AppRoutes._();
  // Common Routes
  static const String login = '/login';
  static const String fraudMenu = '/fraudMenu'; // Remove Later
  static const String mainMenu = '/mainMenu';
  static const String forgetPassword = '/forgetPassword';

  static final Map<String, String> screenNameToRouteMap = {};

  static final Map<String, String> routeToScreenIdMap = {};

  static final Map<String, String> routeToScreenTitleMap = {};

  static Future<void> initialize() async{
    screenNameToRouteMap.clear();
    routeToScreenIdMap.clear();
    routeToScreenTitleMap.clear();

   final List<Screen> screens = await loadScreens();

    for (final screen in screens) {
      final routePath = '/${screen.screenName}';

      screenNameToRouteMap[screen.screenName] = routePath;
      if (screen.menuId != 'N/A') {
        // By Pass Main Menu, Login Page , Forget Password page
        routeToScreenIdMap[routePath] = screen.screenId;
        routeToScreenTitleMap[routePath] = screen.title;
      }
    }
  }
}


// class AppRoutes {
//   AppRoutes._();

//   static const String login = '/login';
//   static const String mainMenu = '/mainMenu';
//   static const String setupPrint = '/setupPrint';
//   static const String invoice = '/invoice';
//   static const String printInvoice = '/printInvoice';
//   static const String profile = '/profile';
//   static const String testNotify = '/testNotify';
//   static const String reciept = '/reciept';
//   static const String returns = '/returns';
//   static const String reprint = '/reprint';
//   static const String region = '/region';
//   static const String changePassword = '/changePassword';
//   static const String forgetPassword = '/forgetPassword';
//   static const String attendence = '/attendence';
//   static const String fraudMenu = '/fraudMenu';

//   static final Map<String, String> routes = {
//     // Non menu screens
//     'login': login,
//     'mainMenu': mainMenu,
//     'forgetPassword': forgetPassword,
//     // Menu
//     'setupPrint': setupPrint,
//     'invoice': invoice,
//     'printInvoice': printInvoice,
//     'profile': profile,
//     'testNotify': testNotify,
//     'reciept': reciept,
//     'returns': returns,
//     'reprint': reprint,
//     'region': region,
//     'changePassword': changePassword,
//     'attendence': attendence,

//     // fraud menu
//     'fraudMenu': fraudMenu

//   };

//   /// A map that links route names to their corresponding screen IDs for permission checks.
//   static const Map<String, String> routeToScreenIdMap = {
//     AppRoutes.setupPrint: '003',
//     AppRoutes.invoice: '004',
//     AppRoutes.printInvoice: '005',
//     AppRoutes.profile: '006',
//     AppRoutes.testNotify: '007',
//     AppRoutes.reciept: '008',
//     AppRoutes.returns: '009',
//     AppRoutes.reprint: '010',
//     AppRoutes.region: '011',
//     AppRoutes.changePassword: '012',
//     AppRoutes.attendence: '014',
//   };
// }

