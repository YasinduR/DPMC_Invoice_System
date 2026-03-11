import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/security_setting_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class SecuritySettingScreen extends ConsumerStatefulWidget {
  const SecuritySettingScreen({super.key});

  @override
  ConsumerState<SecuritySettingScreen> createState() =>
      _SecuritySettingScreenState();
}

class _SecuritySettingScreenState extends ConsumerState<SecuritySettingScreen> {
  // Use a nullable Future<bool> to hold the result of the async operation
  // Or, a simple bool with a loading state. Let's use a bool with loading.
  bool? _isBioEnabled; // Null means loading
  bool _hasfetch = false;

  @override
  void initState() {
    super.initState();
    _fetchBiometricStatus(); // Call an async function from initState
  }

  Future<void> _fetchBiometricStatus() async {
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final bool enabled = await authNotifier.isBioMetEnabled(context);
      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _isBioEnabled = enabled;
        });
      }
    } catch (e) {
      print('Error fetching biometric status: $e');
      if (mounted) {
        setState(() {
          _isBioEnabled = false; // Default to false on error
        });
      }
    } finally {
      setState(() {
        _hasfetch = true;
      });
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  // // This method handles the change from the AppSwitchSetting
  // Future<void> _handleBiometricChange(bool newValue) async {
  //   if (_isBioEnabled == newValue) return; // No change

  //   setState(() {
  //     _isBioEnabled = newValue; // Optimistically update UI
  //   });

  //   try {
  //     final authNotifier = ref.read(authProvider.notifier);

  //     if (newValue) {
  //       // Enable Auth
  //       final confirmed = await showConfirmationDialog(
  //         context: context,
  //         title: 'Enable Biometric Login?',
  //         content:
  //             'Would you like to save your information and enable biometric authentication for easier logins in the future?',
  //         confirmButtonText: 'Yes, Enable',
  //         cancelButtonText: 'No, Thanks',
  //       );
  //       if (confirmed) {
  //         final verified = await authNotifier.confirmBiometrics(context, (e) {
  //          // _showSnackBarError(e);
  //           throw (e);
  //         });
  //         if (verified) {
  //           await authNotifier.setBiometricPreference(newValue, (e) {
  //           //  _showSnackBarError(e);
  //             throw (e);
  //           });
  //         }
  //       }
  //     } else {
  //       final confirmed = await showConfirmationDialog(
  //         context: context,
  //         title: 'Disable Biometric Login?',
  //         content: 'Do you want to disable biometric authentication ?',
  //         confirmButtonText: 'Yes, Disable',
  //         cancelButtonText: 'No, Keep',
  //       );
  //       if(confirmed){
  //         await authNotifier.clearUserInfo();
  //       }
  //     }
  //   } catch (e) {
  //     //print('Error setting biometric status: $e');
  //     _showSnackBarError(e);
  //     if (mounted) {
  //       setState(() {
  //         _isBioEnabled = !newValue;
  //       });
  //     }
  //   }
  // }
 Future<void> _handleBiometricChange(bool newValue) async {
    if (_isBioEnabled == newValue) return; // No change

    setState(() {
      _isBioEnabled = newValue; // Optimistically update UI
    });

    try {
      final authNotifier = ref.read(authProvider.notifier);

      if (newValue) {
        // Enable Auth
        final confirmed = await showConfirmationDialog(
          context: context,
          title: 'Enable Biometric Login?',
          content:
              'Would you like to save your information and enable biometric authentication for easier logins in the future?',
          confirmButtonText: 'Yes, Enable',
          cancelButtonText: 'No, Thanks',
        );
        if (confirmed) {
          final verified = await authNotifier.confirmBiometrics(context, (e) {
            throw (e);
          });
          if (verified) {
            await authNotifier.setBiometricPreference(newValue, (e) {
              throw (e);
            });
          } else {
            if (mounted) {
              setState(() {
                _isBioEnabled = !newValue; // Revert UI
              });
            }
            return; 
          }
        } else {
          if (mounted) {
            setState(() {
              _isBioEnabled = !newValue; // Revert UI
            });
          }
          return; 
        }
      } else {
        // Disable Auth
        final confirmed = await showConfirmationDialog(
          context: context,
          title: 'Disable Biometric Login?',
          content: 'Do you want to disable biometric authentication ?',
          confirmButtonText: 'Yes, Disable',
          cancelButtonText: 'No, Keep',
        );
        if(confirmed){
          //await authNotifier.clearUserInfo();
          // Also set biometric preference to false in local storage
          await authNotifier.setBiometricPreference(newValue, (e) {
             throw (e);
          });
        } else {
          // User cancelled the "Disable Biometric Login" confirmation dialog
          if (mounted) {
            setState(() {
              _isBioEnabled = !newValue; // Revert UI
            });
          }
          return; // Exit as action wasn't confirmed
        }
      }
    } on Exception catch (e) { 
      _showSnackBarError(e); 
      if (mounted) {
        setState(() {
          _isBioEnabled = !newValue; // Revert UI on error
        });
      }
    } catch (e) { // Catch any other kind of error/object
      _showSnackBarError(Exception('An unexpected error occurred: ${e.toString()}'));
      if (mounted) {
        setState(() {
          _isBioEnabled = !newValue; // Revert UI on error
        });
      }
    }
  }

  void _showSnackBarError(Exception e) {
    String message;
    if (e is UnauthorisedException || e is AccountLockedException) {
      message = (e as AppException).getMessage();
    } else if (e is FetchDataException) {
      message = 'Could not connect. Please try again later.';
    } else {
      message = e.toString();
    }
    showSnackBar(context: context, message: message, type: MessageType.error);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final bool hasFetched = _hasfetch;

    if (currentUser == null) {
      return const AppPage(
        title: 'Security Settings', // Added a title
        child: Center(
          child: Text('No user is logged in. Please log in again.'),
        ),
      );
    }
    if (!hasFetched) {
      return const AppPage(
        title: 'Security Settings', // Added a title
        child: Center(child: Text('')),
      );
    }

    final bool currentBioStatus = _isBioEnabled ?? false;

    return AppPage(
      title: 'Security Settings', 
      currentRouteName: 'securitySetting',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: SecuritySettingView(
        isBioEnabled: currentBioStatus,
        onBiometricChange: _handleBiometricChange,
      ),
    );
  }
}

// class SecuritySettingScreen extends ConsumerStatefulWidget {
//   const SecuritySettingScreen({super.key});

//   @override
//   ConsumerState<SecuritySettingScreen> createState() =>
//       _SecuritySettingScreenState();
// }

// class _SecuritySettingScreenState extends ConsumerState<SecuritySettingScreen> {
//   void _goBack() {
//     Navigator.of(context).pop();
//   }
  
//     @override
//   void initState() {
//     super.initState();
//     bool _isBioEnabled = await ref.read(authProvider.notifier).isBioMetEnabled();
//   }



//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final User? currentUser = authState.currentUser;

//     if (currentUser == null) {
//       return const AppPage(
//         title: '',
//         child: Center(
//           child: Text('No user is logged in. Please log in again.'),
//         ),
//       );
//     }
//     return AppPage(
//       title: 'Attendance',
//       onBack: _goBack,
//       contentPadding: EdgeInsets.zero,
//       child: SecuritySettingView(
//         isBioEnabled: _isBioEnabled ?? false,
//         onBiometricChange: () {},
//       ),
//     );
//   }
// }
