import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_footer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// --- ENUM FOR VIEWS ---
enum LoginScreenView { loginForm, passwordSetup }

// --- NEW WIDGET FOR PASSWORD SETUP, NOW A CONSUMERSTATEFULWIDGET ---
class NewPasswordSetupView extends ConsumerStatefulWidget {
  final Future<void> Function({required String newPassword}) onSubmit;
  final VoidCallback onCancel;

  const NewPasswordSetupView({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  ConsumerState<NewPasswordSetupView> createState() =>
      _NewPasswordSetupViewState();
}

class _NewPasswordSetupViewState extends ConsumerState<NewPasswordSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  String? _passwordChangeErrorMessage;

  @override
  void initState() {
    super.initState();
    _newPwdController.addListener(_onTextChanged);
    _confirmPwdController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _newPwdController.removeListener(_onTextChanged);
    _confirmPwdController.removeListener(_onTextChanged);
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_passwordChangeErrorMessage != null) {
      setState(() {
        _passwordChangeErrorMessage = null;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_newPwdController.text != _confirmPwdController.text) {
      setState(() {
        _passwordChangeErrorMessage =
            'New password and confirmation do not match.';
      });
      return;
    }
    if (_newPwdController.text.length < 6) {
      // Example password policy
      setState(() {
        _passwordChangeErrorMessage =
            'New password must be at least 6 characters long.';
      });
      return;
    }
    // Get the old password from the auth state (which is the temporary one used for login)
    // final String? oldPassword = ref.read(authProvider).currentUser?.password;
    // if (oldPassword == null || oldPassword.isEmpty) {
    //    setState(() {
    //     _passwordChangeErrorMessage = 'Could not retrieve current password for verification.';
    //   });
    //   return;
    // }

    // if (_newPwdController.text == oldPassword) {
    //    setState(() {
    //     _passwordChangeErrorMessage = 'New password cannot be the same as the old password.';
    //   });
    //   return;
    // }

    try {
      await widget.onSubmit(newPassword: _newPwdController.text);
      // Success will be handled by the parent widget (LoginScreen)
    } catch (e) {
      setState(() {
        _passwordChangeErrorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool areControllersEmpty =
        _newPwdController.text.isEmpty || _confirmPwdController.text.isEmpty;
    final bool passwordsMatch =
        _newPwdController.text == _confirmPwdController.text;
    final bool isFormValid =
        !areControllersEmpty &&
        passwordsMatch &&
        (_newPwdController.text.length >= 6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Set New Password',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are required to change your temporary password.',
            style: TextStyle(fontSize: 16, color: AppColors.textFaded),
          ),
          const SizedBox(height: 30),
          if (_passwordChangeErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  _passwordChangeErrorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AppTextField(
                  controller: _newPwdController,
                  hintText: 'New Password',
                  isPassword: true,
                  hideBorder: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _confirmPwdController,
                  hintText: 'Confirm New Password',
                  isPassword: true,
                  hideBorder: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != _newPwdController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ActionButton(
            disabled:
                !isFormValid ||
                ref
                    .watch(authProvider)
                    .isLoading, // Disable if authProvider is loading too
            icon: Icons.check_circle_outline,
            label: 'Change Password',
            onPressed: _handleSubmit,
          ),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            color: AppColors.danger,
            onPressed: widget.onCancel,
          ),
        ],
      ),
    );
  }
}

// --- REFACTORED LOGIN SCREEN ---
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  final _usernameController = TextEditingController(
    text: 'yasindu',
  ); // Test with 'tempuser' for first-time login
  final _passwordController = TextEditingController(
    text: '12345',
  ); // Test with 'temp123' for first-time login

  String? _loginErrorMessage;
  LoginScreenView _currentView =
      LoginScreenView.loginForm; // Use enum for current view

  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _usernameController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    _usernameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_loginErrorMessage != null) {
      setState(() {
        _loginErrorMessage = null;
      });
    } else {
      setState(() {});
    }
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    final username = _usernameController.text;
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).login(context, username, password, (
      e,
    ) {
      _usernameFocusNode.requestFocus();
      if (e is UnauthorisedException) {
        setState(() {
          _loginErrorMessage = e.getMessage().toString();
        });
      } else if (e is FetchDataException) {
        showSnackBar(
          context: context,
          message: e.toString(),
          type: MessageType.error,
        );
        setState(() {
          _loginErrorMessage = 'Could not connect. Please try again later.';
        });
      } else {
        setState(() {
          _loginErrorMessage = e.toString();
        });
      }
    });

    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      if (authState.requiresPasswordChange) {
        setState(() {
          _currentView =
              LoginScreenView.passwordSetup; // Switch to password setup view
          _loginErrorMessage = null; // Clear any previous login errors
        });
      } else {
        // Normal login, proceed to main menu
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      }
    }
  }

  // This handler is specifically for the first-time password setup
  Future<void> _handleInitialPasswordSetup({
    required String newPassword,
  }) async {
    try {
      await ref
          .read(authProvider.notifier)
          .setPassword(
            // Call the setPassword method
            context,
            //oldPassword: oldPassword,
            newPassword: newPassword,
          );
      showSnackBar(
        context: context,
        message: 'Password changed successfully! You are now logged in.',
        type: MessageType.success,
      );
      // After successful initial password setup, user is logged in and ready for home
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
      setState(() {
        _currentView =
            LoginScreenView
                .loginForm; // Reset to login form (though we're navigating away)
        _passwordController
            .clear(); // Clear password as it's no longer the temp one
      });
    } catch (e) {
      // Error is rethrown and handled by NewPasswordSetupView's internal _passwordChangeErrorMessage
      rethrow;
    }
  }

  void _handleCancelPasswordChange() {
    // If user cancels password change, log them out and go back to login form
    ref.read(authProvider.notifier).logout(context);
    setState(() {
      _currentView = LoginScreenView.loginForm; // Switch back to login form
      _usernameController.clear();
      _passwordController.clear();
      _loginErrorMessage = 'Password change cancelled. Please log in again.';
    });
  }

  void _handleForgetPassword() {
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, AppRoutes.forgetPassword);
  }

  void _handleClear() {
    _usernameController.clear();
    _passwordController.clear();
  }

  // Helper method to build the default login form view
  Widget _buildLoginView(BuildContext context) {
    final authState = ref.watch(authProvider);
    final bool isdisabled =
        _usernameController.text.isEmpty || _passwordController.text.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/dpmc.png',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.business,
                        size: 50,
                        color: AppColors.danger,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Invoice System',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Welcome back.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Log in to your account',
            style: TextStyle(fontSize: 16, color: AppColors.textFaded),
          ),
          const SizedBox(height: 30),

          if (_loginErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  _loginErrorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          AppTextField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            hintText: 'Username',
            hideBorder: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            onFieldSubmitted: (_) {
              _passwordFocusNode.requestFocus();
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hintText: 'Password',
            onFieldSubmitted: (value) => _handleLogin(),
            isPassword: true,
            hideBorder: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgetPassword,
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: AppColors.primary, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ActionButton(
            disabled: isdisabled || authState.isLoading,
            icon: Icons.check_circle_outline,
            label: 'Login',
            onPressed: _handleLogin,
          ),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.refresh,
            label: 'Refresh',
            color: AppColors.success,
            onPressed: _handleClear,
          ),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            color: AppColors.danger,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.fraudMenu);
            },
          ),
          const SizedBox(height: 30),
          const AppFooter(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentContent;

    switch (_currentView) {
      case LoginScreenView.loginForm:
        currentContent = _buildLoginView(context);
        break;
      case LoginScreenView.passwordSetup:
        currentContent = NewPasswordSetupView(
          onSubmit: _handleInitialPasswordSetup,
          onCancel: _handleCancelPasswordChange,
        );
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              currentContent, // Display the current content based on _currentView
        ),
      ),
    );
  }
}
