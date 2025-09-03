import 'package:flutter/material.dart';
import 'package:myapp/models/invoic_model.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_help_text_field.dart';
import 'package:myapp/widgets/app_page.dart';
//import 'package:myapp/widgets/old/custom_selection_form_field.dart';
//import 'package:myapp/widgets/selection_sheet.dart';
import 'package:myapp/widgets/titled_radio_group.dart';
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

  // final List<Reference> _references = [
  //   Reference(refId: 'REF001', remark: 'R1'),
  //   Reference(refId: 'REF002', remark: ''),
  //   Reference(refId: 'REF003', remark: 'R3'),
  //   Reference(refId: 'REF004', remark: ''),
  //   Reference(refId: 'REF005', remark: ''),
  // ];

  // List<Invoice> _invoices = [
  //   Invoice(
  //     date: '07/07/2025',
  //     invoiceNumber: 'MIN00205',
  //     customer: 'ABC Motors',
  //     totalValue: 27000.00,
  //   ),
  //   Invoice(
  //     date: '08/07/2025',
  //     invoiceNumber: 'MIN00206',
  //     customer: 'XYZ Supplies',
  //     totalValue: 15500.50,
  //   ),
  //   Invoice(
  //     date: '08/07/2025',
  //     invoiceNumber: 'MIN00207',
  //     customer: 'John Doe',
  //     totalValue: 9800.75,
  //   ),
  //   Invoice(
  //     date: '09/07/2025',
  //     invoiceNumber: 'MIN00208',
  //     customer: 'Jane Smith',
  //     totalValue: 32000.00,
  //   ),
  //   Invoice(
  //     date: '10/07/2025',
  //     invoiceNumber: 'MIN00209',
  //     customer: 'Global Corp',
  //     totalValue: 54300.20,
  //   ),
  // ];

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

  // void _onAuthenticated() {
  //   setState(() {
  //     _currentStep = 2; // Move to Create Invoice step
  //   });
  // }

  // // MODIFIED: Added callbacks for TIN selection
  // void _onTinSelected(TinData tin) {
  //   setState(() {
  //     _selectedTin = tin;
  //   });
  // }

  // void _submitTin() {
  //   if (_selectedTin != null) {
  //     setState(() {
  //       _currentStep = 3; // Move to Create Invoice step
  //     });
  //   }
  // }

  // void _saveReturn() {
  //   setState(() {
  //     _currentStep = 0; // Move to the initial page
  //   });
  //   showSnackBar(
  //     context: context,
  //     message: "Invoice Saved !",
  //     type: MessageType.success,
  //   );
  // }

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
          // The old CustomSelectionFormField is replaced with our reusable component.
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
            dataUrl: 'api/invoicess/list',
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

// class SelectReferenceView extends StatefulWidget {
//   final List<Reference> refs;
//   final Function(Reference) onRefSelected;
//   final Function(String) onReturnTypeSelect;
//   final VoidCallback onSubmit;
//   final Reference? selectedReference;
//   final String? selectedReturnType;

//   const SelectReferenceView({
//     super.key,
//     required this.refs,
//     required this.onRefSelected,
//     required this.onReturnTypeSelect,
//     required this.onSubmit,
//     this.selectedReference,
//     this.selectedReturnType,
//   });

//   @override
//   State<SelectReferenceView> createState() => _SelectReferenceViewState();
// }

// class _SelectReferenceViewState extends State<SelectReferenceView> {
//   late List<Reference> _filteredrefs;
//   final TextEditingController _searchController = TextEditingController();
//   late String _selectedReturnType;
//   //String _selectedReturnType = 'Discrepancy Returns';
//   // String _selectedReturnType;

//   @override
//   void initState() {
//     super.initState();
//     _filteredrefs = widget.refs;
//     _searchController.addListener(_filterRefs);
//     _selectedReturnType = widget.selectedReturnType ?? 'Discrepancy Returns';
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _filterRefs() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredrefs =
//           widget.refs.where((ref) {
//             return ref.refId.toLowerCase().contains(query) ||
//                 ref.remark.toLowerCase().contains(query);
//           }).toList();
//     });
//   }

//   Future<void> _showReferenceSelection(BuildContext context) async {
//     final selectedReference = await showModalBottomSheet<Reference>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return SelectionSheet<Reference>(
//           title: 'Re-Print',
//           items: _filteredrefs,
//           searchController: _searchController,
//           headerBuilder: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   'Referece ID',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   'Remark',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           itemBuilder: (Reference ref) {
//             return InkWell(
//               onTap: () => Navigator.of(context).pop(ref),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 12.0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(child: Text(ref.refId)),
//                     Expanded(child: Text(ref.remark)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );

//     if (selectedReference != null) {
//       widget.onRefSelected(selectedReference);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TitledRadioGroup(
//             title: 'Return Type',
//             options: const ['Field Returns', 'Discrepancy Returns'],
//             selectedValue: _selectedReturnType,
//             onChanged: (value) {
//               if (value != null) {
//                 setState(() => _selectedReturnType = value);
//                 widget.onReturnTypeSelect(value);
//               }
//             },
//           ),
//           const SizedBox(height: 24),
//           CustomSelectionFormField<Reference>(
//             labelText: 'Select Reference',
//             selectedValue: widget.selectedReference,
//             displayString: (ref) => ref.refId,
//             onShowPicker: _showReferenceSelection,
//           ),
//           const Spacer(),
//           ActionButton(
//             icon: Icons.check_circle_outline,
//             label: 'Submit',
//             onPressed: widget.onSubmit,
//             disabled: widget.selectedReference == null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SelectInvoiceView extends StatefulWidget {
//   final List<Invoice> invoices;
//   final Function(Invoice) onInvoiceSelected;
//   final VoidCallback onSubmit;
//   final Invoice? selectedInvoice;

//   const SelectInvoiceView({
//     super.key,
//     required this.invoices,
//     required this.onInvoiceSelected,
//     required this.onSubmit,
//     this.selectedInvoice,
//   });

//   @override
//   State<SelectInvoiceView> createState() => _SelectInvoiceViewState();
// }

// class _SelectInvoiceViewState extends State<SelectInvoiceView> {
//   late List<Invoice> _filteredinvoices;
//   final TextEditingController _searchController = TextEditingController();
//   //String _selectedReturnType = 'Discrepancy Returns';

//   @override
//   void initState() {
//     super.initState();
//     _filteredinvoices = widget.invoices;
//     _searchController.addListener(_filterinvoices);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _filterinvoices() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredinvoices =
//           widget.invoices.where((invoice) {
//             return invoice.customer.toLowerCase().contains(query) ||
//                 invoice.invoiceNumber.toLowerCase().contains(query) ||
//                 invoice.totalValue.toString().toLowerCase().contains(query);
//           }).toList();
//     });
//   }

//   Future<void> _showInvoiceSelection(BuildContext context) async {
//     final selectedInvoice = await showModalBottomSheet<Invoice>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return SelectionSheet<Invoice>(
//           title: 'Re-Print',
//           items: _filteredinvoices,
//           searchController: _searchController,
//           headerBuilder: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   'Date',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   'Invoice Number',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   'Customer',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   'Total Value',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           itemBuilder: (Invoice invoice) {
//             return InkWell(
//               onTap: () => Navigator.of(context).pop(invoice),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 12.0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(child: Text(invoice.date)),
//                     Expanded(child: Text(invoice.invoiceNumber)),
//                     Expanded(child: Text(invoice.customer)),
//                     Expanded(child: Text(invoice.totalValue.toString())),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );

//     if (selectedInvoice != null) {
//       widget.onInvoiceSelected(selectedInvoice);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomSelectionFormField<Invoice>(
//             labelText: 'Select Invoice',
//             selectedValue: widget.selectedInvoice,
//             displayString: (invoice) => invoice.invoiceNumber,
//             onShowPicker: _showInvoiceSelection,
//           ),
//           const Spacer(),
//           ActionButton(
//             icon: Icons.check_circle_outline,
//             label: 'Submit',
//             onPressed: widget.onSubmit,
//             disabled: widget.selectedInvoice == null,
//           ),
//         ],
//       ),
//     );
//   }
// }
