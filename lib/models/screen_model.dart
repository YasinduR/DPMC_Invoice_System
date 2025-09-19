
import 'package:myapp/contracts/mappable.dart';

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
  
  @override
  Map<String, dynamic> toMap() {
    return {'screenId': screenId, 'screenName': screenName,'menuId': menuId, 'title': title,'iconName': iconName};
  }
}