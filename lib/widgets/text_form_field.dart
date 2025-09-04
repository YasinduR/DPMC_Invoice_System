import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPin;
  final bool isFinanceNum; // for money
  final bool hideBorder;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted; // 1. ADD THIS LINE

    // --- ADDITIONS ---
  final void Function(String)? onChanged; // 1. ADD this for real-time validation
  final TextInputAction? textInputAction;   // 2. ADD this for better keyboard UX

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText, // NEW
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPin = false,
    this.isFinanceNum = false, // For money
    this.hideBorder =
        false, // NEW: Default to false to not break existing fields
    this.contentPadding, // NEW
    this.validator,
    this.onFieldSubmitted,
        this.onChanged, // 3. ADD to constructor
    this.textInputAction, // 4. ADD to constructor
  });

  String? _internalValidator(String? value) {
    if (isPin) {
      if (value == null || value.isEmpty) return 'PIN cannot be empty';
      final isDigitsOnly = RegExp(r'^[0-9]+$').hasMatch(value);
      if (!isDigitsOnly) return 'PIN must contain only numbers';
    }

    if (isFinanceNum) {
      if (value == null || value.isEmpty) {
        return null; // For now no error upon empty values
      }
      final isFinanceNum = RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value);
      if (!isFinanceNum) {
        return 'Please enter a valid value in Rupees';
      }
    }

    if (validator != null) return validator!(value);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldObscure = obscureText || isPin;
    final TextInputType effectiveKeyboardType =
        isPin ? TextInputType.number : keyboardType;

    return TextFormField(
      controller: controller,
      keyboardType: effectiveKeyboardType,
      obscureText: shouldObscure,
      onFieldSubmitted: onFieldSubmitted, // 3. PASS THE CALLBACK HERE
      //textInputAction: TextInputAction.done, // 4. SET THE KEYBOARD ACTION
      onChanged: onChanged, // 5. PASS the onChanged callback here
      textInputAction: textInputAction ?? TextInputAction.done, // Use provided action or default to 'done'
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
