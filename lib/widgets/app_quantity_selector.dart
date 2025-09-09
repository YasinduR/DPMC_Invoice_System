import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

// Common Quantity Selector for the app

class QuantitySelector extends StatelessWidget {

  final int value;                  // The current quantity to display.
  final ValueChanged<int>? onChanged; // Callback when the quantity is updated.
  final bool enabled;               // Toggles if the selector is interactive.
  final String dialogTitle;         // The title for the pop-up edit dialog.
  final int? maxQuantity;           // Optional maximum value allowed in the dialog.


  const QuantitySelector({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.dialogTitle = 'Update Quantity', // Default title
    this.maxQuantity, 
  });


  // This internal method handles the logic of showing the dialog.
  Future<void> _showEditDialog(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    final newValue = await showDialog<int>(
      context: context,
      builder:
          (context) =>
              QuantityEditDialog(initialQuantity: value, title: dialogTitle,maxQuantity: maxQuantity),
    );
    if (newValue != null) {
      onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuantityStepperDisplay(
      quantity: value,
      enabled: enabled,
      onTap: () => _showEditDialog(context),
    );
  }
}

class QuantityStepperDisplay extends StatelessWidget {
  final int quantity;
  final bool enabled;
  final VoidCallback? onTap;

  const QuantityStepperDisplay({
    super.key,
    required this.quantity,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = enabled ? onTap : null;
    final color = enabled ? AppColors.text : AppColors.border;

    return InkWell(
      onTap: effectiveOnTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.remove, color: color, size: 16),
            Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Icon(Icons.add, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

class QuantityEditDialog extends StatefulWidget {
  final int initialQuantity;
  final String title;
  final int? maxQuantity; // <-- ADD THIS: Optional maximum value

  const QuantityEditDialog({
    super.key,
    required this.initialQuantity,
    required this.title,
    this.maxQuantity
  });

  @override
  State<QuantityEditDialog> createState() => _QuantityEditDialogState();
}

class _QuantityEditDialogState extends State<QuantityEditDialog> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
  //  _currentQuantity = widget.initialQuantity;

    if (widget.initialQuantity < 1) {
      _currentQuantity = 1;
    } else {
      _currentQuantity = widget.initialQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
        // Determine if the increment/decrement buttons should be disabled
    final canDecrement = _currentQuantity > 1;
    final canIncrement = widget.maxQuantity == null || _currentQuantity < widget.maxQuantity!;
    
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: canDecrement ? AppColors.danger : AppColors.disabled,
              size: 30,
            ),
            onPressed: canDecrement
                ? () => setState(() => _currentQuantity--)
                : null,
            // onPressed: () {
            //   if (_currentQuantity > 0) {
            //     setState(() => _currentQuantity--);
            //   }
            // },
          ),
          Text(
            _currentQuantity.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: canIncrement ? AppColors.primary : Colors.grey,
              size: 30,
            ),
              onPressed: canIncrement
                ? () => setState(() => _currentQuantity++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Pop without a value
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
        ElevatedButton(
          onPressed:
              () => Navigator.of(
                context,
              ).pop(_currentQuantity), // Pop with the new value
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Ok', style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
