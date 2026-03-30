import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/region_model.dart';
// import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/return_save_model.dart';
import 'package:myapp/models/tin_stat_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/add_return_view.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/views/select_tin_view.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/dealer_model.dart';

//import 'package:myapp/views/auth_dealer_view.dart';
import 'package:myapp/models/part_model.dart';

class ReturnScreen extends ConsumerStatefulWidget {
  const ReturnScreen({super.key});

  @override
  ConsumerState<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends ConsumerState<ReturnScreen> {
  final PrinterService _printerService = PrinterService();
  final TextEditingController remarkController = TextEditingController();
  int _currentStep = 0;
  Dealer? _selectedDealer;
  TinData? _selectedTin;
  late TinStat _tinStat;

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

  // void _onDealerSelected(Dealer dealer) {
  //   setState(() {
  //     _selectedDealer = dealer;
  //   });
  // }

  void _onDealerSelected(Dealer dealer) {
    // setState(() {
    _selectedDealer = dealer;
    if (_selectedDealer != null) {
      _currentStep = 1;
      _loadTinSelectionPage();
    }
    // });
  }

  Future<void> _loadTinSelectionPage() async {
    await inquire<TinData>(
      context: context,
      dataUrl: 'tins/list',
      filters: {'dealerCode': _selectedDealer!.accountCode},
      onSuccess: (List<TinData> data) {
        if (!mounted) return;
        setState(() {
          _tinStat = TinStat.fromTinList(data);
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
  // void _submitDealer() {
  //   if (_selectedDealer != null) {
  //     setState(() {
  //       _currentStep = 1; // Move to Authenticate step
  //     });
  //   }
  // }

  // void _onAuthenticated() {
  //   setState(() {
  //     _currentStep = 2; // Move selct tin
  //   });
  // }

  // MODIFIED: Added callbacks for TIN selection
  // void _onTinSelected(TinData tin) {
  //   setState(() {
  //     _selectedTin = tin;
  //   });
  // }

  void _submitTin(tin) async {
    // await _loadTinStat();
    setState(() {
      _selectedTin = tin;
      if (_selectedTin != null) {
        _currentStep = 2; // Move to Add return
      }
    });
  }

  // void _submitTin() {
  //   if (_selectedTin != null) {
  //     setState(() {
  //       _currentStep = 2; // Move to Create Invoice step
  //     });
  //   }
  // }

  void _saveReturn(
    List<Part> selectedItems,
    String selectedReturnType,
    String selectedReason,
  ) async {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final Region? currentRegion = ref.watch(regionProvider).selectedRegion;

    // if (currentUser == null ||
    //     _selectedTin == null ||
    //     currentRegion == null ||
    //     _selectedDealer == null) {
    //   showSnackBar(
    //     context: context,
    //     message: "No data to save. Please try again !",
    //     type: MessageType.error,
    //   );
    //   return;
    // }
    if (selectedItems.isEmpty) {
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
    // // Build a simple payload using Part instances (screens keep using Part)
    // final Map<String, dynamic> savePayload = {
    //   'tinNo': _selectedTin?.tinNumber ?? '',
    //   'dealerCode': _selectedDealer?.accountCode ?? '',
    //   'remark': remarkController.text,
    //   'returnItems': selectedItems
    //       .map((Part p) => {
    //             'partNo': p.partNo,
    //             'requestQty': p.requestQty,
    //             'returnQty': p.returnQty, // <- mapped correctly
    //           })
    //       .toList(),
    //   'date': DateTime.now().toIso8601String(),
    // };

    final saveReturn = Return(
      returnId: 'AAA',
      tinNo: _selectedTin!.tinNumber,
      route: currentRegion!.region,
      dealerName: _selectedDealer!.name,
      dealerId: _selectedDealer!.accountCode,
      userId: currentUser.id,
      returnType: selectedReturnType,
      returnReason: selectedReason,
      returnTime: DateTime.now(),
      returnItems: selectedItems,
    );

    late Return savedReturn;
    await save(
      context: context,
      user: currentUser,
      activityType: ActivityType.returnSave,
      dataUrl: 'return/save',
      dataToSave: saveReturn,
      onReceivedData: (rawReceivedData) {
        savedReturn = rawReceivedData;
      },
      onSuccess: () async {
        showSnackBar(
          context: context,
          message: 'Return saved successfully!',
          type: MessageType.success,
        );
        final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');
        await PrinterService.previewThermalReturnPdf(savedReturn, details);
         _loadTinSelectionPage();

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

    // _loadTinSelectionPage();
    // setState(() {
    //   _currentStep = 1; // Move to the tinselaction
    // });
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
    final selectedRegion = ref.watch(regionProvider).selectedRegion;
    Widget currentView;
    bool confirmOnNavigate = _currentStep > 1;
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
          onRegionSelectionRequested: _onRegionSelectionRequested,
          selectedRegion: selectedRegion,
          selectedDealer: null,
          onDealerSelected: _onDealerSelected,
          //onSubmit: _submitDealer,
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
        currentView = ReturnsView(
          dealer: _selectedDealer!,
          tinData: _selectedTin!,
          tinStat: _tinStat,
          onSubmit: _saveReturn,
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
