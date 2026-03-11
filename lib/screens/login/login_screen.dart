import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/security_qna_model.dart';
//import 'package:myapp/services/attendance_reminder_service.dart';
//import 'package:myapp/services/auth_service.dart';
import 'package:myapp/views/login_form_view.dart';
import 'package:myapp/views/password_setup_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/renew_password_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

enum LoginScreenView { loginForm, passwordSetup, renewPassword }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? _loginErrorMessage;
  late String? savedUserName;
  LoginScreenView _currentView = LoginScreenView.loginForm;

  @override
  void initState() {
    super.initState();
    _performInitialAuthCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Start Of Bio-Metric Section

  Future<void> _performInitialAuthCheck() async {
    final authNotifier = ref.read(authProvider.notifier);
    // await authNotifier.initAuth();
    //final authState = ref.read(authProvider);
    bool isBiometricEnabled = await authNotifier.isBioMetEnabled(context);
    String savedUsername = await authNotifier.getCurrentSavedUsername();
    if (isBiometricEnabled && savedUsername.isNotEmpty) {
      bool biometricLoginSuccessful = await authNotifier.loginWithBiometrics(
        context,
        (e) {
          _showSnackBarError(e);
        },
      );
      final updatedAuthState = ref.read(authProvider);

      if (biometricLoginSuccessful && updatedAuthState.isLoggedIn) {
        if (!updatedAuthState.requiresPasswordChange) {
          if (mounted) {
            //await AttendanceReminderManager.setupDailyAttendanceNotifications();
            Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
          }
        } else {
          // Password Change Required => Clear Current Login Info
          //await authNotifier.clearUserInfo();
          setState(() {
            _loginErrorMessage = null;
            if (updatedAuthState.passwordChangeType == 'SET') {
              _currentView = LoginScreenView.passwordSetup;
            } else if (updatedAuthState.passwordChangeType == 'RESET') {
              _currentView = LoginScreenView.renewPassword;
            }
          });
        }
        return;
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

  // End of BioMetric Section

  void _clearLoginErrorMessage() {
    if (_loginErrorMessage != null) {
      //setState(() {
      _loginErrorMessage = null;
      // });
    }
    setState(() {});
  }

  void _handleLogin(String username, String password) async {
    FocusScope.of(context).unfocus();
    _clearLoginErrorMessage();

    await ref.read(authProvider.notifier).login(context, username, password, (
      e,
    ) {
      _showSnackBarError(e);
    });

    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      if (authState.requiresPasswordChange) {
        setState(() {
          _loginErrorMessage = null;
          if (authState.passwordChangeType == 'SET') {
            _currentView = LoginScreenView.passwordSetup;
          } else if (authState.passwordChangeType == 'RESET') {
            _currentView = LoginScreenView.renewPassword;
          }
        });
      } else {

        savedUserName =
            await ref.read(authProvider.notifier).getCurrentSavedUsername();
        if (savedUserName != username) {
          // If this is a new user replace/add info to local storage.
          await _userInfoSaveOnDevice();
        } else {}
         // await AttendanceReminderManager.setupDailyAttendanceNotifications();
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      }
    }
  }

  Future<void> _handleInitialPasswordSetup({
    required String newPassword,
    required SecurityQuestionAnswer securityQandA, // <--- NEW PARAMETER
  }) async {
    try {
      await ref
          .read(authProvider.notifier)
          .setPassword(
            context,
            newPassword: newPassword,
            securityQandA: securityQandA, // <--- Pass to authProvider
          );
      await ref.read(authProvider.notifier).clearUserInfo();
      await _userInfoSaveOnDevice();
      showSnackBar(
        context: context,
        message: 'Password changed successfully! You are now logged in.',
        type: MessageType.success,
      );
      //await AttendanceReminderManager.setupDailyAttendanceNotifications();
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      setState(() {
        _currentView = LoginScreenView.loginForm;
      });
    } catch (e) {
      rethrow;
    }
  }

  // NEW: Handler for submitting the renewed password
  Future<void> _handleRenewPasswordSubmit({required String newPassword}) async {
    try {
      await ref.read(authProvider.notifier).renewPassword(
        context,
        newPassword,
        (e) {
          _showSnackBarError(e);
        },
      );
      await ref.read(authProvider.notifier).clearUserInfo();
      await _userInfoSaveOnDevice();
      showSnackBar(
        context: context,
        message: 'Password renewed successfully! You are now logged in.',
        type: MessageType.success,
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      setState(() {
        _currentView =
            LoginScreenView.loginForm; // Reset view after successful login
      });
    } catch (e) {
      rethrow; // Re-throw to be caught by the RenewPasswordView for form-specific error display
    }
  }

  // Handler for canceling password renewal
  void _handleCancelRenewPassword() {
    ref.read(authProvider.notifier).logout(context);
    setState(() {
      _currentView = LoginScreenView.loginForm;
      //_loginErrorMessage = 'Password renewal cancelled. Please log in again.';
    });
  }

  void _handleCancelPasswordChange() {
    ref.read(authProvider.notifier).logout(context);
    setState(() {
      _currentView = LoginScreenView.loginForm;
      //_loginErrorMessage = 'Password change cancelled. Please log in again.';
    });
  }

  Future<void> _userInfoSaveOnDevice() async {
    // Save Username and Pwd on local storage
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Enable Biometric Login?',
      content:
          'Would you like to save your information and enable biometric authentication for easier logins in the future?',
      confirmButtonText: 'Yes, Enable',
      cancelButtonText: 'No, Thanks',
    );
    if (confirmed) {
      final verified = await ref.read(authProvider.notifier).confirmBiometrics(
        context,
        (e) {
          _showSnackBarError(e);
        },
      );
      if (verified) {
        await ref.read(authProvider.notifier).saveUserInfo(context, (e) {
          _showSnackBarError(e);
        });
      }
    }
  }

  void _handleForgetPassword() {
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, AppRoutes.forgetPassword);
  }

  void _handleLoginViewCancel() {
    Navigator.pushNamed(context, AppRoutes.fraudMenu);
  }

  @override
  Widget build(BuildContext context) {
    Widget currentContent;

    switch (_currentView) {
      case LoginScreenView.loginForm:
        currentContent = LoginFormView(
          onLogin: _handleLogin,
          onForgetPassword: _handleForgetPassword,
          onBiometric: _performInitialAuthCheck,
          onClear: _clearLoginErrorMessage,
          onCancel: _handleLoginViewCancel,
        );
        break;
      case LoginScreenView.passwordSetup:
        currentContent = PasswordSetupView(
          onSubmit: _handleInitialPasswordSetup,
          onCancel: _handleCancelPasswordChange,
        );
        break;
      case LoginScreenView.renewPassword:
        currentContent = RenewPasswordView(
          onSubmit: _handleRenewPasswordSubmit,
          onCancel: _handleCancelRenewPassword,
        );
        break;
    }

    return AppPage(
      canPop: false,
      title:
          _currentView == LoginScreenView.loginForm
              ? 'Login'
              : (_currentView == LoginScreenView.passwordSetup
                  ? 'Set Password'
                  : 'Renew Password'), // Update title for new view
      showAppBar: false, // No app bar for login pages
      showFooter: true, // Show the common footer
      contentPadding: const EdgeInsets.fromLTRB(18, 60, 18, 24),
      child: currentContent,
    );
  }
}
