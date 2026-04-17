import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

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
    'supervisor_account':Icons.supervisor_account,
    // Added for general security settings
    // add icon name defined : Icon files
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline;
  }

  // Lucide Icons - Added by Darshan R on 2026-03-30
  static IconData getLucideIcon(String iconName) {
    switch (iconName) {
      case 'login': return LucideIcons.logIn;
      case 'apps': return LucideIcons.layoutGrid;
      case 'lock_open': return LucideIcons.unlock;
      case 'settings': return LucideIcons.settings;
      case 'receipt_long': return LucideIcons.receipt;
      case 'print': return LucideIcons.printer;
      case 'person': return LucideIcons.user;
      case 'alarm': return LucideIcons.alarmClock;
      case 'article': return LucideIcons.fileText;
      case 'assignment_return': return LucideIcons.cornerUpLeft;
      case 'replay_circle_filled': return LucideIcons.rotateCcw;
      case 'route': return LucideIcons.map;
      case 'lock_reset': return LucideIcons.keySquare;
      case 'info': return LucideIcons.info;
      case 'logout': return LucideIcons.logOut;
      case 'checklist': return LucideIcons.listChecks;
      case 'security_settings': return LucideIcons.shield;
      case 'account_tree_sharp': return LucideIcons.network;
      case 'local_shipping': return LucideIcons.truck;
      case 'history': return LucideIcons.history;
      case 'home': return LucideIcons.home;
      case 'task': return LucideIcons.checkSquare;
      case 'account_balance': return LucideIcons.landmark;
      case 'supervisor_account': return LucideIcons.users;
      default: return LucideIcons.helpCircle;
    }
  }

  // Iconly Icons - Added by Darshan R on 2026-03-30
  static IconData getIconlyIcon(String iconName) {
    switch (iconName) {
      case 'login': return IconlyLight.login;
      case 'apps': return IconlyLight.category;
      case 'lock_open': return IconlyLight.unlock;
      case 'settings': return IconlyLight.setting;
      case 'receipt_long': return IconlyLight.document;
      case 'print': return IconlyLight.paper;
      case 'person': return IconlyLight.profile;
      case 'alarm': return IconlyLight.timeCircle;
      case 'article': return IconlyLight.paperPlus;
      case 'assignment_return': return IconlyLight.arrowLeft2;
      case 'replay_circle_filled': return IconlyLight.swap;
      case 'route': return IconlyLight.location;
      case 'lock_reset': return IconlyLight.password;
      case 'info': return IconlyLight.infoSquare;
      case 'logout': return IconlyLight.logout;
      case 'checklist': return IconlyLight.show;
      case 'security_settings': return IconlyLight.shieldDone;
      case 'account_tree_sharp': return IconlyLight.profile;
      case 'local_shipping': return IconlyLight.send;
      case 'history': return IconlyLight.timeCircle;
      case 'home': return IconlyLight.home;
      case 'task': return IconlyLight.tickSquare;
      case 'account_balance': return IconlyLight.wallet;
      case 'supervisor_account': return IconlyLight.profile;
      default: return IconlyLight.infoSquare;
    }
  }

  // Huge Icons - Added by Darshan R on 2026-03-30
  static dynamic getHugeIconData(String iconName) {
    switch (iconName) {
      case 'login': return HugeIcons.strokeRoundedLogin01;
      case 'apps': return HugeIcons.strokeRoundedDashboardSquare01;
      case 'lock_open': return HugeIcons.strokeRoundedKey01;
      case 'settings': return HugeIcons.strokeRoundedSettings01;
      case 'receipt_long': return HugeIcons.strokeRoundedInvoice01;
      case 'print': return HugeIcons.strokeRoundedPrinter;
      case 'person': return HugeIcons.strokeRoundedUser;
      case 'alarm': return HugeIcons.strokeRoundedClock01;
      case 'article': return HugeIcons.strokeRoundedInvoice01;
      case 'assignment_return': return HugeIcons.strokeRoundedArrowTurnBackward;
      case 'replay_circle_filled': return HugeIcons.strokeRoundedRefresh;
      case 'route': return HugeIcons.strokeRoundedRoute01;
      case 'lock_reset': return HugeIcons.strokeRoundedKey01;
      case 'info': return HugeIcons.strokeRoundedInformationCircle;
      case 'logout': return HugeIcons.strokeRoundedLogout01;
      case 'checklist': return HugeIcons.strokeRoundedTask01;
      case 'security_settings': return HugeIcons.strokeRoundedShield01;
      case 'account_tree_sharp': return HugeIcons.strokeRoundedHierarchy;
      case 'local_shipping': return HugeIcons.strokeRoundedRoute01;
      case 'history': return HugeIcons.strokeRoundedTransactionHistory;
      case 'home': return HugeIcons.strokeRoundedHome01;
      case 'task': return HugeIcons.strokeRoundedTaskDone01;
      case 'account_balance': return HugeIcons.strokeRoundedBank;
      case 'supervisor_account': return HugeIcons.strokeRoundedUserGroup;
      default: return HugeIcons.strokeRoundedHelpCircle;
    }
  }

  // Font Awesome Icons - Added by Darshan R on 2026-03-30
  static IconData getFaIcon(String iconName) {
    switch (iconName) {
      case 'login': return FontAwesomeIcons.rightToBracket;
      case 'apps': return FontAwesomeIcons.grip;
      case 'lock_open': return FontAwesomeIcons.lockOpen;
      case 'settings': return FontAwesomeIcons.gear;
      case 'receipt_long': return FontAwesomeIcons.receipt;
      case 'print': return FontAwesomeIcons.print;
      case 'person': return FontAwesomeIcons.user;
      case 'alarm': return FontAwesomeIcons.clock;
      case 'article': return FontAwesomeIcons.solidFileLines;
      case 'assignment_return': return FontAwesomeIcons.arrowRotateLeft;
      case 'replay_circle_filled': return FontAwesomeIcons.rotate;
      case 'route': return FontAwesomeIcons.route;
      case 'lock_reset': return FontAwesomeIcons.unlockKeyhole;
      case 'info': return FontAwesomeIcons.circleInfo;
      case 'logout': return FontAwesomeIcons.rightFromBracket;
      case 'checklist': return FontAwesomeIcons.listCheck;
      case 'security_settings': return FontAwesomeIcons.shieldHalved;
      case 'account_tree_sharp': return FontAwesomeIcons.networkWired;
      case 'local_shipping': return FontAwesomeIcons.truckFast;
      case 'history': return FontAwesomeIcons.clockRotateLeft;
      case 'home': return FontAwesomeIcons.house;
      case 'task': return FontAwesomeIcons.listCheck;
      case 'account_balance': return FontAwesomeIcons.buildingColumns;
      case 'supervisor_account': return FontAwesomeIcons.usersGear;
      default: return FontAwesomeIcons.circleQuestion;
    }
  }

  static IconData getIconDataByStyle(String iconName, String style) {
    switch (style) {
      case 'Lucide': return getLucideIcon(iconName);
      case 'Iconly': return getIconlyIcon(iconName);
      case 'Font Awesome': return getFaIcon(iconName);
      // HugeIcons cannot be converted to IconData, thus cannot be used here without widget modification
      default: return getIcon(iconName);
    }
  }

  // Styled Icons - Added by Darshan R on 2026-03-30
  static Widget getStyledIcon(String iconName, String style, Color fallbackColor, double size) {
    final iconData = getIcon(iconName);
    
    if (style == 'Material 3') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: fallbackColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(iconData, size: size, color: fallbackColor),
      );
    } else if (style == '3D') {
      return Container(
        width: size + 16,
        height: size + 16,
        decoration: BoxDecoration(
          color: fallbackColor,
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              fallbackColor.withOpacity(0.7),
              fallbackColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: fallbackColor.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: const Offset(-2, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Icon(iconData, size: size, color: Colors.white),
        ),
      );
    } else if (style == 'Apple Glass') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: size + 20,
            height: size + 20,
            decoration: BoxDecoration(
              color: fallbackColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: fallbackColor.withOpacity(0.3),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  fallbackColor.withOpacity(0.3),
                  fallbackColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Icon(iconData, size: size, color: fallbackColor),
            ),
          ),
        ),
      );
    } else if (style == 'Lucide') {
      return Icon(getLucideIcon(iconName), size: size, color: fallbackColor);
    } else if (style == 'Iconly') {
      return Icon(getIconlyIcon(iconName), size: size, color: fallbackColor);
    } else if (style == 'HugeIcons') {
      return HugeIcon(icon: getHugeIconData(iconName), color: fallbackColor, size: size);
    } else if (style == 'Font Awesome') {
      return FaIcon(getFaIcon(iconName), size: size, color: fallbackColor);
    } else if (style == 'Flutter Awesome') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fallbackColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: fallbackColor.withOpacity(0.8),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              fallbackColor.withOpacity(0.8),
              Colors.purpleAccent,
              Colors.orangeAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FaIcon(getFaIcon(iconName), size: size, color: Colors.white),
        ),
      );
    }

    return Icon(iconData, size: size, color: fallbackColor);
  }
}