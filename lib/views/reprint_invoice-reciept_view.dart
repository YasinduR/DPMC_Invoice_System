import 'package:flutter/material.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_radio_group.dart';

// Select Invoice or Receipt to Reprint View from the Screen
class SelectInvRecView extends StatefulWidget {
  final Function(InvoiceSave?, Receipt?, String) onSubmit;
  final InvoiceSave? selectedInvoice;
  final Receipt? selectedReceipt;
  final String? selectedReprintType;

  const SelectInvRecView({
    super.key,
    required this.onSubmit,
    this.selectedInvoice,
    this.selectedReceipt,
    this.selectedReprintType,
  });

  @override
  State<SelectInvRecView> createState() => _SelectInvRecViewState();
}

class _SelectInvRecViewState extends State<SelectInvRecView> {
  //final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _receiptController = TextEditingController();

  bool _invoiceCommitted = false;
  bool _receiptCommitted = false;

  late String _selectedReprintType;
  InvoiceSave? _selectedInvoice;
  Receipt? _selectedReceipt;

  @override
  void initState() {
    super.initState();
    _selectedReprintType = widget.selectedReprintType ?? 'Invoice';

    _selectedInvoice = widget.selectedInvoice;
    _selectedReceipt = widget.selectedReceipt;
    _invoiceController.addListener(_onInvoiceTextChanged);
    _receiptController.addListener(_onReceiptTextChanged);
  }

  bool get _isPrintDisabled {
    if (_selectedReprintType == 'Invoice') {
      return !_invoiceCommitted;
    } else {
      return !_receiptCommitted;
    }
  }

  void _onInvoiceTextChanged() {
    if (_invoiceCommitted) {
      setState(() => _invoiceCommitted = false);
    }
  }

  void _onReceiptTextChanged() {
    if (_receiptCommitted) {
      setState(() => _receiptCommitted = false);
    }
  }

  void _onInvoiceSelected(invoice) {
    _selectedInvoice = invoice;
  }

  void _onReceiptSelected(receipt) {
    _selectedReceipt = receipt;
  }

  @override
  void dispose() {
    _invoiceController.removeListener(_onInvoiceTextChanged);
    _receiptController.removeListener(_onReceiptTextChanged);
    _invoiceController.dispose();
    _receiptController.dispose();
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
            title: 'Reprint Type',
            options: const ['Invoice', 'Receipt'],
            selectedValue: _selectedReprintType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedReprintType = value;
                  _invoiceCommitted = false;
                  _invoiceController.clear();
                  _receiptCommitted = false;
                  _receiptController.clear();
                  _selectedInvoice = null;
                  _selectedReceipt = null;
                });
              }
            },
          ),
          const SizedBox(height: 24),

                    IndexedStack(
            index: _selectedReprintType == 'Invoice' ? 0 : 1,
            children: [

              /// Invoice Field
              AppSelectionField<InvoiceSave>(
                controller: _invoiceController,
                labelText: 'Select Invoice',
                selectionSheetTitle: 'Select Invoice',
                onSelected: _onInvoiceSelected,
                initialValue: widget.selectedInvoice,
                onCommitStateChanged: (isCommitted) {
                  setState(() {
                    _invoiceCommitted = isCommitted;
                  });
                },
                displayNames: const [
                  'Invoice Number',
                  'Date',
                  'Dealer',
                  'Total Amount',
                ],
                valueFields: const [
                  'invoiceNumber',
                  'invoiceTime',
                  'dealerName',
                  'invoiceAmount',
                ],
                mainField: 'invoiceNumber',
                dataUrl: 'invoices-saved/list',
              ),

              /// Receipt Field
              AppSelectionField<Receipt>(
                controller: _receiptController,
                labelText: 'Select Receipt',
                selectionSheetTitle: 'Select Receipt',
                onSelected: _onReceiptSelected,
                initialValue: widget.selectedReceipt,
                onCommitStateChanged: (isCommitted) {
                  setState(() {
                    _receiptCommitted = isCommitted;
                  });
                },
                displayNames: const [
                  'Receipt Number',
                  'Date',
                  'Dealer',
                  'Total Amount',
                ],
                valueFields: const [
                  'receiptNo',
                  'receiptTime',
                  'dealerName',
                  'chequeAmount',
                ],
                mainField: 'receiptNo',
                dataUrl: 'receipts/list',
              ),
            ],
          ),
          const Spacer(),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Print',
            onPressed:
                () => widget.onSubmit(
                  _selectedInvoice,
                  _selectedReceipt,
                  _selectedReprintType,
                ),
            disabled: _isPrintDisabled,
          ),
        ],
      ),
    );
  }
}
