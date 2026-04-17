import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';

// Common Quantity Selector for the app
class QuantitySelector extends StatelessWidget {
  final int value; // The current quantity to display.
  final ValueChanged<int>? onChanged; // Callback when the quantity is updated.
  final bool enabled; // Toggles if the selector is interactive.
  final String dialogTitle; // The title for the pop-up edit dialog.
  final int? maxQuantity; // Optional maximum value allowed in the dialog.
  final int minQuantity; // NEW: Optional minimum value allowed in the dialog.
  final bool
  useDialog; // NEW: If false, increment/decrement buttons works directly - Added and related codes by Darshan R on 07/04/2026

  const QuantitySelector({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.dialogTitle = 'Update Quantity', // Default title
    this.maxQuantity,
    this.minQuantity = 1, // NEW: Default minQuantity to 1
    this.useDialog = true, // NEW: Default useDialog to true
  });

  // This internal method handles the logic of showing the dialog.
  Future<void> _showEditDialog(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    final newValue = await showDialog<int>(
      context: context,
      builder:
          (context) => QuantityEditDialog(
            initialQuantity: value,
            title: dialogTitle,
            maxQuantity: maxQuantity,
            minQuantity: minQuantity, // NEW: Pass minQuantity to the dialog
          ),
    );
    if (newValue != null) {
      onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDecrement = enabled && value > minQuantity;
    final canIncrement =
        enabled && (maxQuantity == null || value < maxQuantity!);

    final VoidCallback? dialogTrigger =
        useDialog ? () => _showEditDialog(context) : null;

    return QuantityStepperDisplay(
      quantity: value,
      enabled: enabled,
      onTap: dialogTrigger,
      onDecrement:
          !useDialog && canDecrement
              ? () => onChanged?.call(value - 1)
              : (useDialog && enabled ? dialogTrigger : null),
      onIncrement:
          !useDialog && canIncrement
              ? () => onChanged?.call(value + 1)
              : (useDialog && enabled ? dialogTrigger : null),
      decrementColor:
          !useDialog
              ? (canDecrement ? AppColors.danger : AppColors.disabled)
              : (enabled ? AppColors.text : AppColors.disabled),
      incrementColor:
          !useDialog
              ? (canIncrement ? AppColors.primary : AppColors.disabled)
              : (enabled ? AppColors.text : AppColors.disabled),
      useDialog: useDialog,
    );
  }
}

class QuantityStepperDisplay extends StatelessWidget {
  final int quantity;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final Color? decrementColor;
  final Color? incrementColor;
  final bool useDialog;

  const QuantityStepperDisplay({
    super.key,
    required this.quantity,
    this.enabled = true,
    this.onTap,
    this.onDecrement,
    this.onIncrement,
    this.decrementColor,
    this.incrementColor,
    this.useDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = enabled ? onTap : null;
    final borderColor = enabled ? AppColors.border : AppColors.disabled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleButton(
            icon: useDialog ? Icons.remove : Icons.remove_circle,
            color: decrementColor ?? AppColors.text,
            onPressed: onDecrement,
          ),
          InkWell(
            onTap: effectiveOnTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
          _buildCircleButton(
            icon: useDialog ? Icons.add : Icons.add_circle,
            color: incrementColor ?? AppColors.text,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          color: onPressed != null ? color : color.withOpacity(0.3),
          size: 18,
        ),
      ),
    );
  }
}

class QuantityEditDialog extends StatefulWidget {
  final int initialQuantity;
  final String title;
  final int? maxQuantity;
  final int minQuantity;

  const QuantityEditDialog({
    super.key,
    required this.initialQuantity,
    required this.title,
    this.maxQuantity,
    this.minQuantity = 1,
  });

  @override
  State<QuantityEditDialog> createState() => _QuantityEditDialogState();
}

class _QuantityEditDialogState extends State<QuantityEditDialog> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    // Ensure initial quantity is within bounds [minQuantity, maxQuantity]
    _currentQuantity = widget.initialQuantity;
    if (_currentQuantity < widget.minQuantity) {
      _currentQuantity = widget.minQuantity;
    }
    // Also consider maxQuantity if initial is greater
    if (widget.maxQuantity != null && _currentQuantity > widget.maxQuantity!) {
      _currentQuantity = widget.maxQuantity!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the increment/decrement buttons should be disabled
    final canDecrement =
        _currentQuantity > widget.minQuantity; // NEW: Use widget.minQuantity
    final canIncrement =
        widget.maxQuantity == null || _currentQuantity < widget.maxQuantity!;

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
            onPressed:
                canDecrement ? () => setState(() => _currentQuantity--) : null,
          ),
          Text(
            _currentQuantity.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color:
                  canIncrement
                      ? AppColors.primary
                      : AppColors.disabled, // Assuming AppColors is defined
              size: 30,
            ),
            onPressed:
                canIncrement ? () => setState(() => _currentQuantity++) : null,
          ),
        ],
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ActionButton(
                //minsize: true,
                isInDialog: true,
                label: 'Ok',
                onPressed: () => Navigator.of(context).pop(_currentQuantity),
              ), // Assuming ActionButton is defined,
              // child: buildDialogButton(
              //   text: widget.verifyButtonText,
              //   backgroundColor: AppColors.primary,
              //   onPressed: _handleVerifyAction,
              //   disabled: isVerifyButtonDisabled,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ActionButton(
                //minsize: true,
                isInDialog: true,
                label: 'Cancel',
                type: ActionButtonType.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),

              // child: buildDialogButton(
              //   text: widget.cancelButtonText,
              //   backgroundColor: AppColors.borderIntense,
              //   onPressed: _handleCancelAction,
              // ),
            ),
          ],

          // ActionButton(
          //     //minsize: true,
          //     isInDialog: true,
          //     label: 'Ok',
          //     onPressed: () => Navigator.of(context).pop(_currentQuantity)), // Assuming ActionButton is defined

          // ActionButton(
          //   //minsize: true,
          //   isInDialog: true,
          //   label: 'Cancel',
          //   type: ActionButtonType.secondary,
          //   onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
