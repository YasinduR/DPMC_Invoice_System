import 'package:flutter/material.dart';
//import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/text_form_field.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AuthenticateDealerView extends StatefulWidget {
  final Dealer dealer;
  final VoidCallback onAuthenticated;

  const AuthenticateDealerView({
    super.key,
    required this.dealer,
    required this.onAuthenticated,
  });

  @override
  State<AuthenticateDealerView> createState() => _AuthenticateDealerViewState();
}

class _AuthenticateDealerViewState extends State<AuthenticateDealerView> {
  // final _formKey = GlobalKey<FormState>(); // Still needed to trigger validation

  // final _pinController = TextEditingController();
  // //bool _isButtonDisabled = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _pinController.addListener(_validateForm);
  // }

  // void _validateForm() {
  //   // This now triggers the validation logic that is INSIDE AppTextField
  //   final isValid = _formKey.currentState?.validate() ?? false;
  //   // if (_isButtonDisabled == isValid) {
  //   //   setState(() {
  //   //     _isButtonDisabled = !isValid;
  //   //   });
  //   // }
  // }

  // @override
  // void dispose() {
  //   _pinController.removeListener(_validateForm);
  //   _pinController.dispose();
  //   super.dispose();
  // }

  // void _submit() {
  //   if (_formKey.currentState!.validate()) {
  //     widget.onAuthenticated();
  //   }
  // }

  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  // No need for a separate boolean, we can check the form's validity directly.

  @override
  void initState() {
    super.initState();
    // The listener's only job is now to call setState to rebuild the button.
    _pinController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // The listener is still attached, so it still needs to be disposed.
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    // It's still best practice to validate one final time on submit.
    if (_formKey.currentState!.validate()) {
      widget.onAuthenticated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Authenticating: ${widget.dealer.name}', // Use 'widget.' to access properties
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 20),
            AutoSizeText(
              'Authenticating: ${widget.dealer.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: _pinController,
              labelText: 'PIN',
              keyboardType: TextInputType.number,
              isPin: true,
              onFieldSubmitted: (_) => _submit(),
            ),

            const Spacer(),
            ActionButton(
              label: 'Agree',
              onPressed: _submit, // Use 'widget.' to access properties
              disabled:
                  !isFormValid, // 8. Use the state variable to control the button
            ),
          ],
        ),
      ),
    );
  }
}

// class AuthenticateDealerView extends StatelessWidget {
//   final Dealer dealer;
//   final VoidCallback onAuthenticated;
//   const AuthenticateDealerView({
//     super.key,
//     required this.dealer,
//     required this.onAuthenticated,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Authenticating: ${dealer.name}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'PIN',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             keyboardType: TextInputType.number,
//             obscureText: true,
//           ),
//           const Spacer(),
//           ActionButton(label: 'Agree', onPressed: onAuthenticated,disabled: false),
//         ],
//       ),
//     );
//   }
// }
