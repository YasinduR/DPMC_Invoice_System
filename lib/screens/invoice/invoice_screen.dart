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
import 'package:myapp/views/add_return_view.dart';
import 'package:myapp/models/tin_stat_model.dart';
import 'package:myapp/models/return_save_model.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  final PrinterService _printerService = PrinterService();
  InvoiceSave? _lastSavedInvoice;
  int _currentStep = 0;
  TinData? _selectedTin;
  TinStat? _tinStat;
  //List<Part>?_pendingReturnParts; // <-- new: store remaining parts for ReturnsView

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
    //setState(() {
    _selectedDealer = dealer;
    if (_selectedDealer != null) {
      _loadTinSelectionPage();
    }
    //});
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

  // void _onTinSelected(TinData tin) {
  //   setState(() {
  //     _selectedTin = tin;
  //   });
  // }

  void _submitTin(tin) {
    setState(() {
      _selectedTin = tin;
      if (_selectedTin != null) {
        _currentStep = 2; // Move to Create Invoice step
      }
    });
  }

  // Future<void> _loadReturnPage() async {
  //   await inquire<TinData>(
  //     context: context,
  //     dataUrl: 'tins/list',
  //     filters: {'tinNumber': _selectedTin!.tinNumber},
  //     onSuccess: (List<TinData> data) {
  //       if (!mounted) return;
  //       setState(() {
  //         _selectedTin = data[0];
  //         //_pendingReturnParts = data[0].parts;
  //         _currentStep = 3;
  //       });
  //     },
  //     onError: (String message) {
  //       if (!mounted) return;
  //       showSnackBar(
  //         context: context,
  //         message: message,
  //         type: MessageType.error,
  //       );
  //     },
  //   );
  // }

  // Future<void> _loadReturnPage() async {
  //   await inquire<TinData>(
  //     context: context,
  //     dataUrl: 'tins/list',
  //     filters: {'dealerCode': _selectedDealer!.accountCode},
  //     onSuccess: (List<TinData> data) {
  //       if (!mounted) return;

  //       final TinData? selectedTin = data.firstWhere(
  //         (t) => t.tinNumber == _selectedTin!.tinNumber,
  //       );

  //       setState(() {
  //         _selectedTin = selectedTin;
  //         _tinStat = TinStat.fromTinList(data);
  //         _currentStep = 3;
  //       });
  //     },
  //     onError: (String message) {
  //       if (!mounted) return;
  //       showSnackBar(
  //         context: context,
  //         message: message,
  //         type: MessageType.error,
  //       );
  //     },
  //   );
  // }

  // Future<void> _loadTinSelectionPage() async {
  //   await inquire<TinData>(
  //     context: context,
  //     dataUrl: 'tins/list',
  //     filters: {'dealerCode': _selectedDealer!.accountCode},
  //     onSuccess: (List<TinData> data) {
  //       if (!mounted) return;
  //       setState(() {
  //         _tinStat = TinStat.fromTinList(data);
  //         _currentStep = 1;
  //       });
  //     },
  //     onError: (String message) {
  //       if (!mounted) return;
  //       showSnackBar(
  //         context: context,
  //         message: message,
  //         type: MessageType.error,
  //       );
  //     },
  //   );
  // }
  
  Future<void> _loadReturnPage() async {
    await inquireN(
      context: context,
      dataUrl: 'tins/list',
      body: {
        "filters": {"dealerCode": _selectedDealer!.accountCode},
      },
      onSuccess: (data) {
        if (!mounted) return;
        final List<dynamic> details = data['details'];
    
        final List<TinData> tins =
            details.map((e) => TinData.fromJson(e)).toList();

        final TinData? selectedTin = data.firstWhere(
          (t) => t.tinNumber == _selectedTin!.tinNumber,
        );

        setState(() {
          _selectedTin = selectedTin;
          _tinStat = TinStat.fromTinList(tins);
          _currentStep = 3;
        });
      },
      onError: (String message) {
        if (!mounted) return;
        showSnackBar(
          context: context,
          message: message,
          type: MessageType.error,
        );
      },
    );
  }

  Future<void> _loadTinSelectionPage() async {
    await inquireN(
      context: context,
      dataUrl: 'tins/list',
      body: {"dealerCode": _selectedDealer!.accountCode,},
      onSuccess: (data) {
        if (!mounted) return;

          if (data is! List) {
          showSnackBar(
            context: context,
            message: 'Invalid response format from server',
            type: MessageType.error,
          );
          return;
        }
        
        final List<dynamic> details = data;
        
        final List<TinData> tins = details.map((e) => TinData.fromJson(e)).toList();
        setState(() {
          _tinStat = TinStat.fromTinList(tins);
          _currentStep = 1;
        });
      },
      onError: (String message) {
        if (!mounted) return;
        showSnackBar(
          context: context,
          message: message,
          type: MessageType.error,
        );
      },
    );
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

    final invoiceParts =
        selectedParts
            // restore original working mapping: submit requestQty = receivedQty
            .map((p) => p.copyWith(requestQty: p.receivedQty))
            .toList();

    final bool isAllRecieved = _selectedTin!.parts.every((tinPart) {
      final selected =
          selectedParts
              .where((p) => p.partNo == tinPart.partNo)
              .cast<dynamic>()
              .firstOrNull;

      return selected != null && tinPart.requestQty == selected.receivedQty;
    });

    final invoiceData = InvoiceSave(
      invoiceNumber: 'AAA',
      tinNo: _selectedTin!.tinNumber,
      route: currentRegion.region,
      dealerName: _selectedDealer!.name,
      dealerId: _selectedDealer!.accountCode,
      userId: currentUser.id,
      invoiceAmount: total,
      invoiceTime: DateTime.now(),
      parts: invoiceParts,
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
          _lastSavedInvoice =
              rawReceivedData; // keep last saved invoice for later print flow
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Failed to process response for Invoice: $e',
            type: MessageType.error,
          );
        }
      },
      onSuccess: () async {
        showSnackBar(
          context: context,
          message: 'Invoice saved successfully!',
          type: MessageType.success,
        );
        //final details = PrintFooterDetail({revNo:'PA-FO-53'});
        final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');

        // // get latest tin from mock master (use API in prod)
        // final updatedTin = DummyData.tins.firstWhere(
        //   (t) =>
        //       t.tinNumber == _selectedTin!.tinNumber ||
        //       t.orderNumber == _selectedTin!.orderNumber,
        //   orElse: () => _selectedTin!,
        // );

        // if (updatedTin.parts.isNotEmpty) {
        //   setState(() {
        //     _selectedTin = updatedTin;
        //     _pendingReturnParts = updatedTin.parts; // <-- pass remaining parts
        //     _currentStep = 3; // navigate to ReturnsView
        //   });
        //   return;
        // }

        await PrinterService.previewThermalInvoicePdf(savedInvoice, details);
        if (!isAllRecieved) {
          _loadReturnPage();
        } else {
          _loadTinSelectionPage();
        }
        return;
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
    // if (_currentStep != 3) {
    //   setState(() { _currentStep = 1; });
    // }
  }

  Future<void> _saveReturn(List<Part> items, String type, String reason) async {
    // simple pass-through to the same save helper used elsewhere
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final Region? currentRegion = ref.watch(regionProvider).selectedRegion;
    if (currentUser == null) return;

    // final Map<String, dynamic> savePayload = {
    //   'tinNo': _selectedTin!.tinNumber,
    //   'orderNo': _selectedTin!.orderNumber ?? '',
    //   // use tin's dealer code (avoid referencing non-existing User.dealerCode)
    //   'dealerCode': _selectedTin!.dealercode ?? '',
    //   'remark': '', // no invoice-level remark available here
    //   'returnItems': items.map((Part p) => {
    //     'partNo': p.partNo,
    //     'requestQty': p.requestQty,
    //     'returnQty': p.returnQty, // <- mapped correctly
    //   }).toList(),
    //   'date': DateTime.now().toIso8601String(),
    // };

    final saveReturn = Return(
      returnId: 'AAA',
      tinNo: _selectedTin!.tinNumber,
      route: currentRegion!.region,
      dealerName: _selectedDealer!.name,
      dealerId: _selectedDealer!.accountCode,
      userId: currentUser.id,
      returnType: type,
      returnReason: reason,
      returnTime: DateTime.now(),
      returnItems: items,
    );

    late Return savedReturn;
    // wrap payload in Mappable so save(...) accepts it
    await save(
      context: context,
      user: currentUser,
      activityType: ActivityType.returnSave,
      dataUrl: 'return/save',
      dataToSave: saveReturn,
      onReceivedData: (rawReceivedData) {
        try {
          savedReturn = rawReceivedData;
          // Handle any response parsing if needed
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Failed to process response for Return: $e',
            type: MessageType.error,
          );
        }
      },
      onSuccess: () async {
        showSnackBar(
          context: context,
          message: 'Return saved successfully!',
          type: MessageType.success,
        );

        final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');
        try {
          PrinterService.previewThermalReturnPdf(savedReturn, details);

          // if (_lastSavedInvoice != null) {
          //   PrinterService.previewThermalInvoicePdf(_lastSavedInvoice!, details);
          // }
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Print preview failed: $e',
            type: MessageType.error,
          );
        }

        // Navigate back to Select TIN step after previews complete
        setState(() {
          _selectedTin = null;
          _currentStep = 1; // Select TIN
          _lastSavedInvoice = null;
        });
      },
      onError: (e) {
        showSnackBar(
          context: context,
          message: e.toString(),
          type: MessageType.error,
        );
      },
    );

    // keep existing behavior for non-flow cases
    if (_currentStep != 3) {
      setState(() => _currentStep = 1);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      if (_currentStep == 3) {
        _loadTinSelectionPage();
        return;
      }
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
    bool confirmOnNavigate = _currentStep > 1;
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
          selectedTin: null,
          tinStat: _tinStat,
          //onTinNumberSelected: _onTinSelected,
          onSubmit: _submitTin,
        );
        break;
      case 2:
        currentView = CreateInvoiceView(
          dealer: _selectedDealer!,
          tindata: _selectedTin!,
          onSubmit: _saveinvoice,
          tinStat: _tinStat,
        );
        break;
      case 3:
        currentView = ReturnsView(
          dealer: _selectedDealer!,
          tinData: _selectedTin!,
          tinStat: _tinStat!,
          onSubmit: (parts, type, reason) => _saveReturn(parts, type, reason),
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
      // currentTitle = 'Select Dealer';
      // break;
      // case 1:
      //   currentTitle = 'Authenticate Dealer';
      //   break;
      case 1:
      // currentTitle = 'Select TIN';
      // break;
      case 2:
        currentTitle = 'Invoice';
        break;
      case 3:
        currentTitle = 'Returns';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      confirmOnNavigate: confirmOnNavigate,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}
