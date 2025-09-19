import 'package:flutter/material.dart';
import 'package:myapp/models/invoic_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_radio_group.dart';
import 'package:myapp/models/reference_model.dart';

class ReprintScreen extends StatefulWidget {
  const ReprintScreen({super.key});

  @override
  State<ReprintScreen> createState() => _ReprintScreenState();
}

class _ReprintScreenState extends State<ReprintScreen> {
  int _currentStep = 0;
  Reference? _selectedReference;
  Invoice? _selectedInvoice;
  String? _selectedReturnType;

  void _onReferenceSelect(Reference ref) {
    setState(() {
      _selectedReference = ref;
    });
  }

  void _onInvoiceSelect(Invoice invoice) {
    setState(() {
      _selectedInvoice = invoice;
    });
  }

  void _onReturnTypeSelect(String returnType) {
    setState(() {
      _selectedReturnType = returnType;
    });
  }

  void _submitReference() {
    if (_selectedReference != null) {
      setState(() {
        _currentStep = 1; // Move to Authenticate step
      });
    }
  }

  void _submitInvoice() {
    // if (_selectedInvoice != null) {
    //   setState(() {
    //     _currentStep = 1; // Move to Authenticate step
    //   });
    // }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
      // In a real app, you might use Navigator.of(context).pop();
      //print("Already at the first step.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    switch (_currentStep) {
      case 0:
        currentView = SelectReferenceView(
          //refs: _references,
          onRefSelected: _onReferenceSelect,
          onReturnTypeSelect: _onReturnTypeSelect,
          selectedReference: _selectedReference,
          selectedReturnType: _selectedReturnType,
          onSubmit: _submitReference,
        );
        break;
      case 1:
        currentView = SelectInvoiceView(
          //invoices: _invoices,
          selectedInvoice: _selectedInvoice,
          onInvoiceSelected: _onInvoiceSelect,
          onSubmit: _submitInvoice,
        );
        // currentView = SelectReferenceView(
        //   refs: _references,
        //   onRefSelected: _onReferenceSelect,
        //   onSubmit: _submitReference,
        // );

        // currentView = AuthenticateDealerView(
        //   dealer: _selectedDealer!,
        //   onAuthenticated: _onAuthenticated,
        // );
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case 0:
        currentTitle = 'Re-Print';
        break;
      case 1:
        currentTitle = 'Select Invoice';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}

class SelectReferenceView extends StatefulWidget {
  //final List<Reference> refs;
  final Function(Reference) onRefSelected;
  final Function(String) onReturnTypeSelect;
  final VoidCallback onSubmit;
  final Reference? selectedReference;
  final String? selectedReturnType;

  const SelectReferenceView({
    super.key,
    //required this.refs,
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
    // This logic for the radio button remains unchanged.
    _selectedReturnType = widget.selectedReturnType ?? 'Discrepancy Returns';

    // If a reference is pre-selected, populate the field and set the initial state.
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
          // The radio group for 'Return Type' is independent and remains as is.
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

          // Replace the old CustomSelectionFormField with the powerful AppSelectionField.
          AppSelectionField<Reference>(
            controller: _referenceController,
            labelText: 'Select Reference',
            selectionSheetTitle: 'Re-Print',
            //items: widget.refs,
            onSelected: widget.onRefSelected,
            initialValue: widget.selectedReference,
            //displayString: (ref) => ref.refId,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isReferenceSelectionCommitted = isCommitted;
              });
            },
            // Define the columns for the selection sheet.
            displayNames: const ['Reference ID', 'Remark'],
            // Define the data fields from the Reference's toMap() method.
            valueFields: const ['refId', 'remark'],
            // Define the field for exact-match auto-selection.
            mainField: 'refId',
            dataUrl: 'api/references/list',
          ),

          const Spacer(),

          // The submit button is now tied to the committed state of the selection field.
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

class SelectInvoiceView extends StatefulWidget {
  //final List<Invoice> invoices;
  final Function(Invoice) onInvoiceSelected;
  final VoidCallback onSubmit;
  final Invoice? selectedInvoice;

  const SelectInvoiceView({
    super.key,
    //required this.invoices,
    required this.onInvoiceSelected,
    required this.onSubmit,
    this.selectedInvoice,
  });

  @override
  State<SelectInvoiceView> createState() => _SelectInvoiceViewState();
}

class _SelectInvoiceViewState extends State<SelectInvoiceView> {
  final TextEditingController _invoiceController = TextEditingController();
  // The only state we need to track for the selection logic.
  bool _isInvoiceSelectionCommitted = false;

  @override
  void initState() {
    super.initState();

    // If an invoice is pre-selected, populate the field and set the initial state.
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
            //items: widget.invoices,
            onSelected: widget.onInvoiceSelected,
            initialValue: widget.selectedInvoice,
            // displayString: (invoice) => invoice.invoiceNumber,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isInvoiceSelectionCommitted = isCommitted;
              });
            },
            // Define the table headers for the selection sheet.
            displayNames: const [
              'Date',
              'Invoice Number',
              'Customer',
              'Total Value',
            ],
            // Define the corresponding field names from the Invoice's toMap() method.
            valueFields: const [
              'date',
              'invoiceNumber',
              'customer',
              'totalValue',
            ],
            // Set the main field for the exact-match auto-selection feature.
            mainField: 'invoiceNumber',
            dataUrl: 'api/invoices/list',
          ),

          const Spacer(),

          // The submit button's state is now reliably driven by the selection field.
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