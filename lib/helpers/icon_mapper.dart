import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IconMapper {
  // Old IconData map
  static const Map<String, IconData> _iconMap = {
    'login': Icons.login,
    'apps': Icons.apps,
    'lock_open': Icons.lock_open,
    'settings': Icons.settings,
    'receipt_long': Icons.receipt_long,
    'print': Icons.print,
    'person': Icons.person,
    'alarm': Icons.alarm,
    'article': Icons.article,
    'assignment_return': Icons.assignment_return,
    'replay_circle_filled': Icons.replay_circle_filled,
    'route': Icons.route, // still here for getIconData()
    'lock_reset': Icons.lock_reset,
    'info': Icons.info,
    'logout': Icons.logout,
    'checklist': Icons.checklist,
    'security_settings': Icons.security,
    'account_tree_sharp': Icons.account_tree_sharp,
    'local_shipping': Icons.local_shipping,
    'history': Icons.history,
    'home': Icons.home,
    'task': Icons.task,
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline;
  }

  // New usage for menus, supports Lottie for 'route'
  static Widget getMenuIcon(
    String iconName, {
    double size = 24.0,
    Color? color,
  }) {
    if (iconName == 'route') {
      return SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/images/route.json',
          fit: BoxFit.contain,
          repeat: true,
          reverse: false,
        ),
      );
    } else if (iconName == 'local_shipping') {
      return SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/images/delivery.json',
          fit: BoxFit.contain,
          repeat: true,
          reverse: false,
        ),
      );
    } else if (iconName == 'alarm') {
      return SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/images/alarm-clock.json',
          fit: BoxFit.contain,
          repeat: true,
          reverse: false,
        ),
      );
    } else {
      return Icon(getIcon(iconName), size: size, color: color);
    }
  }
}
