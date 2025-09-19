// --IMPORTANT : REMOVE THIS FILE LATER-- //

import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart'; 
import 'package:myapp/services/icon_mapper.dart'; 
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_footer.dart'; // Your AppFooter

// Made to demonstrate By PASSING Authentication Remove this Later
class FraudMenuScreen extends StatelessWidget {
  const FraudMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of test routes to attempt to navigate to.
    final List<Map<String, dynamic>> testRoutes = [
      {
        'label': 'Invoice',
        'iconName': 'receipt_long',
        'route': '/invoice', // CHANGE: Was AppRoutes.invoice
      },
      {
        'label': 'Attendance',
        'iconName': 'checklist',
        'route': '/attendence', // CHANGE: Was AppRoutes.attendence
      },
      {
        'label': 'Profile',
        'iconName': 'person',
        'route': '/profile', // CHANGE: Was AppRoutes.profile
      },
      {
        'label': 'Forget Password',
        'iconName': 'lock_open',
        'route': AppRoutes.forgetPassword, // OK: This is still a static route
      },
      {
        'label': 'Non-Existent Route',
        'iconName': 'error',
        'route': '/this_route_does_not_exist',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Route Guard Test Menu'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const Text(
                'Attempting to bypass security',
                style: TextStyle(fontSize: 18, color: AppColors.textFaded),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: testRoutes.length,
                  itemBuilder: (context, index) {
                    final item = testRoutes[index];
                    return _MenuCard(
                      icon: IconMapper.getIcon(item['iconName']),
                      label: item['label'],
                      onTap: () {
                        // This will trigger your onGenerateRoute logic
                        Navigator.pushNamed(context, item['route']);
                      },
                    );
                  },
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

// A local copy of the _MenuCard widget from your MainMenuScreen for consistency.
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
