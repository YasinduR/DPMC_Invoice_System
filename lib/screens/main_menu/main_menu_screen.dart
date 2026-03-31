import 'package:flutter/material.dart';
import 'package:myapp/helpers/color_cycler.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/helpers/icon_mapper.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/cards/menu_card.dart'; 

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  String _selectedIconStyle = 'Material Default';
  final List<String> _iconStyles = [
    'Material Default',
    'Material 3',
    '3D',
    'Apple Glass',
    'Lucide',
    'Iconly',
    'HugeIcons',
    'Font Awesome',
    'Flutter Awesome'
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).currentUser;
    final accessibleScreens = user?.accessibleScreen ?? [];
    
    // Responsive logic: Calculate spacing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // Fixed columns as requested
    const int crossAxisCount = 3;
    // Row spacing is now responsive (approx 4.5% of screen width)
    final double mainAxisSpacing = (screenWidth * 0.045).clamp(16, 40);
    // Dynamic icon size (15% of width, clamped for extremes)
    final double iconSize = (screenWidth * 0.15).clamp(56, 80);
    // Aspect ratio: 0.75 (shorter cells) gives MORE vertical space for large icons + 2-line text
    final double childAspectRatio = 0.75;

    // Modify this with screen IDs othat need to priortize
    const prioritizeOrder = [
      '004', // Invoice
      '005', // Print Invoice
      '008', // Receipt
      '009', // Returns 
      '018', // Advice of Dispatch
      '017', // Returns Request Adjust
      '017', // Returns Request Adjust
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
    
    final colorCycler = ColorCycler(AppColors.menuTileColors);

    final List<Widget> menuCards =
        menuItems.map((screen) {
          final route = AppRoutes.screenNameToRouteMap[screen.screenName];
          if (route == null) return const SizedBox.shrink();

          final Color itemColor = colorCycler.getColor;

          return MenuCard(
            color: itemColor,
            iconWidget: IconMapper.getStyledIcon(screen.iconName, _selectedIconStyle, itemColor, iconSize),
            label: screen.title,
            onTap: () => Navigator.pushNamed(context, route),
          );
        }).toList();

    // Manually add static cards like 'About' and 'Logout'
    final Color aboutColor = colorCycler.getColor;
    menuCards.add(
      MenuCard(
        color: aboutColor,
        iconWidget: IconMapper.getStyledIcon('info', _selectedIconStyle, aboutColor, iconSize),
        label: 'About',
        onTap:
            () => showInfoDialog(
              context: context,
              title: 'DPMC Invoice System',
              content: 'Developed By DP Infotech',
            ),
      ),
    );
    final Color logoutColor = colorCycler.getColor;
    menuCards.add(
      MenuCard(
        iconWidget: IconMapper.getStyledIcon('logout', _selectedIconStyle, logoutColor, iconSize),
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
      contentPadding: const EdgeInsets.fromLTRB(12,50,12,0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Main Menu',
                    style: Theme.of(context).textTheme.headlineLarge
                  ),
                  DropdownButton<String>(
                    value: _selectedIconStyle,
                    items: _iconStyles.map((style) {
                      return DropdownMenuItem(
                        value: style,
                        child: Text(style, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedIconStyle = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(12),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
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

