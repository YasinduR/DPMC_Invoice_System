import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// class ChangePasswordView extends StatefulWidget {
//   final Function onSubmit;
//   final User user;

//   const ChangePasswordView({
//     super.key,
//     required this.user,
//     required this.onSubmit,
//   });

//   @override
//   State<ChangePasswordView> createState() => _ChangePasswordViewState();
// }

// class _ChangePasswordViewState extends State<ChangePasswordView> {
//   final _formKey = GlobalKey<FormState>();
//   final _currentPwdController = TextEditingController();
//   final _newPwdController = TextEditingController();
//   final _confirmPwdController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     _currentPwdController.addListener(() => setState(() {}));
//     _newPwdController.addListener(() => setState(() {}));
//     _confirmPwdController.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _currentPwdController.removeListener(() => setState(() {}));
//     _newPwdController.removeListener(() => setState(() {}));
//     _confirmPwdController.removeListener(() => setState(() {}));
//     _currentPwdController.dispose();
//     _newPwdController.dispose();
//     _confirmPwdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isFormValid = _formKey.currentState?.validate() ?? false;
//     final bool isAddButtonDisabled =
//         _currentPwdController.text.isEmpty ||
//         _newPwdController.text.isEmpty ||
//         _confirmPwdController.text.isEmpty ||
//         !isFormValid;
//     final bool isPwdSame = _newPwdController.text == _confirmPwdController.text;
//     return Column(
//       children: [
//         Expanded(
//           child: Form(
//             key: _formKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 AppTextField(
//                   controller: _currentPwdController,
//                   labelText: 'Current Password',
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 20),
//                 AppTextField(
//                   controller: _currentPwdController,
//                   labelText: 'New Password',
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 16),
//                 AppTextField(
//                   controller: _currentPwdController,
//                   labelText: 'Confirm New Password',
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 16),
//               ActionButton(
//                 label: 'Submit',
//                 onPressed: () => widget.onSubmit(_currentPwdController.text, _newPwdController.text),
//                 disabled: isAddButtonDisabled || !isPwdSame,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// class ChangePasswordView extends StatefulWidget {
//   final Future<void> Function(String oldPassword, String newPassword) onSubmit;
//   final User user;

//   const ChangePasswordView({
//     super.key,
//     required this.user,
//     required this.onSubmit,
//   });

//   @override
//   State<ChangePasswordView> createState() => _ChangePasswordViewState();
// }

// class _ChangePasswordViewState extends State<ChangePasswordView> {
//   final _formKey = GlobalKey<FormState>();
//   final _currentPwdController = TextEditingController();
//   final _newPwdController = TextEditingController();
//   final _confirmPwdController = TextEditingController();

//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       await widget.onSubmit(
//         _currentPwdController.text,
//         _newPwdController.text,
//       );
//     }
//   }


//   @override
//   void initState() {
//     super.initState();
//     // No need to call setState in listeners for validation purposes.
//   }

//   @override
//   void dispose() {
//     _currentPwdController.dispose();
//     _newPwdController.dispose();
//     _confirmPwdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // We can simplify the button disabled logic inside the build method.
//     final bool isFormValid = _formKey.currentState?.validate() ?? false;

//         final bool isAddButtonDisabled =
//         _currentPwdController.text.isEmpty ||
//         _newPwdController.text.isEmpty ||
//         _confirmPwdController.text.isEmpty ||
//         !isFormValid;
//     final bool isPwdSame = _newPwdController.text == _confirmPwdController.text;
//     return Column(
//       children: [
//         Expanded(
//           child: Form(
//             key: _formKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 AppTextField(
//                   controller: _currentPwdController,
//                   labelText: 'Current Password',
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 20),

//                 // --- FIX: This was incorrectly using _currentPwdController ---
//                 AppTextField(
//                   controller: _newPwdController,
//                   labelText: 'New Password',
//                   obscureText: true,
//                   validator: (value) {
//                     if (value!.length < 4) return 'Password must be at least 4 characters';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // --- FIX: This was also incorrectly using _currentPwdController ---
//                 AppTextField(
//                   controller: _confirmPwdController,
//                   labelText: 'Confirm New Password',
//                   obscureText: true,
//                   validator: (value) {
//                     if (value != _newPwdController.text) return 'Passwords do not match';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 16),
//               ActionButton(
//                 label: 'Confirm',
//                 disabled: isAddButtonDisabled || !isPwdSame,
//                 onPressed: _handleSubmit,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

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
    // The form state check is still a good guard clause.
    if (_formKey.currentState?.validate() ?? false) {
      await widget.onSubmit(
        _currentPwdController.text,
        _newPwdController.text,
      );
    }
  }

  // --- FIX 1: ADD LISTENERS IN initState (Just like in AddCreditNotesView) ---
  @override
  void initState() {
    super.initState();
    // This is the crucial part. Every time the user types in any of the fields,
    // we call setState to trigger a rebuild, which will re-evaluate the button's state.
    _currentPwdController.addListener(() => setState(() {}));
    _newPwdController.addListener(() => setState(() {}));
    _confirmPwdController.addListener(() => setState(() {}));
  }

  // --- FIX 2: REMOVE LISTENERS IN dispose (Just like in AddCreditNotesView) ---
  @override
  void dispose() {
    // Always remove listeners to prevent memory leaks when the widget is destroyed.
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
    // This logic is now re-run on every keystroke because of the listeners.
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
                // This condition will now work perfectly because it's re-evaluated on every change.
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