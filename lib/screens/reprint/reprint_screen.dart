import 'package:flutter/material.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/views/reprint_invoice_view.dart';
import 'package:myapp/views/reprint_reference_view.dart';
import 'package:myapp/widgets/app_page.dart';
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
    // Write Print  Logic here later
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    switch (_currentStep) {
      case 0:
        currentView = SelectReferenceView(
          onRefSelected: _onReferenceSelect,
          onReturnTypeSelect: _onReturnTypeSelect,
          selectedReference: _selectedReference,
          selectedReturnType: _selectedReturnType,
          onSubmit: _submitReference,
        );
        break;
      case 1:
        currentView = SelectInvoiceView(
          selectedInvoice: _selectedInvoice,
          onInvoiceSelected: _onInvoiceSelect,
          onSubmit: _submitInvoice,
        );
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