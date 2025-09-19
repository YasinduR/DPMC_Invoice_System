import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// View for Step 3 of Forget Password : New Password Setup

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

  @override
  void initState() {
    super.initState();
    _newPwdController.addListener(() => setState(() {}));
    _confirmPwdController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _newPwdController.dispose();
    _confirmPwdController.dispose();
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
                AppTextField(
                  controller: _newPwdController,
                  labelText: 'New Password',
                  obscureText: true,
                  isPassword: true,
                  validator:
                      (value) =>
                          (value?.isEmpty ?? true)
                              ? 'New password is required'
                              : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _confirmPwdController,
                  labelText: 'Confirm New Password',
                  obscureText: true,
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
