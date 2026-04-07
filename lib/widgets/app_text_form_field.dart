import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/helpers/currency_input_formatter.dart';
import 'package:myapp/theme/app_theme_helper.dart';
//import 'package:myapp/theme/app_colors.dart';

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
  final bool isDigitOnly; // A flag for numbers with no . and ,
  final bool hideBorder; // Toggles the visibility of the field's border. //final EdgeInsetsGeometry?contentPadding; // Custom padding inside the text field.
  final String? Function(String?)? validator; // Custom validation logic.
  final void Function(String)?
  onFieldSubmitted; // Callback when the user submits the field.
  final void Function(String)? onChanged; // Callback on every character change.
  final TextInputAction?
  textInputAction; // The action button on the keyboard (e.g., next, done).
  final FocusNode? focusNode; // Manages the focus state of the field.
  final int? maxLength; // Maxlenth for the text field
  final int? errorMaxLines; // Maxlenth for 

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
    this.isDigitOnly = false,
    this.hideBorder = false,
    //this.contentPadding,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.textInputAction,
    this.focusNode,
    this.maxLength,
    this.errorMaxLines
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
     // final isFinanceNum_ = RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value);
      final isFinanceNum_ = RegExp(r'^\d{1,3}(,\d{3})*(\.\d{1,2})?$').hasMatch(value);
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
        isPin || isFinanceNum || isDigitOnly
            ? TextInputType.number
            : keyboardType;

    InputDecoration baseDecoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
    );

    // Apply specific border overrides if hideBorder is true
    if (hideBorder) {
      OutlineInputBorder baseOut = AppThemeHelpers.getAppRoundedBorder(
        type: AppBorderType.none,
      );
      baseDecoration = baseDecoration.copyWith(
        border: baseOut,
        enabledBorder: baseOut,
        focusedBorder: baseOut,
        errorBorder: baseOut,
        focusedErrorBorder: baseOut,
        disabledBorder: baseOut,
      );
    }
    // InputDecoration effectiveDecoration = baseDecoration.applyDefaults(
    //   Theme.of(context).inputDecorationTheme,
    // );

    InputDecoration effectiveDecoration = baseDecoration
    .copyWith(
      errorMaxLines: errorMaxLines,
      counterText: ''
    )
    .applyDefaults(Theme.of(context).inputDecorationTheme);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: effectiveKeyboardType,
      obscureText: shouldObscure,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.done,
      decoration: effectiveDecoration,
      validator: _internalValidator,
      maxLength: maxLength ?? (isFinanceNum ? 18 : null),
      inputFormatters: isDigitOnly ? [FilteringTextInputFormatter.digitsOnly]     
                      : isFinanceNum ? [CurrencyInputFormatter()] : null,
    );
  }
}
