// Added by Darshan R on 19/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/helpers/password_strength.dart';
//import 'package:myapp/services/password_strength_service.dart'; // Migrated By Yasindu Ganegoda
import 'package:myapp/theme/app_colors.dart';

/// A password input field widget with visibility toggle eye icon
///
/// This widget provides a TextFormField with an eye icon that toggles
/// password visibility between hidden and visible states.
class PasswordInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final bool enforceStrength; // NEW: enforce strong passwords

  const PasswordInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.contentPadding,
    this.enforceStrength = false, // DEFAULT: false (optional)
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late bool _obscureText = true;

  // String? _validatePassword(String? value) {
  //   if (widget.validator != null) {
  //     final customError = widget.validator!(value);
  //     if (customError != null) return customError;
  //   }

  //   if (widget.enforceStrength && value != null && value.isNotEmpty) {
  //     if (!PasswordStrength.isSuffient(value)) {
  //       return 'Password requires: 8+ characters, uppercase, lowercase, number, and special character';
  //     }
  //   }

  //   return null;
  // }

  // Modified By Yasindu Ganegoda 03/20/2026
  String? _validatePassword(String? value) {
    if (widget.validator != null) {
      final customError = widget.validator!(value);
      if (customError != null) return customError;
    }

    if (widget.enforceStrength && value != null && value.isNotEmpty) {
      final strengthError = PasswordStrength.getValidationMessage(value);
      if (strengthError != null) {
        return strengthError;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: PasswordStrength.maxLimit,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        errorMaxLines: 2,
        counterText: "",
        labelText: widget.labelText,
        hintText: widget.hintText,
        contentPadding: widget.contentPadding,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.neutralMedium,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
      ),
      validator: _validatePassword,
    );
  }
}
