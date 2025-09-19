import 'package:flutter/material.dart';
import 'package:myapp/models/reference_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_radio_group.dart';

// Select Reference View from the Screen
class SelectReferenceView extends StatefulWidget {
  final Function(Reference) onRefSelected;
  final Function(String) onReturnTypeSelect;
  final VoidCallback onSubmit;
  final Reference? selectedReference;
  final String? selectedReturnType;

  const SelectReferenceView({
    super.key,
    required this.onRefSelected,
    required this.onReturnTypeSelect,
    required this.onSubmit,
    this.selectedReference,
    this.selectedReturnType,
  });

  @override
  State<SelectReferenceView> createState() => _SelectReferenceViewState();
}

class _SelectReferenceViewState extends State<SelectReferenceView> {
  final TextEditingController _referenceController = TextEditingController();
  bool _isReferenceSelectionCommitted = false;
  late String _selectedReturnType;

  @override
  void initState() {
    super.initState();
    _selectedReturnType = widget.selectedReturnType ?? 'Discrepancy Returns';
    if (widget.selectedReference != null) {
      _referenceController.text = widget.selectedReference!.refId;
      _isReferenceSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitledRadioGroup(
            title: 'Return Type',
            options: const ['Field Returns', 'Discrepancy Returns'],
            selectedValue: _selectedReturnType,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedReturnType = value);
                widget.onReturnTypeSelect(value);
              }
            },
          ),
          const SizedBox(height: 24),
          AppSelectionField<Reference>(
            controller: _referenceController,
            labelText: 'Select Reference',
            selectionSheetTitle: 'Re-Print',
            onSelected: widget.onRefSelected,
            initialValue: widget.selectedReference,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isReferenceSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['Reference ID', 'Remark'],
            valueFields: const ['refId', 'remark'],
            mainField: 'refId',
            dataUrl: 'api/references/list',
          ),
          const Spacer(),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isReferenceSelectionCommitted,
          ),
        ],
      ),
    );
  }
}