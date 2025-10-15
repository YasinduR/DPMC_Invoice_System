import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Used TO SHOW Non editable textfield used in time fieds in attendence.
class FixedTextField extends StatelessWidget {
  final String?
  headerLabelText; // Optional label text displayed above the field.
  final String?
  inputFieldLabelText; // Optional label text for the InputDecorator.
  final String?
  selectedOption; // The current Option picked if non shows inputFieldLabelText in shaded.
  final bool isDisabled;

  const FixedTextField({
    super.key,
    this.headerLabelText,
    this.inputFieldLabelText,
    required this.selectedOption,
    this.isDisabled=false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (headerLabelText != null && headerLabelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ), // Spacing between header label and input
            child: Center(
              child: Text(
                headerLabelText!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:AppColors.primary, 
                ),
              ),
            ),
          ),
        InkWell(
          onTap: null,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            isEmpty: selectedOption == null,
            decoration: InputDecoration(labelText: inputFieldLabelText),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      selectedOption == null ? '' : selectedOption!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                      maxLines: 1, 
                      minFontSize: 8, 
                      overflow:TextOverflow.ellipsis, 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
