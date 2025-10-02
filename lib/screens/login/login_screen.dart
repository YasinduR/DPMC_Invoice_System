import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/views/login_form_view.dart';
import 'package:myapp/views/password_setup_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/renew_password_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

enum LoginScreenView {
   loginForm, 
   passwordSetup,
   renewPassword
   }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {


  String? _loginErrorMessage;
  LoginScreenView _currentView = LoginScreenView.loginForm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _clearLoginErrorMessage() {
    if (_loginErrorMessage != null) {
      //setState(() {
        _loginErrorMessage = null;
     // });
    }
    setState(() { });
  }

  void _handleLogin(String username, String password) async {
    FocusScope.of(context).unfocus();
    _clearLoginErrorMessage();

    await ref.read(authProvider.notifier).login(context, username, password, (e) {
      if (e is UnauthorisedException || e is AccountLockedException) {
       // setState(() {
          //_loginErrorMessage = e.getMessage().toString();
          _loginErrorMessage = (e as AppException).getMessage(); 

       // });

      } else if (e is FetchDataException) {

        //setState(() {
          _loginErrorMessage = 'Could not connect. Please try again later.';
        //});
      } else {
        //setState(() {
          _loginErrorMessage = e.toString();
        //});
      }
        showSnackBar(
          context: context,
          message: _loginErrorMessage!,
          type: MessageType.error,
        );

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
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      }
    }
  }

  Future<void> _handleInitialPasswordSetup({
    required String newPassword,
    required SecurityQuestionAnswer securityQandA, // <--- NEW PARAMETER
  }) async {
    try {
      await ref.read(authProvider.notifier).setPassword(
            context,
            newPassword: newPassword,
            securityQandA: securityQandA, // <--- Pass to authProvider

          );
      showSnackBar(
        context: context,
        message: 'Password changed successfully! You are now logged in.',
        type: MessageType.success,
      );
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
              // This onError will be called if the auth service itself throws
              // RenewPasswordView handles errors displayed on the form.
              showSnackBar(
                context: context,
                message: e.toString(),
                type: MessageType.error,
              );
            },
          );
      showSnackBar(
        context: context,
        message: 'Password renewed successfully! You are now logged in.',
        type: MessageType.success,
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      setState(() {
        _currentView = LoginScreenView.loginForm; // Reset view after successful login
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
      title: _currentView == LoginScreenView.loginForm
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