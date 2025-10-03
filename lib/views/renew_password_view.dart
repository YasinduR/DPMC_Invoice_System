import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Assuming Riverpod
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// Renew Password Setup view for users with expired password
class RenewPasswordView extends ConsumerStatefulWidget {
  final Future<void> Function({required String newPassword}) onSubmit;
  final VoidCallback onCancel;

  const RenewPasswordView({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  ConsumerState<RenewPasswordView> createState() => _RenewPasswordViewState();
}

class _RenewPasswordViewState extends ConsumerState<RenewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  //final _answerController = TextEditingController();

  String? _passwordChangeErrorMessage;

  @override
  void initState() {
    super.initState();
    _newPwdController.addListener(_onTextChanged);
    _confirmPwdController.addListener(_onTextChanged);
    //  _answerController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _newPwdController.removeListener(_onTextChanged);
    _confirmPwdController.removeListener(_onTextChanged);
    // _answerController.removeListener(_onTextChanged);
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    //  _answerController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_passwordChangeErrorMessage != null) {
      setState(() {
        _passwordChangeErrorMessage = null;
      });
    } 
    else {
      setState(() {});
    }
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_newPwdController.text != _confirmPwdController.text) {
      //setState(() {
        _passwordChangeErrorMessage =
            'New password and confirmation do not match.';
      //});
      return;
    }

    try {
      await widget.onSubmit(newPassword: _newPwdController.text);
    } catch (e) {
      //setState(() {
        _passwordChangeErrorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      //});
    }
    if(_passwordChangeErrorMessage != null){
          showSnackBar(
          context: context,
          message: _passwordChangeErrorMessage!,
          type: MessageType.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool areControllersEmpty =
        _newPwdController.text.isEmpty || _confirmPwdController.text.isEmpty;
    final bool passwordsMatch =
        _newPwdController.text == _confirmPwdController.text;
    final bool isFormValid = !areControllersEmpty && passwordsMatch;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: [
              // const SizedBox(height: 30),
              Text('Set New Password',style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Your Password has been expiered You are required to change your password.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              // if (_passwordChangeErrorMessage != null)
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 20.0),
              //     child: Center(
              //       child: Text(
              //         _passwordChangeErrorMessage!,
              //         style: const TextStyle(
              //           color: AppColors.danger,
              //           fontSize: 16,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _newPwdController,
                      labelText: 'New Password',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPwdController,
                      labelText: 'Confirm New Password',
                      isPassword: true,

                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return null;
                        }
                        if (value != _newPwdController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        ActionButton(
          disabled: !isFormValid || ref.watch(authProvider).isLoading,
          icon: Icons.check_circle_outline,
          label: 'Change Password',
          onPressed: _handleSubmit,
        ),
        const SizedBox(height: 16),
        ActionButton(
          icon: Icons.cancel_outlined,
          label: 'Cancel',
          type:ActionButtonType.secondary,
          onPressed: widget.onCancel,
        ),
      ],
    );
  }
}
