import 'package:flutter/material.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/reprint_invoice-reciept_view.dart';
//import 'package:myapp/views/reprint_invoice-receipt_view.dart';
import 'package:myapp/views/reprint_invoice_view.dart';
import 'package:myapp/views/reprint_reference_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/models/reference_model.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

// class ReprintScreen extends StatefulWidget {
//   const ReprintScreen({super.key});

//   @override
//   State<ReprintScreen> createState() => _ReprintScreenState();
// }

// class _ReprintScreenState extends State<ReprintScreen> {
//   int _currentStep = 0;
//   Reference? _selectedReference;
//   Invoice? _selectedInvoice;
//   String? _selectedReturnType;

//   void _onReferenceSelect(Reference ref) {
//     setState(() {
//       _selectedReference = ref;
//     });
//   }

//   void _onInvoiceSelect(Invoice invoice) {
//     setState(() {
//       _selectedInvoice = invoice;
//     });
//   }

//   void _onReturnTypeSelect(String returnType) {
//     setState(() {
//       _selectedReturnType = returnType;
//     });
//   }

//   void _submitReference() {
//     if (_selectedReference != null) {
//       setState(() {
//         _currentStep = 1; // Move to Authenticate step
//       });
//     }
//   }

//   void _submitInvoice() {
//     // Write Print  Logic here later
//   }

//   void _goBack() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//     } else {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget currentView;
//     switch (_currentStep) {
//       case 0:
//         currentView = SelectReferenceView(
//           onRefSelected: _onReferenceSelect,
//           onReturnTypeSelect: _onReturnTypeSelect,
//           selectedReference: _selectedReference,
//           selectedReturnType: _selectedReturnType,
//           onSubmit: _submitReference,
//         );
//         break;
//       case 1:
//         currentView = SelectInvoiceView(
//           selectedInvoice: _selectedInvoice,
//           onInvoiceSelected: _onInvoiceSelect,
//           onSubmit: _submitInvoice,
//         );
//         break;
//       default:
//         currentView = const Center(child: Text('Error'));
//     }
//     final String currentTitle;
//     switch (_currentStep) {
//       case 0:
//         currentTitle = 'Re-Print';
//         break;
//       case 1:
//         currentTitle = 'Select Invoice';
//         break;
//       default:
//         currentTitle = 'Error';
//     }

//     return AppPage(
//       title: currentTitle,
//       onBack: _goBack,
//       contentPadding: EdgeInsets.zero,
//       child: currentView,
//     );
//   }
// }
class ReprintScreen extends StatefulWidget {
  const ReprintScreen({super.key});

  @override
  State<ReprintScreen> createState() => _ReprintScreenState();
}

class _ReprintScreenState extends State<ReprintScreen> {
  int _currentStep = 0;
  // String? _selectedReturnType;   // commented by Darshan R on 23/03/2026 because not used anywhere in the code!
  final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');
  final PrinterService _printerService = PrinterService();

  void _submit(InvoiceSave? invoice, Receipt? receipt, DispatchNoteSave? dispatchNote, String type) {

    if (type == 'Invoice' && invoice != null) {
      PrinterService.previewThermalInvoicePdf(
        invoice,
        details,
        isReprint: true,
      );
      // call invoice print service
      showSnackBar(
        context: context,
        message: 'Invoice reprinted successfully!',
        type: MessageType.success,
      );
    } else if (type == 'Receipt' && receipt != null) {
      PrinterService.previewThermalReceiptPdf(
        receipt,
        details,
        isReprint: true,
      );
      showSnackBar(
        context: context,
        message: 'Receipt reprinted successfully!',
        type: MessageType.success,
      );
      // call receipt print service
    } else if (type == 'Advice of Dispatch' && dispatchNote != null) {    // Added by Darshan R on 23/03/2026
      _printerService.previewDispatchNotePdf(
        dispatchNote,
        details,
      );
      showSnackBar(
        context: context,
        message: 'Advice of Dispatch reprinted successfully!',
        type: MessageType.success,
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Reprint Failed!',
        type: MessageType.error,
      );
    }
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
        currentView = SelectInvRecView(onSubmit: _submit);
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
        currentTitle = 'Re-Print';
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
