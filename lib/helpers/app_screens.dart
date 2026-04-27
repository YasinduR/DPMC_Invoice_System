import 'package:myapp/models/screen_model.dart';

// INCLUDE ALL MENU INFO HERE
// Accessible Ids will be Passed on Login
class AppScreens {
  static final List<Screen> _screens = [
    // Non-menu screens
    Screen(
      screenId: 'LOGIN',
      screenName: 'login',
      menuId: '',
      title: 'Login',
      iconName: 'login',
    ),
    Screen(
      screenId: 'MAIN_MENU',
      screenName: 'mainMenu',
      menuId: '',
      title: 'Main Menu',
      iconName: 'apps',
    ),
    Screen(
      screenId: 'FORGET_PASSWORD',
      screenName: 'forgetPassword',
      menuId: '',
      title: 'Forget Password',
      iconName: 'lock_open',
    ),

    // Menu screens
    // 00 ==> Common menu Items
    // 01 ==> For Cash Collector
    // 02 ==> For Employees
    // 03 == > For Supervisors
    Screen(
      screenId: 'SETUP_PRINT',
      screenName: 'setupPrint',
      menuId: '01',
      title: 'Setup Print',
      iconName: 'settings',
    ),
    Screen(
      screenId: 'INVOICE',
      screenName: 'invoice',
      menuId: '01',
      title: 'Invoice',
      iconName: 'receipt_long',
    ),
    Screen(
      screenId: 'PRINT_INVOICE',
      screenName: 'printInvoice',
      menuId: '01',
      title: 'Print Invoice',
      iconName: 'print',
    ),
    Screen(
      screenId: 'PROFILE',
      screenName: 'profile',
      menuId: '00',
      title: 'Profile',
      iconName: 'person',
    ),
    Screen(
      screenId: 'RECEIPT',
      screenName: 'receipt',
      menuId: '01',
      title: 'Receipt',
      iconName: 'article',
    ),
    Screen(
      screenId: 'RETURNS',
      screenName: 'returns',
      menuId: '01',
      title: 'Returns',
      iconName: 'assignment_return',
    ),
    Screen(
      screenId: 'REPRINT',
      screenName: 'reprint',
      menuId: '01',
      title: 'Re-Print',
      iconName: 'replay_circle_filled',
    ),
    Screen(
      screenId: 'REGION',
      screenName: 'region',
      menuId: '01',
      title: 'Route Selection',
      iconName: 'route',
    ),
    Screen(
      screenId: 'ATTENDANCE',
      screenName: 'attendance',
      menuId: '02',
      title: 'Attendance',
      iconName: 'checklist',
    ),
    Screen(
      screenId: 'SETTING',
      screenName: 'setting',
      menuId: '00',
      title: 'Settings',
      iconName: 'security_settings',
    ),
    Screen(
      screenId: 'CHANGE_PASSWORD',
      screenName: 'changePassword',
      menuId: '00',
      title: 'Change Password',
      iconName: 'lock_reset',
    ),
    Screen(
      screenId: 'RETURN_REQUEST_ADJUST',
      screenName: 'returnRequestAdjust',
      menuId: '01',
      title: 'Return Adjustment',
      iconName: 'account_tree_sharp',
    ),
    Screen(
      screenId: 'DISPATCH_NOTE',
      screenName: 'dispatchNote',
      menuId: '01',
      title: 'Dispatch Note',
      iconName: 'local_shipping',
    ),
    Screen(
      screenId: 'ACTIVITY_LOG',
      screenName: 'activityLog',
      menuId: '01',
      title: 'Activity Log',
      iconName: 'history',
    ),
    Screen(
      screenId: 'TO_DO_LIST',
      screenName: 'toDoList',
      menuId: '01',
      title: 'To Do List',
      iconName: 'task',
    ),
    Screen(
      screenId: 'CHEQUE_SUMMARY',
      screenName: 'chequeSummary',
      menuId: '01',
      title: 'Cheque Summary',
      iconName: 'account_balance',
    ),
    Screen(
      screenId: 'SUPERVISOR_SUMMARY',
      screenName: 'supervisorSummary',
      menuId: '03',
      title: 'Supervisor Summary',
      iconName: 'supervisor_account',
    ),
  ];

  // Prefered Visibilty Order of Screens (OPTIONAL Setting)
  static const List<String> _prioritizeOrder = [
    'INVOICE',
    'PRINT_INVOICE',
    'RECEIPT',
    'RETURNS',
    'DISPATCH_NOTE',
    'RETURN_REQUEST_ADJUST',
    'REGION',
  ];

  static List<Screen> get screens => _screens;

  static List<Screen> getAccessibleScreens(List<String> accessibleScreenIds) {
    final Set<String> allowedIds = accessibleScreenIds.toSet();

    // Step 1: Get all screens that are allowed
    final List<Screen> allowed =
        _screens.where((screen) {
          // Always include screens with menuId '00' COMMON screens
          if (screen.menuId == '00') return true;
          return allowedIds.contains(screen.screenId);
        }).toList();

    if (_prioritizeOrder.isEmpty) return allowed;

    final Map<String, Screen> screenMap = {
      for (var screen in allowed) screen.screenId: screen,
    };

    final List<Screen> prioritized = [];
    for (final id in _prioritizeOrder) {
      final screen = screenMap.remove(id);
      if (screen != null) {
        prioritized.add(screen);
      }
    }
    final remaining = screenMap.values.toList();

    return [...prioritized, ...remaining];
  }
}
