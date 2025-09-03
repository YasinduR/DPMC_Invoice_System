import 'package:flutter/material.dart';
//import 'package:provider/provider.dart'; replced with river pod
// import 'package:myapp/providers/auth_provider_old.dart'; // Import the AuthProvider
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_footer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:myapp/providers/auth_provider.dart'; // 2. Import the new Riverpod provider
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'yasindu');
  final _passwordController = TextEditingController(text: '12345');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles the login logic by calling the AuthProvider.
  void _handleLogin() {
    // Hide the keyboard
    FocusScope.of(context).unfocus();
    final username = _usernameController.text;
    final password = _passwordController.text;
    ref.read(authProvider.notifier).login(username, password);
  }

  void _handleClear() {
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to rebuild the UI based on AuthProvider changes.
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Disable user interaction while loading.
        child: AbsorbPointer(
          absorbing: authState.isLoading,
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
                  // Header section (no changes needed)
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

                  // Display an error message if one exists.
                  if (authState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: Text(
                          authState.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  // _buildTextField(
                  //   controller: _usernameController,
                  //   hintText: 'Username',
                  // ),
                  // const SizedBox(height: 20),
                  // _buildTextField(
                  //   controller: _passwordController,
                  //   hintText: 'Password',
                  //   obscureText: true,
                  // ),
                                    // Replace _buildTextField with the newly configured AppTextField
                  AppTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    hideBorder: true, // Use the new "no border" style
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    hideBorder: true, // Use the new "no border" style
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  authState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ActionButton(
                        // Replaced here
                        icon: Icons.check_circle_outline,
                        label: 'Login',
                        onPressed: _handleLogin,
                      ),
                  const SizedBox(height: 16),
                  ActionButton(
                    // Replaced here
                    icon: Icons.refresh,
                    label: 'Refresh',
                    color: AppColors.success,
                    onPressed: _handleClear,
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    // Replaced here
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
      ),
    );
  }

  // // Helper method for text fields (no changes needed)
  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String hintText,
  //   bool obscureText = false,
  // }) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       hintText: hintText,
  //       filled: true,
  //       fillColor: AppColors.white,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide.none,
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         vertical: 16,
  //         horizontal: 20,
  //       ),
  //     ),
  //   );
  // }
}
