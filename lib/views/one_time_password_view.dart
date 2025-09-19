import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// View for Step 2 of Forget Password : One-time Password Request
class OnetimePasswordRequestView extends StatefulWidget {
  final void Function(String token) onSubmit;

  const OnetimePasswordRequestView({super.key, required this.onSubmit});

  @override
  State<OnetimePasswordRequestView> createState() =>
      _OnetimePasswordRequestViewState();
}

class _OnetimePasswordRequestViewState
    extends State<OnetimePasswordRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = _otpController.text.isEmpty;

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
                  controller: _otpController,
                  labelText: 'Password Reset Code',
                  isPassword: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'The Reset Code is required';
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
            label: 'Submit',
            disabled: isButtonDisabled,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }
}
