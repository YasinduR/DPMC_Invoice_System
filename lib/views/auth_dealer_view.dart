import 'package:flutter/material.dart';
//import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../widgets/app_snack_bars.dart'; // 1. Import Riverpod

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
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  // 1. ADD a state variable to track the loading process
  bool _isAuthenticating = false;
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

  // void _submit() {
  //   // It's still best practice to validate one final time on submit.
  //   if (_formKey.currentState!.validate()) {
  //     widget.onAuthenticated();
  //   }
  // }
  void _submit() {
    // It's still best practice to validate one final time on submit.
    if (_formKey.currentState?.validate() ?? false) {
      // Prevent double taps
      if (_isAuthenticating) return;

      FocusScope.of(context).unfocus();

      // Set the state to disable the button immediately
      setState(() {
        _isAuthenticating = true;
      });

      // NOTE: `dealerLogin` is the self-contained function from the previous step.
      // Assuming you have access to it via an instance `authService`.
      dealerLogin(
        context: context,
        dealerCode: widget.dealer.accountCode, // Pass the dealer info
        pin: _pinController.text,
        onSuccess: () async {
          // <-- Make the callback async
          // The loading spinner is now gone.

          // 3. ADD the delay here.
          // The user will see the screen for a moment without the spinner.
          await Future.delayed(
            const Duration(milliseconds: 200),
          ); // 0.5 second delay

          // IMPORTANT: Check if the widget is still mounted after the delay
          // before calling the navigation callback.
          if (mounted) {
            widget.onAuthenticated();
          }
        },
        onError: (e) {
          // Check if the widget is still mounted before showing a SnackBar.
          if (mounted) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          showSnackBar(
            context: context,
            message: errorMessage,
            type: MessageType.error,
          );
            // CRITICAL: Re-enable the button if an error occurs so the user can try again.
            setState(() {
              _isAuthenticating = false;
            });
          }
        },
      );
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
                  !isFormValid ||
                  _isAuthenticating, // 8. Use the state variable to control the button
            ),
          ],
        ),
      ),
    );
  }
}



// // 2. Change from StatefulWidget to ConsumerStatefulWidget
// class AuthenticateDealerView extends ConsumerStatefulWidget {
//   final Dealer dealer;
//   final VoidCallback onAuthenticated;

//   const AuthenticateDealerView({
//     super.key,
//     required this.dealer,
//     required this.onAuthenticated,
//   });

//   @override
//   // 3. Update the createState method
//   ConsumerState<AuthenticateDealerView> createState() =>
//       _AuthenticateDealerViewState();
// }

// // 4. Change from State to ConsumerState
// class _AuthenticateDealerViewState
//     extends ConsumerState<AuthenticateDealerView> {
//   final _formKey = GlobalKey<FormState>();
//   final _pinController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Rebuild the widget when text changes to update the button state.
//     _pinController.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _pinController.dispose();
//     super.dispose();
//   }

//   // 5. Make the submit function async to await the login result
//   Future<void> _submit() async {
//     // Hide the keyboard
//     FocusScope.of(context).unfocus();

//     if (_formKey.currentState!.validate()) {
//       // Read the AuthService from the provider
//       final authService = ref.read(authServiceProvider);

//       // Call the dealerLogin method and wait for the result
//       final isAuthenticated = await authService.dealerLogin(
//         context: context,
//         dealerCode: widget.dealer.accountCode, // Assuming your dealer model has a dealerCode
//         pin: _pinController.text,
//       );

//       // After awaiting, check if the widget is still mounted before proceeding
//       if (mounted && isAuthenticated) {
//         // If login was successful, call the callback
//         widget.onAuthenticated();
//       } else if (mounted) {
//         // Optionally, show an error if login fails
//                 showSnackBar(
//                   context: context,
//                   message: 'Test Error message',
//                   type: MessageType.error
//         );
//       }
//     }
//   }

//    @override
//   Widget build(BuildContext context) {
//     final bool isFormValid = _formKey.currentState?.validate() ?? false;
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text(
//             //   'Authenticating: ${widget.dealer.name}', // Use 'widget.' to access properties
//             //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             // ),
//             // const SizedBox(height: 20),
//             AutoSizeText(
//               'Authenticating: ${widget.dealer.name}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               maxLines: 1,
//             ),
//             const SizedBox(height: 20),

//             AppTextField(
//               controller: _pinController,
//               labelText: 'PIN',
//               keyboardType: TextInputType.number,
//               isPin: true,
//               onFieldSubmitted: (_) => _submit(),
//             ),

//             const Spacer(),
//             ActionButton(
//               label: 'Agree',
//               onPressed: _submit, // Use 'widget.' to access properties
//               disabled:
//                   !isFormValid, // 8. Use the state variable to control the button
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }