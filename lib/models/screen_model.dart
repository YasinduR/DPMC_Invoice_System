
import 'package:myapp/mappers/mappable.dart';

class Screen implements Mappable {
  final String screenId;
  final String screenName; // e.g., 'setupPrint', used for routing
  final String menuId;
  final String title;      // e.g., 'Setup Print', used for display
  final String iconName;   // e.g., 'settings', a string representing the icon

  Screen({
    required this.screenId,
    required this.screenName,
    required this.menuId,
    required this.title,
    required this.iconName,
  });
  
  // fromMap named constructor for deserialization
  @override
  Screen.fromMap(Map<String, dynamic> map)
      : screenId = map['screenId'] as String,
        screenName = map['screenName'] as String,
        menuId = map['menuId'] as String,
        title = map['title'] as String,
        iconName = map['iconName'] as String;

  // toMap method for serialization
  @override
  Map<String, dynamic> toMap() {
    return {
      'screenId': screenId,
      'screenName': screenName,
      'menuId': menuId,
      'title': title,
      'iconName': iconName,
    };
  }


}