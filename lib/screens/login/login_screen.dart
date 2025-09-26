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
  // Declare FocusNodes for each text field
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  final _usernameController = TextEditingController(text: 'yasindu');
  final _passwordController = TextEditingController(text: '12345');

  String? _errorMessage;

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
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
     else {
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
          _errorMessage = e.getMessage().toString();
        });
      } else if (e is FetchDataException) {
        showSnackBar(
          context: context,
          message: e.toString(),
          type: MessageType.error,
        );
        setState(() {
          _errorMessage = 'Could not connect. Please try again later.';
        });
      } else {
        setState(() {
          _errorMessage = e.toString();
        });
      }
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
                  focusNode: _usernameFocusNode, // Assign focus node
                  hintText: 'Username',
                  hideBorder: true, // Use "no border" style
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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.fraudMenu,
                    ); // Remove this Later
                  },
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
