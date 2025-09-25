import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

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
                    title: Text(
                      option,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
            ElevatedButton.icon(
              onPressed:
                  _selectedValue == null
                      ? null // Disable button if nothing is selected
                      : () => Navigator.of(context).pop(_selectedValue),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Submit'),
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

  const PickerFormField({
    super.key,
    this.headerLabelText,
    this.inputFieldLabelText,
    required this.selectedOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.borderDark;

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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:  AppColors.primary, // Using primary color for header label
                ),
              ),
            ),
          ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            isEmpty: selectedOption == null,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              labelText: inputFieldLabelText, // Use the optional input field label
              labelStyle: const TextStyle(color: AppColors.borderDark),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedOption == null ? '' : selectedOption!,
                    style: const TextStyle(fontSize: 16, color: AppColors.text),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
