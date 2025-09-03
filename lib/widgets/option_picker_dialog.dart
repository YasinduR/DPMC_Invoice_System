import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';



class SelectionModal extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? initialValue;

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

                    // 2. This reduces the default horizontal padding.
                    //    EdgeInsets.zero removes all padding. You could use
                    //    EdgeInsets.symmetric(horizontal: 8.0) for a little bit.
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
