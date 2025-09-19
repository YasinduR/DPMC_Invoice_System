import 'package:flutter/material.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/services/icon_mapper.dart';
import 'package:myapp/theme/app_theme.dart'; // Import theme
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_footer.dart'; // Import footer
import 'package:myapp/app_routes.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:myapp/providers/auth_provider.dart'; // 2. Import the new Riverpod provider

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final accessibleScreens = user?.accessibleScreen ?? [];

    // Modify this with screen IDs othat need to priortize
    const prioritizeOrder = 
    [  
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

    // --- NEW MULTI-LEVEL SORTING LOGIC ---
    menuItems.sort((a, b) {
      int menuIdCompare = b.menuId.compareTo(a.menuId);
      if (menuIdCompare != 0) {
        return menuIdCompare;
      }

      final indexA = prioritizeOrder.indexOf(a.screenId);
      final indexB = prioritizeOrder.indexOf(b.screenId);
      final sortA = indexA == -1 ? 999 : indexA; // Push non-prioritized items to the end
      final sortB = indexB == -1 ? 999 : indexB;
      return sortA.compareTo(sortB);
    });

    // Dynamically build the list of menu cards
    final List<Widget> menuCards =
        menuItems.map((screen) {
          final route = AppRoutes.screenNameToRouteMap[screen.screenName];
          if (route == null)
            return const SizedBox.shrink(); 

          return _MenuCard(
            icon: IconMapper.getIcon(screen.iconName),
            label: screen.title,
            onTap: () => Navigator.pushNamed(context, route),
          );
        }).toList();

    // Manually add static cards like 'About' and 'Logout'
    menuCards.add(
      _MenuCard(
        icon: IconMapper.getIcon('info'),
        label: 'About',
        onTap:
            () => showInfoDialog(
              context: context,
              title: 'DPMC Invoice System',
              content: 'Developed By DP Infotech',
            ),
        //onTap: () => showAboutDialog(context: context, applicationName: 'Invoice App'),
      ),
    );
    menuCards.add(
      _MenuCard(
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
          }
        },
      ),
    );




    // =======================================================================
    // --- FOR TESTING PURPOSES ONLY ---
    // This section adds Invoice and Attendance screens for any user,
    // regardless of their role. REMOVE THIS SECTION after testing is complete.

    menuCards.add(
      _MenuCard(
        icon: IconMapper.getIcon('invoice'),
        label: 'Invoice',
        onTap: () => Navigator.pushNamed(context, '/invoice'),
      ),
    );
    menuCards.add(
      _MenuCard(
        icon: IconMapper.getIcon('attendence'),
        label: 'Attendance',
        onTap: () => Navigator.pushNamed(context, '/attendence'),
      ),
    );

    // --- END OF TESTING SECTION ---
    // =======================================================================

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const Text(
                'Main Menu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
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
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// class MainMenuScreen extends ConsumerWidget {
//   const MainMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
//           child: Column(
//             children: [
//               // 1. Main Menu Title
//               const Text(
//                 'Main Menu',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // 2. Menu Grid
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 3, // 3 items per row
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   children: [
//                     // Use a custom widget for each menu item
//                     _MenuCard(
//                       icon: Icons.receipt_long,
//                       label: 'Invoice',
//                       onTap: () {
//                         // Navigate using the named route
//                         Navigator.pushNamed(context, AppRoutes.invoice);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.print,
//                       label: 'Print Invoice',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.printInvoice);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.article,
//                       label: 'Receipt',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.reciept);
//                       },
//                     ),
//                     _MenuCard(
//                       icon:
//                           Icons.assignment_return, // Suitable icon for returns
//                       label: 'Returns',
//                       onTap: () {
//                         // You will need to define AppRoutes.returns in your router
//                         Navigator.pushNamed(context, AppRoutes.returns);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.route,
//                       label: 'Route Selection',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.region);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.replay_circle_filled,
//                       label: 'Re-Print',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.reprint);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.settings,
//                       label: 'Setup Print',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.setupPrint);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.lock_reset,
//                       label: 'Change Password',
//                       onTap: () {

//                         Navigator.pushNamed(context, AppRoutes.changePassword);
//                       },
//                     ),
//                     _MenuCard(icon: Icons.info, label: 'About', onTap: () {}),
//                     _MenuCard(
//                       icon: Icons.person,
//                       label: 'Profile',
//                       onTap: () {
//                         // Navigate to the new profile route
//                         Navigator.pushNamed(context, AppRoutes.profile);
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.logout,
//                       label: 'Logout',
//                       onTap: () async {
//                         final confirmed = await showConfirmationDialog(
//                           context: context,
//                           title: 'Are You Sure You Want to Leave?',
//                           confirmButtonText: 'Yes, Log out',
//                           cancelButtonText: 'No, I\'m Staying',
//                         );
//                         // Act based on the user's choice
//                         if (confirmed) {
//                           ref.read(authProvider.notifier).logout(context);
//                         }
//                       },
//                     ),
//                     _MenuCard(
//                       icon: Icons.alarm,
//                       label: 'Test',
//                       onTap: () {
//                         Navigator.pushNamed(context, AppRoutes.testNotify);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const AppFooter(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Helper widget for creating each card in the menu grid
class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
