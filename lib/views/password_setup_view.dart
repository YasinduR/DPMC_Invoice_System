import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Assuming Riverpod
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_option_picker.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// Password Setup view for First-time login Users
class PasswordSetupView extends ConsumerStatefulWidget {

  final Future<void> Function({
    required String newPassword,
    required SecurityQuestionAnswer securityQandA, 
  }) onSubmit;
  final VoidCallback onCancel;

  const PasswordSetupView({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  ConsumerState<PasswordSetupView> createState() => _PasswordSetupViewState();
}

class _PasswordSetupViewState extends ConsumerState<PasswordSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  final _answerController = TextEditingController();

  String? _passwordChangeErrorMessage;
  String? _selectedSecurityQuestion;
final List<String> securityQuestions = [
  'First pet\'s name?',
  'City of birth?',
  'Mother\'s maiden name?',
  'Elementary school name?',
  'First car\'s make/model?'
];

  @override
  void initState() {
    super.initState();
    _newPwdController.addListener(_onTextChanged);
    _confirmPwdController.addListener(_onTextChanged);
     _answerController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _newPwdController.removeListener(_onTextChanged);
    _confirmPwdController.removeListener(_onTextChanged);
    _answerController.removeListener(_onTextChanged);
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_passwordChangeErrorMessage != null) {
      setState(() {
        _passwordChangeErrorMessage = null;
      });
    } else {
      setState(() {});
    }
  }

    Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SelectionModal(
            title: 'Security Question',
            options: securityQuestions,
            initialValue: _selectedSecurityQuestion,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedSecurityQuestion = result;
      });
    }
  }

    Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_newPwdController.text != _confirmPwdController.text) {
      setState(() {
        _passwordChangeErrorMessage =
            'New password and confirmation do not match.';
      });
      return;
    }

    if (_selectedSecurityQuestion == null || _answerController.text.isEmpty) {
        setState(() {
            _passwordChangeErrorMessage = 'Please select a security question and provide an answer.';
        });
        return;
    }

    try {
      final securityQandA = SecurityQuestionAnswer(
        question: _selectedSecurityQuestion!,
        answer: _answerController.text,
      );

      await widget.onSubmit(
        newPassword: _newPwdController.text,
        securityQandA: securityQandA, 
      );
    } catch (e) {
      setState(() {
        _passwordChangeErrorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // Future<void> _handleSubmit() async {
  //   if (!(_formKey.currentState?.validate() ?? false)) {
  //     return;
  //   }

  //   if (_newPwdController.text != _confirmPwdController.text) {
  //     setState(() {
  //       _passwordChangeErrorMessage =
  //           'New password and confirmation do not match.';
  //     });
  //     return;
  //   }

  //   try {
  //     await widget.onSubmit(newPassword: _newPwdController.text,securityQandA: );
  //   } catch (e) {
  //     setState(() {
  //       _passwordChangeErrorMessage = e.toString().replaceFirst(
  //         'Exception: ',
  //         '',
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final bool areControllersEmpty =
        _newPwdController.text.isEmpty || _confirmPwdController.text.isEmpty || _answerController.text.isEmpty ||(_selectedSecurityQuestion==null);
    final bool passwordsMatch =
        _newPwdController.text == _confirmPwdController.text;
    final bool isFormValid = !areControllersEmpty && passwordsMatch;

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
            ListView(
              children:[
         // const SizedBox(height: 30),
          const Text(
            'Set New Password',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are required to change your temporary password.',
            style: TextStyle(fontSize: 16, color: AppColors.textFaded),
          ),
          const SizedBox(height: 30),
          if (_passwordChangeErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  _passwordChangeErrorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                const SizedBox(height: 24),
                PickerFormField(
                inputFieldLabelText: 'Select a Security Question',
                selectedOption: _selectedSecurityQuestion,
                onTap: _showReasonPicker,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _answerController,
                  labelText: 'Answer',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Answer is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
      ])),
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
            color: AppColors.danger,
            onPressed: widget.onCancel,
          ),
        ],
      );
  }
}
