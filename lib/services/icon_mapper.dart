import 'package:flutter/material.dart';


// Define Icons for the Screen menus here 
class IconMapper {
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
    'route': Icons.route,
    'lock_reset': Icons.lock_reset,
    'info': Icons.info,
    'logout': Icons.logout,
    'checklist': Icons.checklist
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline;
  }
}