
// View for Step 1 of Forget Password : User Info Request

import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

class UserInfoRequestView extends StatefulWidget {
final Future<void> Function(String username, String email) onSubmit;
  const UserInfoRequestView({
    super.key,
    required this.onSubmit,
  });

  @override
  State<UserInfoRequestView> createState() => _UserInfoRequestViewState();
}

class _UserInfoRequestViewState extends State<UserInfoRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
            await widget.onSubmit(
        _usernameController.text,
        _emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled =
        _usernameController.text.isEmpty || _emailController.text.isEmpty;

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
                  controller: _usernameController,
                  labelText: 'Username',
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Username is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  isEmail: true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            label: 'Submit',
            disabled: isButtonDisabled,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }
}