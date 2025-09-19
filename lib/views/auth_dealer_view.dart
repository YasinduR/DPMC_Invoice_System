import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_text_form_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../widgets/app_snack_bars.dart'; 

// This view is to Authenticate selected dealer
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
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }


  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isAuthenticating) return;
      FocusScope.of(context).unfocus();
      setState(() {
        _isAuthenticating = true;
      });
      dealerLogin(
        context: context,
        dealerCode: widget.dealer.accountCode,
        pin: _pinController.text,
        onSuccess: () async {
          await Future.delayed(
            const Duration(milliseconds: 200),
          ); 
          if (mounted) {
            widget.onAuthenticated();
          }
        },
        onError: (e) {
          if (mounted) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          showSnackBar(
            context: context,
            message: errorMessage,
            type: MessageType.error,
          );
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
              onPressed: _submit,
              disabled:
                  !isFormValid ||
                  _isAuthenticating,
            ),
          ],
        ),
      ),
    );
  }
}