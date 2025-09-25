import 'package:flutter/material.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';

// Invoice selection in reprint Screen
class SelectInvoiceView extends StatefulWidget {
  final Function(Invoice) onInvoiceSelected;
  final VoidCallback onSubmit;
  final Invoice? selectedInvoice;

  const SelectInvoiceView({
    super.key,
    required this.onInvoiceSelected,
    required this.onSubmit,
    this.selectedInvoice,
  });

  @override
  State<SelectInvoiceView> createState() => _SelectInvoiceViewState();
}

class _SelectInvoiceViewState extends State<SelectInvoiceView> {
  final TextEditingController _invoiceController = TextEditingController();
  bool _isInvoiceSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedInvoice != null) {
      _invoiceController.text = widget.selectedInvoice!.invoiceNumber;
      _isInvoiceSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField<Invoice>(
            controller: _invoiceController,
            labelText: 'Select Invoice',
            selectionSheetTitle: 'Select Invoice',
            onSelected: widget.onInvoiceSelected,
            initialValue: widget.selectedInvoice,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isInvoiceSelectionCommitted = isCommitted;
              });
            },
            displayNames: const [
              'Date',
              'Invoice Number',
              'Customer',
              'Total Value',
            ],
            valueFields: const [
              'date',
              'invoiceNumber',
              'customer',
              'totalValue',
            ],
            mainField: 'invoiceNumber',
            dataUrl: 'api/invoices/list',
          ),
          const Spacer(),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isInvoiceSelectionCommitted,
          ),
        ],
      ),
    );
  }
}