import 'package:flutter/material.dart';
import 'package:myapp/helpers/app_nav_items.dart';
import 'package:myapp/helpers/icon_mapper.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';

class AppNavFooter extends StatelessWidget {
  final int? currentIndex;
  final bool confirmOnNavigate;

  const AppNavFooter({
    super.key,
    this.currentIndex,
    this.confirmOnNavigate = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex ?? 0,
      selectedItemColor:
          currentIndex == null
              ? AppColors.secondary
              : AppColors.primary, // Color for selected tab
      unselectedItemColor: AppColors.secondary, // Color for unselected tabs
      selectedLabelStyle:
          currentIndex == null
              ? const TextStyle(fontWeight: FontWeight.normal)
              : const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      items:
          AppNavItems.items.map((navItem) {
            return BottomNavigationBarItem(
              icon: Icon(IconMapper.getIcon(navItem.iconName)),
              label: navItem.name,
            );
          }).toList(),
      onTap: (index) async {
        if (currentIndex != null) {
          if (currentIndex == index) {
            return;
          }
        }
        if (confirmOnNavigate) {
          final shouldNavigate = await showConfirmationDialog(
            context: context,
            title: 'Confirm Navigation',
            content:
                'Are you sure you want to leave this page? Unsaved changes will be lost.',
            confirmButtonText: 'Yes, Leave',
            cancelButtonText: 'Stay',
          );
          if (!shouldNavigate) return;
        }
        final route = AppNavItems.items[index].route;
        Navigator.pushNamed(context, route);
      },
    );
  }
}
