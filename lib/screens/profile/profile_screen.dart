import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';

import 'package:myapp/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/widgets/app_page.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract Data through river pod providers
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;

    final regionState = ref.watch(regionProvider);
    final selectedRegion = regionState.selectedRegion;
    // The entire screen is just our AppPage widget now.

    return AppPage(
      title: 'User Profile',
      child: SingleChildScrollView(
        // Wrapped the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ), // Added some horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 80, color: AppColors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Hello, ${currentUser?.username ?? 'Guest'}!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        icon: Icons.account_circle,
                        label: 'Username',
                        value: currentUser?.username ?? 'N/A',
                      ),
                      const Divider(),
                      _buildInfoTile(
                        icon: Icons.email,
                        label: 'Email Address',
                        value: currentUser?.email ?? 'N/A',
                      ),
                      const Divider(),
                      _buildInfoTile(
                        icon: Icons.badge,
                        label: 'User ID',
                        value: currentUser?.id ?? 'N/A',
                      ),
                      if (selectedRegion != null) ...[
                        const Divider(),
                        _buildInfoTile(
                          icon: Icons.map, // Or any suitable icon
                          label: 'Selected Region',
                          value: selectedRegion.region,
                        ),
                      ] else ...[
                        const Divider(),
                        _buildInfoTile(
                          icon: Icons.map,
                          label: 'Selected Region',
                          value: 'No region selected',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Added some bottom padding
            ],
          ),
        ),
      ),
    );

    // return AppPage(
    //   title: 'User Profile',

    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       const SizedBox(height: 30),
    //       const CircleAvatar(
    //         radius: 60,
    //         backgroundColor: AppColors.primary,
    //         child: Icon(Icons.person, size: 80, color: AppColors.white),
    //       ),
    //       const SizedBox(height: 20),
    //       Text(
    //         'Hello, ${currentUser?.username ?? 'Guest'}!',
    //         style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(height: 40),
    //       Card(
    //         elevation: 4,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Column(
    //             children: [
    //               _buildInfoTile(
    //                 icon: Icons.account_circle,
    //                 label: 'Username',
    //                 value: currentUser?.username ?? 'N/A',
    //               ),
    //               const Divider(),
    //               _buildInfoTile(
    //                 icon: Icons.email,
    //                 label: 'Email Address',
    //                 value: currentUser?.email ?? 'N/A',
    //               ),
    //               const Divider(),
    //               _buildInfoTile(
    //                 icon: Icons.badge,
    //                 label: 'User ID',
    //                 value: currentUser?.id ?? 'N/A',
    //               ),
    //               if (selectedRegion != null) ...[
    //                 const Divider(),
    //                 _buildInfoTile(
    //                   icon: Icons.map, // Or any suitable icon
    //                   label: 'Selected Region',
    //                   value: selectedRegion.region,
    //                 ),
    //               ] else ...[
    //                 const Divider(),
    //                 _buildInfoTile(
    //                   icon: Icons.map,
    //                   label: 'Selected Region',
    //                   value: 'No region selected',
    //                 ),
    //               ],
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textFaded,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.text,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authProvider);
//     final User? currentUser = authState.currentUser;
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       // 1. AppBar has been removed.
//       appBar: const AppHeader(title: 'User Profile'),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30), // Spacing after the header
//             // Profile Avatar
//             const CircleAvatar(
//               radius: 60,
//               backgroundColor: AppColors.primary,
//               child: Icon(Icons.person, size: 80, color: AppColors.white),
//             ),
//             const SizedBox(height: 20),

//             // Welcome Text
//             Text(
//               'Hello, ${currentUser?.username ?? 'Guest'}!',
//               style: const TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.text,
//               ),
//             ),
//             const SizedBox(height: 40),

//             // User Info Card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildInfoTile(
//                       icon: Icons.account_circle,
//                       label: 'Username',
//                       value: currentUser?.username ?? 'N/A',
//                     ),
//                     const Divider(),
//                     _buildInfoTile(
//                       icon: Icons.email,
//                       label: 'Email Address',
//                       value: currentUser?.email ?? 'N/A',
//                     ),
//                     const Divider(),
//                     _buildInfoTile(
//                       icon: Icons.badge,
//                       label: 'User ID',
//                       value: currentUser?.id ?? 'N/A',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const AppFooter(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper widget to create styled info rows (no changes needed).
//   Widget _buildInfoTile({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: AppColors.primary),
//       title: Text(
//         label,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: AppColors.textFaded,
//         ),
//       ),
//       subtitle: Text(
//         value,
//         style: const TextStyle(
//           fontSize: 16,
//           color: AppColors.text,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
