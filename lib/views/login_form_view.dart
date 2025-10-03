import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// --- Intial Login Form View ---
class LoginFormView extends ConsumerStatefulWidget {
  //final String? loginErrorMessage;
  final void Function(String username, String password) onLogin;
  final VoidCallback onForgetPassword;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  const LoginFormView({
    super.key,
    //this.loginErrorMessage,
    required this.onLogin,
    required this.onForgetPassword,
    required this.onClear,
    required this.onCancel,
  });

  @override
  ConsumerState<LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends ConsumerState<LoginFormView> {
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  final _usernameController = TextEditingController(text: 'yasindu');
  final _passwordController = TextEditingController(text: '12345');



  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _usernameFocusNode.requestFocus(); // Set initial focus
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    //widget.onClear();
    // This will trigger a re-render to evaluate the `isdisabled` condition for the buttons
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Watch authProvider here to get loading state for the button
    final authState = ref.watch(authProvider);
    final bool isdisabled =
        _usernameController.text.isEmpty || _passwordController.text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: [
              //const SizedBox(height: 20),
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
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Invoice System',
                    style:  Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Welcome back.',
                    style:  Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Log in to your account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),

              // if (widget.loginErrorMessage !=
              //     null) // Display error message from parent
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 20.0),
              //     child: Center(
              //       child: Text(
              //         widget.loginErrorMessage!,
              //         style: const TextStyle(
              //           color: AppColors.danger,
              //           fontSize: 16,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
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
                onFieldSubmitted: (value) {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                  widget.onLogin(
                    _usernameController.text,
                    _passwordController.text,
                  );
                },
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
                  onPressed: widget.onForgetPassword,
                  child: Text(
                    'Forgot password?',
                    // style: Theme.of(context).textTheme.labelSmall
                  ),
                ),
              ),
            ],
          ),
        ),
        ActionButton(
          disabled: isdisabled || authState.isLoading,
          icon: Icons.check_circle_outline,
          label: 'Login',
          onPressed: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard
            widget.onLogin(_usernameController.text, _passwordController.text);
          },
        ),
        //const SizedBox(height: 16),
        // ActionButton(
        //   icon: Icons.refresh,
        //   label: 'Refresh',
        //   color: AppColors.success,
        //   onPressed: () {
        //     _usernameController.clear();
        //     _passwordController.clear();
        //     widget.onClear(); // Inform parent to clear its error message
        //   },
        // ),
      ],
    );
  }
}
