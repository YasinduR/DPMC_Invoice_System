// THIS SCREEN IS DEPRIATED REMOVE LATER
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myapp/app_routes.dart';
// import 'package:myapp/exceptions/app_exceptions.dart';
// import 'package:myapp/providers/auth_provider.dart';
// import 'package:myapp/widgets/app_snack_bars.dart';
// // Adjust these imports to your actual project structure


// class AuthCheckScreen extends ConsumerStatefulWidget {
//   const AuthCheckScreen({super.key});

//   @override
//   ConsumerState<AuthCheckScreen> createState() => _AuthCheckScreenState();
// }

// class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _performInitialAuthCheck();
//   }

//   Future<void> _performInitialAuthCheck() async {
//     final authNotifier = ref.read(authProvider.notifier);
//     // 1. Initialize AuthState from local storage (load biometric preference, saved username)
//     await authNotifier.initAuth();

//     final authState = ref.read(authProvider);

//     // 2. Check if biometric login is enabled and possible
//     if (authState.isBiometricEnabled && authState.savedUsername != null) {
//       // 3. Attempt biometric login
//       bool biometricLoginSuccessful = await authNotifier.loginWithBiometrics(
//         context,
//         (e) {
//           // Handle errors from biometric login, show a snackbar but don't stop the flow
//           _showSnackBarError(e);
//         },
//       );

//       final updatedAuthState = ref.read(authProvider); // Re-read state after biometric attempt

//       if (biometricLoginSuccessful && updatedAuthState.isLoggedIn) {
//         // If biometric login was successful and user is logged in
//         if (updatedAuthState.requiresPasswordChange) {
//           // User logged in, but needs password change (e.g., temporary or expired)
//           _navigateToLoginScreen(true); // Navigate to login, it will handle password change views
//         } else {
//           // Biometric login successful, go to main menu
//           _navigateToMainMenu();
//         }
//         return; // Exit after successful biometric attempt
//       }
//     }

//     // If biometric login was not attempted, or failed, or not enabled,
//     // proceed to the regular login screen.
//     _navigateToLoginScreen(false);
//   }

//   void _navigateToMainMenu() {
//     if (mounted) {
//       Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
//     }
//   }

//   void _navigateToLoginScreen(bool isBiometricAttempted) {
//     if (mounted) {
//       // If biometric was attempted and failed, you might want to show the overlay again
//       // or directly show the login form. The LoginScreen handles initial overlay visibility.
//       Navigator.of(context).pushReplacementNamed(AppRoutes.login);
//     }
//   }

//   void _showSnackBarError(Exception e) {
//     String message;
//     if (e is UnauthorisedException || e is AccountLockedException) {
//       message = (e as AppException).getMessage();
//     } else if (e is FetchDataException) {
//       message = 'Could not connect. Please try again later.';
//     } else {
//       message = e.toString();
//     }
//     showSnackBar(
//       context: context,
//       message: message,
//       type: MessageType.error,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show a loading indicator while performing the checks
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //CircularProgressIndicator(),
//             //SizedBox(height: 20),
//             Text('Checking authentication...'),
//           ],
//         ),
//       ),
//     );
//   }
// }