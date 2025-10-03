import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Common Text field
class AppTextField extends StatelessWidget {
  final TextEditingController? controller; // Manages the text field's content.
  final String? labelText; // The label that floats above the field.
  final String? hintText; // Placeholder text inside the field.
  final TextInputType
  keyboardType; // Type of keyboard to show (e.g., text, number).
  final bool obscureText; // Hides text, typically for passwords.
  final bool isPin; // A flag for PIN-specific behavior (numeric, obscure).
  final bool isPassword; // Flag for Password
  final bool isEmail; // Flag for Email
  final bool isFinanceNum; // A flag for financial number validation.
  final bool hideBorder; // Toggles the visibility of the field's border.
  final EdgeInsetsGeometry?
  contentPadding; // Custom padding inside the text field.
  final String? Function(String?)? validator; // Custom validation logic.
  final void Function(String)?
  onFieldSubmitted; // Callback when the user submits the field.
  final void Function(String)? onChanged; // Callback on every character change.
  final TextInputAction?
  textInputAction; // The action button on the keyboard (e.g., next, done).
  final FocusNode? focusNode;
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText, // NEW
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPin = false,
    this.isPassword = false,
    this.isFinanceNum = false,
    this.isEmail = false,
    this.hideBorder = false,
    this.contentPadding,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.textInputAction,
    this.focusNode
  });

  String? _internalValidator(String? value) {
    if (validator != null)
      return validator!(value); // Use the provided validator as priority

    if (isEmail) {
      if (value?.isEmpty ?? true) return null;
      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
        return 'Please enter a valid email address';
      }
    }
    if (isPin) {
      if (value == null || value.isEmpty) return 'PIN cannot be empty';
      final isDigitsOnly = RegExp(r'^[0-9]+$').hasMatch(value);
      if (!isDigitsOnly) return 'PIN must contain only numbers';
    }

    if (isPassword) {
      if (value == null || value.isEmpty) {
        return null; // For now no error upon empty values
      } else if (value.length < 4)
        return 'Password must be at least 4 characters';
    }

    if (isFinanceNum) {
      if (value == null || value.isEmpty) {
        return null; // For now no error upon empty values
      }
      final isFinanceNum_ = RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value);
      if (!isFinanceNum_) {
        return 'Please enter a valid value in Rupees';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldObscure = obscureText || isPin || isPassword;
    final TextInputType effectiveKeyboardType =
        isPin ? TextInputType.number : keyboardType;

    return TextFormField(
      controller: controller,
      focusNode: focusNode, // Pass the optional focusNode here
      keyboardType: effectiveKeyboardType,
      obscureText: shouldObscure,
      onFieldSubmitted: onFieldSubmitted, // 3. PASS THE CALLBACK HERE
      //textInputAction: TextInputAction.done, // 4. SET THE KEYBOARD ACTION
      onChanged: onChanged, // 5. PASS the onChanged callback here
      textInputAction:
          textInputAction ??
          TextInputAction.done, // Use provided action or default to 'done'
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.borderDark),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: contentPadding,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              hideBorder
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              hideBorder
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              hideBorder
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.danger, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              hideBorder
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.danger, width: 2.0),
        ),

        // --- End of Conditional Border Logic ---
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(MaterialState.error)) {
            return const TextStyle(color: AppColors.danger);
          }
          // Use primary color when the field is focused.
          if (states.contains(MaterialState.focused)) {
            return const TextStyle(color: AppColors.primary);
          }
          // Use border color when unfocused (but has content, so it's floating).
          return const TextStyle(color: AppColors.borderDark);
        }),
        errorStyle: const TextStyle(color: AppColors.danger),
      ),
      validator: _internalValidator,
    );
  }
}
