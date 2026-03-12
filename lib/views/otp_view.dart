import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widgets/app_action_button.dart';

// last step of Forget Password : New Password Setup
class OtpView extends StatefulWidget {
  final Future<void> Function(String token) onSubmit;
  final String? contactPhone;
  final String? contactEmail;
  final String? devOtp; // DEV ONLY

  const OtpView({
    Key? key,
    required this.onSubmit,
    this.contactPhone,
    this.contactEmail,
    this.devOtp, // DEV ONLY
  }) : super(key: key);

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final _formKey = GlobalKey<FormState>();
  
  // OTP digit controllers & focus nodes
  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _otpFocusNodes = [];
  final GlobalKey<FormFieldState<String>> _otpFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();

    // Create 6 controllers & focus nodes for OTP digits
    for (int i = 0; i < 6; i++) {
    final c = TextEditingController();
    c.addListener(() => setState(() {}));
    _otpControllers.add(c);

    final index = i;
    final node = FocusNode();
    node.onKeyEvent = (FocusNode n, KeyEvent event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          _otpControllers[index].text.isEmpty &&
          index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
        _otpControllers[index - 1].clear();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    _otpFocusNodes.add(node);
  }

    // focus first cell
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final token = _otpControllers.map((c) => c.text).join();
      try {
        await widget.onSubmit(token);
      } finally {
        for (final c in _otpControllers) {
          c.clear();
        }
        _otpFieldKey.currentState?.didChange('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool allFilled = _otpControllers.every((c) => c.text.isNotEmpty);
    final bool isButtonDisabled = !allFilled || !isFormValid;

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(width: 12),
                // Text(
                //   'Verify Details',
                //   style:  Theme.of(context).textTheme.headlineLarge,
                // ),
                // Divider(color: Colors.grey[800], thickness: 1),
                // const SizedBox(height: 40),
                Text(
                  'We have sent a 6-digit OTP code to',
                      style:  Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.contactPhone != null && widget.contactPhone!.isNotEmpty
                      ? widget.contactPhone!
                      : '+94 77 1234567',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  widget.contactEmail != null && widget.contactEmail!.isNotEmpty
                      ? widget.contactEmail!
                      : 'newuser@gmail.com',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                // OTP 6-digit input cells
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          height: 75,
                          child: TextFormField(
                          controller: _otpControllers[i],
                          focusNode: _otpFocusNodes[i],
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,  // ← add this
                          style: const TextStyle(fontSize: 20),      
                          keyboardType: TextInputType.number,
                          // obscureText: false,
                          inputFormatters: [_OtpCellFormatter()],
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) {
                            if (v.length == 1) {
                              if (i + 1 < _otpFocusNodes.length) {
                                _otpFocusNodes[i + 1].requestFocus();
                              } else {
                                _otpFieldKey.currentState?.didChange(
                                    _otpControllers.map((c) => c.text).join());
                                _otpFocusNodes[i].unfocus();
                              }
                            } else if (v.isEmpty) {
                              if (i - 1 >= 0) {
                                _otpFocusNodes[i - 1].requestFocus();
                              }
                              _otpFieldKey.currentState?.didChange(
                                  _otpControllers.map((c) => c.text).join());
                            }
                          },
                        ),
                      ),
                      ),
                    );
                  }),
                ),
                FormField<String>(
                  key: _otpFieldKey,
                  initialValue: _otpControllers.map((c) => c.text).join(),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'The OTP Code is required';
                    }
                    return null;
                  },
                  builder: (state) {
                    if (state.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText ?? '',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        // DEV ONLY banner — remove when real OTP delivery is implemented
        if (widget.devOtp != null && widget.devOtp!.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              border: Border.all(color: Colors.amber.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.bug_report, color: Colors.amber.shade800, size: 18),
                const SizedBox(width: 8),
                Text(
                  '[DEV] OTP: ${widget.devOtp}',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            icon: Icons.arrow_forward,
            label: 'Proceed',
            disabled: isButtonDisabled,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }
}

class _OtpCellFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    if (digits.length == 1) {
      return TextEditingValue(
        text: digits,
        selection: const TextSelection.collapsed(offset: 1),
      );
    }
    // Two digits: use cursor position to find the newly typed one.
    // After insertion, cursor sits right after the new character.
    final cursorPos = newValue.selection.baseOffset;
    if (cursorPos >= 1 && cursorPos <= newValue.text.length) {
      final typed = newValue.text[cursorPos - 1];
      if (RegExp(r'[0-9]').hasMatch(typed)) {
        return TextEditingValue(
          text: typed,
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
    }
    // Fallback
    return TextEditingValue(
      text: digits[digits.length - 1],
      selection: const TextSelection.collapsed(offset: 1),
    );
  }
}