import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/create_invoice_view.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/views/select_tin_view.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/dealer_model.dart';
//import 'package:myapp/views/auth_dealer_view.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  final PrinterService _printerService = PrinterService();
  int _currentStep = 0;
  TinData? _selectedTin;

  // Regional settings
  Region? _selectedRegion;

  void _onRegionSelected(Region region) {
    setState(() {
      _selectedRegion = region;
    });
  }

  void _submitRegion() {
    if (_selectedRegion != null) {
      ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
      showSnackBar(
        context: context,
        message: 'Region set to: ${_selectedRegion!.region}',
        type: MessageType.success,
      );
      setState(() {
        _currentStep = 0; // Move to the inital
      });
    }
  }

  void _onRegionSelectionRequested() {
    setState(() {
      _currentStep = -1; // Move to Region selection step
    });
  }
  //--- Regional Settings

  // Dealer Selection
  Dealer? _selectedDealer;
  void _onDealerSelected(Dealer dealer) {
    setState(() {
      _selectedDealer = dealer;
      if (_selectedDealer != null) {
        _currentStep = 1;
      }
    });
  }

  // void _submitDealer(Dealer dealer) {
  //   if (_selectedDealer != null) {
  //     setState(() {
  //       _currentStep = 1; // Move to Tin selection
  //     });
  //   }
  // }

  // void _onAuthenticated() {
  //   setState(() {
  //     _currentStep = 2; // Move to Create Invoice step
  //   });
  // }
  //--- Dealer Selection

  void _onTinSelected(TinData tin) {
    setState(() {
      _selectedTin = tin;
    });
  }

  void _submitTin() {
    if (_selectedTin != null) {
      setState(() {
        _currentStep = 2; // Move to Create Invoice step
      });
    }
  }

  Future<void> _saveinvoice(List<Part> selectedParts) async {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final Region? currentRegion = ref.watch(regionProvider).selectedRegion;
    if (selectedParts.isEmpty) {
      showSnackBar(
        context: context,
        message: "No parts to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }

    if (_selectedDealer == null) {
      showSnackBar(
        context: context,
        message: "No dealer to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }
    if (currentRegion == null) {
      showSnackBar(
        context: context,
        message: "No region to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }
    if (_selectedTin == null) {
      showSnackBar(
        context: context,
        message: "No tin to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }
    if (currentUser == null) {
      showSnackBar(
        context: context,
        message: "No user to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }

    double total = 0;
    for (var part in selectedParts) {
      final qty = part.receivedQty;
      final price = part.price;
      total += (qty * price);
    }
    final invoiceData = InvoiceSave(
      invoiceNumber: 'AAA',
      tinNo: _selectedTin!.tinNumber,
      route: currentRegion.region,
      dealerName: _selectedDealer!.name,
      dealerId: _selectedDealer!.accountCode,
      userId: currentUser.id,
      invoiceAmount: total,
      invoiceTime: DateTime.now(),
      parts: selectedParts,
      orderNo: _selectedTin!.orderNumber,
      dealerVatNo: _selectedDealer!.vatNo,
      dealerAddress: _selectedDealer!.address + ', ' + _selectedDealer!.city,
      payOndel: _selectedTin!.payOnDel,
    );

    late InvoiceSave savedInvoice;
    await save(
      context: context,
      dataUrl: 'invoice/save',
      user: currentUser,
      activityType: ActivityType.invoiceSave,
      dataToSave: invoiceData,
      onReceivedData: (rawReceivedData) {
        try {
          savedInvoice = rawReceivedData;
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Failed to process response for Invoice: $e',
            type: MessageType.error,
          );
        }
      },
      onSuccess: () {
        showSnackBar(
          context: context,
          message: 'Invoice saved successfully!',
          type: MessageType.success,
        );
        //final details = PrintFooterDetail({revNo:'PA-FO-53'});
        final details = PrintFooterDetail(
                          formNo: 'PA-FO-53',
                          revNo: '01');
                          
        _printerService.previewThermalInvoicePdf(savedInvoice, details);
      },
      onError: (e) {
        String errorMessage = e.toString().replaceFirst('Exception: ', '');
        showSnackBar(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      },
    );

    // Add print preview. // Pass Dealer Info
    // User Info Tin Info and selected parts to print preview
    //String dealerName = _selectedDealer == null ? '' : _selectedDealer?.name;
    // _printerService.previewThermalInvoicePdf(
    //   selectedParts,
    //   _selectedDealer!.name,
    // );

    // // ADD API request later here
    // showSnackBar(
    //   context: context,
    //   message: "Invoice Saved !",
    //   type: MessageType.success,
    // );
    setState(() {
      _currentStep = 1; // Move to the initial page
    });
  }

  void _goBack() {
    if (_currentStep > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentStep--;
        });
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    final selectedRegion = ref.watch(regionProvider).selectedRegion;
    switch (_currentStep) {
      case -1:
        currentView = SelectRegionView(
          selectedRegion: selectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion,
        );
        break;
      case 0:
        currentView = SelectDealerView(
          selectedRegion: selectedRegion,
          selectedDealer:
              null, // On initilizing od select dealerview always set dealer to null
          onDealerSelected: _onDealerSelected,
          //onSubmit: _submitDealer,
          onRegionSelectionRequested: _onRegionSelectionRequested,
        );
        break;
      // case 1:
      //   currentView = AuthenticateDealerView(
      //     dealer: _selectedDealer!,
      //     onAuthenticated: _onAuthenticated,
      //   );
      //   break;
      case 1:
        currentView = SelectTinNumberView(
          dealer: _selectedDealer!,
          selectedTin: _selectedTin,
          onTinNumberSelected: _onTinSelected,
          onSubmit: _submitTin,
        );
        break;
      case 2:
        currentView = CreateInvoiceView(
          dealer: _selectedDealer!,
          tindata: _selectedTin!,
          onSubmit: _saveinvoice,
        );
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case -1:
        currentTitle = 'Select Region';
        break;
      case 0:
        currentTitle = 'Select Dealer';
        break;
      // case 1:
      //   currentTitle = 'Authenticate Dealer';
      //   break;
      case 1:
        currentTitle = 'Select TIN';
        break;
      case 2:
        currentTitle = 'Invoice';
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
