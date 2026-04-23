import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/errors/app_exceptions.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/security_setting_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Use a nullable Future<bool> to hold the result of the async operation
  // Or, a simple bool with a loading state. Let's use a bool with loading.
  bool? _isBioEnabled; // Null means loading
  bool? _isActivityHistoryClearEnabled; // Null means loading
  bool _hasfetch = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus(); // Call an async function from initState
  }

  Future<void> _fetchStatus() async {
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final bool bioenabled = await authNotifier.isBioMetEnabled(context);
      final bool historyClearEnabled = await authNotifier.isHistoryClearEnabled(
        context,
      );
      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _isBioEnabled = bioenabled;
          _isActivityHistoryClearEnabled = historyClearEnabled;
        });
      }
    } catch (e) {
      // print('Error fetching biometric status: $e');
      if (mounted) {
        setState(() {
          _isBioEnabled = false; 
          _isActivityHistoryClearEnabled = false; // Default to false on error
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

Future<void> _handleActivityHistoryChange(bool newValue) async {
  if (_isActivityHistoryClearEnabled == newValue) return;

  setState(() {
    _isActivityHistoryClearEnabled = newValue; // optimistic UI
  });

  try {
    final authNotifier = ref.read(authProvider.notifier);

    if (newValue) {
      // ✅ Enable Auto Clear
      final confirmed = await showConfirmationDialog(
        context: context,
        title: 'Enable Auto-Clear Activity History?',
        content:
            'This will automatically remove activity logs older than one day. Do you want to continue?',
        confirmButtonText: 'Yes, Enable',
        cancelButtonText: 'Cancel',
      );

      if (confirmed) {
        await authNotifier.setActivityHistoryClearPreference(
          newValue,
          (e) => throw e,
        );
      } else {
        // revert UI
        if (mounted) {
          setState(() {
            _isActivityHistoryClearEnabled = !newValue;
          });
        }
      }
    } else {
      // ✅ Disable Auto Clear
      final confirmed = await showConfirmationDialog(
        context: context,
        title: 'Disable Auto-Clear Activity History?',
        content:
            'Activity logs will no longer be cleared automatically. Do you want to continue?',
        confirmButtonText: 'Yes, Disable',
        cancelButtonText: 'Cancel',
      );

      if (confirmed) {
        await authNotifier.setActivityHistoryClearPreference(
          newValue,
          (e) => throw e,
        );
      } else {
        // revert UI
        if (mounted) {
          setState(() {
            _isActivityHistoryClearEnabled = !newValue;
          });
        }
      }
    }
  } catch (e) {
    _showSnackBarError(
      e is Exception ? e : Exception(e.toString()),
    );

    if (mounted) {
      setState(() {
        _isActivityHistoryClearEnabled = !newValue;
      });
    }
  }
}

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
        if (confirmed) {
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
    } catch (e) {
      // Catch any other kind of error/object
      _showSnackBarError(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
      if (mounted) {
        setState(() {
          _isBioEnabled = !newValue; // Revert UI on error
        });
      }
    }
  }

  void _showSnackBarError(Exception e) {
    String message;
    if (e is UnauthorisedException) {
      message = e.toString();
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
        title: 'Settings', // Added a title
        child: Center(
          child: Text('No user is logged in. Please log in again.'),
        ),
      );
    }
    if (!hasFetched) {
      return const AppPage(
        title: 'Settings', // Added a title
        child: Center(child: Text('')),
      );
    }

    final bool currentBioStatus = _isBioEnabled ?? false;
    final bool currentHistoryStatus = _isActivityHistoryClearEnabled ?? false;

    return AppPage(
      title: 'Settings',
      currentRouteName: 'securitySetting',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: SettingsView(
        isBioEnabled: currentBioStatus,
        onBiometricChange: _handleBiometricChange,
    isActivityHistoryClearEnabled: currentHistoryStatus,
    onActivityHistoryClearChange: _handleActivityHistoryChange, // ✅ NEW
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
