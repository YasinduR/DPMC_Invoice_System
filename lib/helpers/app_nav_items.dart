import 'package:myapp/models/nav_item_model.dart';

// Navigation
class AppNavItems {
  static const List<NavItem> items = [
    NavItem(name: "Home", iconName: "home", route: "/mainMenu"),
    NavItem(name: "Log", iconName: "history", route: "/activityLog"),
    NavItem(name: "To Do", iconName: "task", route: "/toDo"),
    NavItem(name: "Settings", iconName: "security_settings", route: "/securitySetting"),
    NavItem(name: "Profile", iconName: "person", route: "/profile"),
  ];
  static int? getNavIndex(String name) {
  final route = '/$name';
  final index = items.indexWhere((item) => item.route == route);
  return index == -1 ? null : index; 
  }
  





}



