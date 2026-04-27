import 'package:flutter/material.dart';
import 'package:myapp/helpers/app_screens.dart';
import 'package:myapp/helpers/color_cycler.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/helpers/icon_mapper.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/cards/menu_card.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final accessibleScreens = user?.accessibleScreens ?? [];
    final selectedStyle = ref.watch(settingsProvider).iconStyle;
    // Responsive logic: Calculate spacing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // Row spacing is now responsive
    final double mainAxisSpacing = (screenWidth * 0.045).clamp(16.0, 40.0);
    final double crossAxisSpacing = (screenWidth * 0.04).clamp(12.0, 24.0);
    // Dynamic icon size
    final double iconSize = (screenWidth * 0.15).clamp(56.0, 80.0);
    // Adjust aspect ratio to give more vertical space if needed
    final double childAspectRatio = (screenWidth < 600) ? 0.8 : 1.0;
    // Modify this with screen IDs othat need to priortize
    // const prioritizeOrder = [
    //   // '004', // Invoice
    //   // '005', // Print Invoice
    //   // '008', // Receipt
    //   // '009', // Returns
    //   // '018', // Advice of Dispatch
    //   // '017', // Returns Request Adjust
    //   // '011', // Route Selection
    //   // '010', // Re-Print
    //   // '003', // Setup Print
    //   // '012', // Change Password
    //   // '006', // Profile
    //   // '007', // Test
    // ];
    // final List<Screen> menuItems = List.from(accessibleScreens);
    // // --- NEW MULTI-LEVEL SORTING LOGIC  PRIORITITY LIST + ROLE_ID ORDER
    // menuItems.sort((a, b) {
    //   int menuIdCompare = b.menuId.compareTo(a.menuId);
    //   if (menuIdCompare != 0) {
    //     return menuIdCompare;
    //   }

    //   final indexA = prioritizeOrder.indexOf(a.screenId);
    //   final indexB = prioritizeOrder.indexOf(b.screenId);
    //   final sortA = indexA == -1 ? 999 : indexA;
    //   final sortB = indexB == -1 ? 999 : indexB;
    //   return sortA.compareTo(sortB);
    // });

    final List<Screen> menuItems = AppScreens.getAccessibleScreens(accessibleScreens);
    final colorCycler = ColorCycler(AppColors.menuTileColors);

    final List<Widget> menuCards =
        menuItems.map((screen) {
          final route = AppRoutes.screenNameToRouteMap[screen.screenName];
          if (route == null) return const SizedBox.shrink();

          final itemColor = colorCycler.getColor;

          return MenuCard(
            color: itemColor,
            iconWidget: IconMapper.getStyledIcon(
              screen.iconName,
              selectedStyle,
              itemColor,
              iconSize,
            ),
            label: screen.title,
            onTap: () => Navigator.pushNamed(context, route),
          );
        }).toList();

    // Manually add static cards like 'About' and 'Logout'
    final aboutColor = colorCycler.getColor;
    menuCards.add(
      MenuCard(
        color: aboutColor,
        iconWidget: IconMapper.getStyledIcon(
          'info',
          selectedStyle,
          aboutColor,
          iconSize,
        ),
        label: 'About',
        onTap:
            () => showInfoDialog(
              context: context,
              title: 'DPMC Invoice System',
              content: 'Developed By DP Infotech',
            ),
      ),
    );
    final logoutColor = colorCycler.getColor;
    menuCards.add(
      MenuCard(
        iconWidget: IconMapper.getStyledIcon(
          'logout',
          selectedStyle,
          logoutColor,
          iconSize,
        ),
        color: logoutColor,
        label: 'Logout',
        onTap: () async {
          final confirmed = await showConfirmationDialog(
            context: context,
            title: 'Are You Sure You Want to Leave?',
            confirmButtonText: 'Yes, Log out',
            cancelButtonText: 'No, I\'m Staying',
          );
          if (confirmed && context.mounted) {
            ref.read(authProvider.notifier).logout(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (Route<dynamic> route) =>
                  false, // Predicate to remove all previous routes
            );
          }
        },
      ),
    );

    return AppPage(
      title: 'Main Menu',
      showAppBar: false,
      currentRouteName: 'mainMenu',
      canPop: false, // Prevent default pop behavior
      contentPadding: const EdgeInsets.fromLTRB(12, 50, 12, 0),
      child: Column(
        children: [
          Text('Main Menu', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(12),
              crossAxisCount: 3,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: childAspectRatio,
              children: menuCards,
            ),
          ),
          //const AppFooter(),
        ],
      ),
    );
  }
}
