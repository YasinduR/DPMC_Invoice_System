import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart'; // Make sure the path is correct


/// A helper widget to create the styled, full-width dialog buttons.
// Widget buildDialogButton({
//   required String text,
//   required VoidCallback onPressed,
//   required Color backgroundColor,
//   Color textColor = AppColors.white,
//   bool disabled = false, // Added disabled parameter
// }) {
//   return SizedBox(
//     width: double.infinity, // Make button take full width
//     child: ElevatedButton(
//       onPressed: disabled ? null : onPressed, // Disable if 'disabled' is true
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: textColor,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50), // Fully rounded corners
//         ),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     ),
//   );
//}

/// A generic dialog function. All other dialogs are based on this.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  Widget? content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false, // User must interact to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // Center the title text
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // The main message content
        content: content,
        // The buttons at the bottom, wrapped in a Column
        actions:
            actions != null && actions.isNotEmpty
                ? [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        actions.map((action) {
                          // Add spacing between buttons
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: action,
                          );
                        }).toList(),
                  ),
                ]
                : null,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      );
    },
  );
}

/// Shows a styled confirmation dialog.
///
/// Returns `true` if the user confirms, `false` otherwise.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? content,
  String confirmButtonText = 'Yes', // New default
  String cancelButtonText = 'No', // New default
}) async {
  final result = await showAppDialog<bool>(
    context: context,
    title: title,
    content:
        content != null ? Text(content, textAlign: TextAlign.center) : null,
    actions: [
      ActionButton(
        label: confirmButtonText, 
        onPressed: () {
          Navigator.of(context).pop(true); // Return true
        },
        type: ActionButtonType.secondary,
        ),

        ActionButton(
        label: cancelButtonText, 
        onPressed: () {
          Navigator.of(context).pop(false); // Return true
        },
        ),

      // // The "Confirm" button (e.g., "Yes, Log out")
      // buildDialogButton(
      //   text: confirmButtonText,
      //   backgroundColor: AppColors.danger,
      //   onPressed: () {
      //     Navigator.of(context).pop(true); // Return true
      //   },
      // ),
      // // The "Cancel" button (e.g., "No, I'm Staying")
      // buildDialogButton(
      //   text: cancelButtonText,
      //   backgroundColor: AppColors.primary,
      //   onPressed: () {
      //     Navigator.of(context).pop(false); // Return false
      //   },
      // ),
    ],
  );
  // Return false if dialog is dismissed by other means (e.g., back button)
  return result ?? false;
}

/// Shows a simple informational (success or error) dialog with a single action button.
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'Ok', //default
  bool isError = false,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: Text(content, textAlign: TextAlign.center),
    actions: [
      // buildDialogButton(
      //   text: buttonText,
      //   backgroundColor: isError ? AppColors.danger : AppColors.primary,
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      ActionButton(
        label: buttonText, 
        onPressed: () {
          Navigator.of(context).pop(false); // Return true
        },
        type: isError ? ActionButtonType.secondary :ActionButtonType.primary,
        )


    ],
  );
}

class _PinVerificationDialogContent extends StatefulWidget {
  final String title;
  final String verifyButtonText;
  final String cancelButtonText;
  final int pinLength;

  const _PinVerificationDialogContent({
    Key? key,
    required this.title,
    required this.verifyButtonText,
    required this.cancelButtonText,
    required this.pinLength,
  }) : super(key: key);

  @override
  _PinVerificationDialogContentState createState() => _PinVerificationDialogContentState();
}
class _PinVerificationDialogContentState extends State<_PinVerificationDialogContent> {
  final TextEditingController _pinController = TextEditingController();
  String _currentPin = '';

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    setState(() {
      _currentPin = _pinController.text;
    });
  }

  void _handleVerifyAction() {
    if (_currentPin.isNotEmpty && _currentPin.length >= widget.pinLength) {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop(_pinController.text);
    }
  }

  void _handleCancelAction() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop(null);
  }

  @override
  void dispose() {
    _pinController.removeListener(_onPinChanged);
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isVerifyButtonDisabled = _currentPin.isEmpty || _currentPin.length < widget.pinLength;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: TextField(
        controller: _pinController,
        obscureText: true, 
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number, 
        textInputAction: TextInputAction.done, 
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, 
          LengthLimitingTextInputFormatter(widget.pinLength),
        ],
        decoration: InputDecoration(
          hintText: 'Enter PIN',
          hintStyle: TextStyle(color: AppColors.borderDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
        autofocus: true, 
        onSubmitted: (value) {
          if (!isVerifyButtonDisabled) {
            _handleVerifyAction();
          }
        },
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ActionButton(label: widget.verifyButtonText, onPressed: _handleVerifyAction,disabled: isVerifyButtonDisabled)
              // child: buildDialogButton(
              //   text: widget.verifyButtonText,
              //   backgroundColor: AppColors.primary,
              //   onPressed: _handleVerifyAction,
              //   disabled: isVerifyButtonDisabled,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ActionButton(label: widget.cancelButtonText, onPressed: _handleCancelAction)

              // child: buildDialogButton(
              //   text: widget.cancelButtonText,
              //   backgroundColor: AppColors.borderDark,
              //   onPressed: _handleCancelAction,
              // ),
            ),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    );
  }
}

Future<String?> showPinVerificationDialog({ // Dialog box to return string
  required BuildContext context, 
  required String title, // Title of the Dialog Box
  String verifyButtonText = 'Verify', // Submit button title
  String cancelButtonText = 'Cancel', // Cancle button title
  int pinLength = 3, // Fixed PIN length 
}) async {
  return await showDialog<String?>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext dialogContext) {
      return _PinVerificationDialogContent(
        title: title,
        verifyButtonText: verifyButtonText,
        cancelButtonText: cancelButtonText,
        pinLength: pinLength,
      );
    },
  );
}