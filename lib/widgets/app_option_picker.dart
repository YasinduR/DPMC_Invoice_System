import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

// Options Picker field and releated show model  ( ie: used in reasons for returns)

class SelectionModal extends StatefulWidget {
  final String title;           // Text displayed at the top of the modal.
  final List<String> options;   // List of choices for the user.
  final String? initialValue;   // The option to pre-select.

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
  final String labelText;       // The label displayed above the field.
  final String displayValue;    // The current value shown in the field.
  final VoidCallback onTap;     // The function to call when the field is tapped.

  const PickerFormField({
    super.key,
    required this.labelText,
    required this.displayValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. The centered, styled label.
        Center(
          child: Text(
            labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayValue,
                  style: TextStyle(fontSize: 14, color: AppColors.borderDark),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
