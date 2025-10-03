import 'package:flutter/material.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/services/icon_mapper.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/cards/menu_card.dart'; 

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final accessibleScreens = user?.accessibleScreen ?? [];

    // Modify this with screen IDs othat need to priortize
    const prioritizeOrder = [
      '004', // Invoice
      '005', // Print Invoice
      '008', // Receipt
      '009', // Returns
      '011', // Route Selection
      '010', // Re-Print
      '003', // Setup Print
      '012', // Change Password
      '006', // Profile
      '007', // Test
    ];
    final List<Screen> menuItems = List.from(accessibleScreens);

    // --- NEW MULTI-LEVEL SORTING LOGIC  PRIORITITY LIST + ROLE_ID ORDER
    menuItems.sort((a, b) {
      int menuIdCompare = b.menuId.compareTo(a.menuId);
      if (menuIdCompare != 0) {
        return menuIdCompare;
      }

      final indexA = prioritizeOrder.indexOf(a.screenId);
      final indexB = prioritizeOrder.indexOf(b.screenId);
      final sortA =
          indexA == -1 ? 999 : indexA; 
      final sortB = indexB == -1 ? 999 : indexB;
      return sortA.compareTo(sortB);
    });

    // Dynamically build the list of menu cards
    final List<Widget> menuCards =
        menuItems.map((screen) {
          final route = AppRoutes.screenNameToRouteMap[screen.screenName];
          if (route == null) return const SizedBox.shrink();

          return MenuCard(
            icon: IconMapper.getIcon(screen.iconName),
            label: screen.title,
            onTap: () => Navigator.pushNamed(context, route),
          );
        }).toList();

    // Manually add static cards like 'About' and 'Logout'
    menuCards.add(
      MenuCard(
        icon: IconMapper.getIcon('info'),
        label: 'About',
        onTap:
            () => showInfoDialog(
              context: context,
              title: 'DPMC Invoice System',
              content: 'Developed By DP Infotech',
            ),
      ),
    );
    menuCards.add(
      MenuCard(
        icon: IconMapper.getIcon('logout'),
        label: 'Logout',
        onTap: () async {
          final confirmed = await showConfirmationDialog(
            context: context,
            title: 'Are You Sure You Want to Leave?',
            confirmButtonText: 'Yes, Log out',
            cancelButtonText: 'No, I\'m Staying',
          );
          if (confirmed) {
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
      canPop: false, // Prevent default pop behavior
      contentPadding: const EdgeInsets.fromLTRB(24,60,24,20),
          child: Column(
            children: [
              Text(
                'Main Menu',
                style: Theme.of(context).textTheme.headlineLarge
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: menuCards,
                ),
              ),
              //const AppFooter(),
            ],
          ),
        );
  }
}

