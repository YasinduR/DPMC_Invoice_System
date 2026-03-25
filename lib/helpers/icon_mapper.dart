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
    'checklist': Icons.checklist,
    'security_settings': Icons.security,
    'account_tree_sharp':Icons.account_tree_sharp,
    'local_shipping': Icons.local_shipping,
    'history':Icons.history,
    'home': Icons.home,
    'task': Icons.task, 
    'account_balance':Icons.account_balance,
    // Added for general security settings
    // add icon name defined : Icon files
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline;
  }
}