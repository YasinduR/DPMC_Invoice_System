import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// View of Change Password Screen
class ChangePasswordView extends StatefulWidget {
  final Future<void> Function(String oldPassword, String newPassword) onSubmit;
  final User user;

  const ChangePasswordView({
    super.key,
    required this.user,
    required this.onSubmit,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await widget.onSubmit(
        _currentPwdController.text,
        _newPwdController.text,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPwdController.addListener(() => setState(() {}));
    _newPwdController.addListener(() => setState(() {}));
    _confirmPwdController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentPwdController.removeListener(() => setState(() {}));
    _newPwdController.removeListener(() => setState(() {}));
    _confirmPwdController.removeListener(() => setState(() {}));
    _currentPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isAddButtonDisabled =
        _currentPwdController.text.isEmpty ||
        _newPwdController.text.isEmpty ||
        _confirmPwdController.text.isEmpty ||
        !isFormValid;
    final bool isPwdSame = _newPwdController.text == _confirmPwdController.text;

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
                  controller: _currentPwdController,
                  labelText: 'Current Password',
                  obscureText: true,
                  isPassword: true,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Current password is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _newPwdController,
                  labelText: 'New Password',
                  obscureText: true,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPwdController,
                  labelText: 'Confirm New Password',
                  obscureText: true,
                  isPassword: true,
                  validator: (value) {
                    if (value != _newPwdController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              ActionButton(
                label: 'Confirm',
                disabled: isAddButtonDisabled || !isPwdSame,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}