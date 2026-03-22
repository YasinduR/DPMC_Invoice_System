import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_password_input_field.dart';
import 'package:myapp/widgets/app_password_strength_indicator.dart';

// last step of Forget Password : New Password Setup
class NewPasswordSetupView extends StatefulWidget {
  final Future<void> Function(String newPassword) onSubmit;
  const NewPasswordSetupView({super.key, required this.onSubmit});

  @override
  State<NewPasswordSetupView> createState() => _NewPasswordSetupViewState();
}

class _NewPasswordSetupViewState extends State<NewPasswordSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  
  late FocusNode _newPwdFocusNode;
  late FocusNode _confirmPwdFocusNode;

  @override
  void initState() {
    super.initState();
    _newPwdFocusNode = FocusNode();
    _confirmPwdFocusNode = FocusNode();

    _newPwdController.addListener(() => setState(() {}));
    _confirmPwdController.addListener(() => setState(() {}));

    _newPwdFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    _newPwdFocusNode.dispose();
    _confirmPwdFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await widget.onSubmit(_newPwdController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isPwdSame = _newPwdController.text == _confirmPwdController.text;
    final bool isButtonDisabled =
        _newPwdController.text.isEmpty ||
        _confirmPwdController.text.isEmpty ||
        !isFormValid ||
        !isPwdSame;

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Modified to use PasswordInput field by Darshan R on 19/03/2026
                PasswordInputField(
                  controller: _newPwdController,
                  labelText: 'New Password',
                  focusNode: _newPwdFocusNode,
                  enforceStrength: true, // Enable password strength requirements
                  onFieldSubmitted: (_) {
                    _confirmPwdFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 8),
                if (_newPwdController.text.isNotEmpty)
                  PasswordStrengthIndicator(
                    password: _newPwdController.text,
                  ),
                const SizedBox(height: 16),
                PasswordInputField(
                  controller: _confirmPwdController,
                  focusNode: _confirmPwdFocusNode,
                  labelText: 'Confirm New Password',
                  onFieldSubmitted: (_) {
                    _handleSubmit();
                  },
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
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            label: 'Confirm',
            disabled: isButtonDisabled,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }
}
