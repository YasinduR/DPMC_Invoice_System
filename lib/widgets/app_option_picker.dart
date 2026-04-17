import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';

// Options Picker field and releated show model  ( note: used in reasons for returns and attendance)

class SelectionModal extends StatefulWidget {
  final String title; // Text displayed at the top of the modal.
  final List<String> options; // List of choices for the user.
  final String? initialValue; // The option to pre-select.

  const SelectionModal({
    super.key,
    required this.title,
    required this.options,
    this.initialValue,
  });

  @override
  State<SelectionModal> createState() => _SelectionModalState();
}

class _SelectionModalState extends State<SelectionModal> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return RadioListTile<String>(
                    title: AutoSizeText(
                      // <--- AutoSizeText
                      option,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1, // Restrict to one line
                      minFontSize: 8, // Minimum font size before overflow
                      overflow:
                          TextOverflow
                              .ellipsis, // Show ellipsis if it still overflows
                    ),
                    value: option,
                    groupValue: _selectedValue,
                    onChanged:
                        (value) => setState(() => _selectedValue = value),
                    activeColor: AppColors.primary,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Submit',
              icon: Icons.check_circle_outline,
              onPressed: () {
                Navigator.of(context).pop(_selectedValue);
              },
              disabled: _selectedValue == null,
            ),
          ],
        ),
      ),
    );
  }
}

class PickerFormField extends StatelessWidget {
  final String?
  headerLabelText; // Optional label text displayed above the field.
  final String?
  inputFieldLabelText; // Optional label text for the InputDecorator.
  final String?
  selectedOption; // The current Option picked if non shows inputFieldLabelText in shaded.
  final VoidCallback onTap; // The function to call when the field is tapped.
  final bool isDisabled;

  const PickerFormField({
    super.key,
    this.headerLabelText,
    this.inputFieldLabelText,
    required this.selectedOption,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    //final borderColor = AppColors.borderIntense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Optional header label above the field
        if (headerLabelText != null && headerLabelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ), // Spacing between header label and input
            child: Center(
              child: Text(
                headerLabelText!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:
                      AppColors.primary, // Using primary color for header label
                ),
              ),
            ),
          ),
        InkWell(
          onTap: isDisabled ? null : onTap,
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
                      style: TextStyle(fontSize: 16, color: AppColors.text),
                      maxLines: 1, // Ensure it stays on one line
                      minFontSize: 8, // Minimum font size before truncation
                      overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.onSurface),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
