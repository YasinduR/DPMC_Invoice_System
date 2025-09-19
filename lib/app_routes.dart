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