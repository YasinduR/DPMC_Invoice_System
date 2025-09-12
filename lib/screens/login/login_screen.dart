import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_footer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:myapp/providers/auth_provider.dart'; // 2. Import the new Riverpod provider
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'yasindu');
  final _passwordController = TextEditingController(text: '12345');

  // Local state for the error message, controlled ONLY by this widget.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Clears the local error message as soon as the user types.
  void _onTextChanged() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    } else {
      // Also call setState to update the button's disabled state in real-time.
      setState(() {});
    }
  }

  /// Handles the login button press using the robust try/catch flow.
  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await ref.read(authProvider.notifier).login(context, username, password);
    } on UnauthorisedException catch (e) {
      setState(() {
        _errorMessage = e.getMessage().toString();
      });
    } on FetchDataException catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        type: MessageType.error,
      );
      setState(() {
        _errorMessage = 'Could not connect. Please try again later.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // void _handleLogin() {
  //   FocusScope.of(context).unfocus();
  //   final username = _usernameController.text;
  //   final password = _passwordController.text;
  //   ref.read(authProvider.notifier).login(context, username, password);
  // }

  void _handleForgetPassword() {
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, AppRoutes.forgetPassword);
  }

  void _handleClear() {
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final bool isdisabled =
        _usernameController.text.isEmpty || _passwordController.text.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // child: AbsorbPointer(
        //   absorbing: authState.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
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

                // Display a error message if one exists.
                // Display the error message from the LOCAL state variable.
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                AppTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  hideBorder: true, // Use "no border" style
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  hideBorder: true, // Use "no border" style
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
                // authState.isLoading
                //     ? const Center(child: CircularProgressIndicator())
                //     :
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
                  onPressed: () {},
                ),
                const SizedBox(height: 30),
                const AppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
    //);
  }
}
