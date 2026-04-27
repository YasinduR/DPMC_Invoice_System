import 'package:myapp/helpers/app_screens.dart';
import 'package:myapp/models/screen_model.dart';

// This will Initialize Screen routes and route related mappings
class AppRoutes {
  AppRoutes._();
  // Common Routes
  // static const String authCheck = '/authCheck'; // NEW route
  // Public Routes
  static const String login = '/login';
  static const String initializer = '/initializer';
  static const String splash = '/splash';
  static const String mainMenu = '/mainMenu';
  static const String forgetPassword = '/forgetPassword';

  // Common Routes (menus)
  static const String changePassword = '/changePassword';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static final Map<String, String> screenNameToRouteMap = {};
  static final Map<String, String> routeToScreenIdMap = {};
  static final Map<String, String> routeToScreenTitleMap = {};

  static Future<void> initialize() async {
    screenNameToRouteMap.clear();
    routeToScreenIdMap.clear();
    routeToScreenTitleMap.clear();

    final List<Screen> screens = AppScreens.screens;

    for (final screen in screens) {
      final routePath = '/${screen.screenName}';

      screenNameToRouteMap[screen.screenName] = routePath;
      if (screen.menuId != '') {
        // By Pass Main Menu, Login Page , Forget Password page
        routeToScreenIdMap[routePath] = screen.screenId;
        routeToScreenTitleMap[routePath] = screen.title;
      }
    }
  }
}
