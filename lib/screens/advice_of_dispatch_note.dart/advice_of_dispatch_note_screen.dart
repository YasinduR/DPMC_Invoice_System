import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/select_multiple_tin_view.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/dealer_model.dart';
//import 'package:myapp/views/auth_dealer_view.dart';

class DispatchNoteScreen extends ConsumerStatefulWidget {
  const DispatchNoteScreen({super.key});

  @override
  ConsumerState<DispatchNoteScreen> createState() => _DispatchNoteScreenState();
}

class _DispatchNoteScreenState extends ConsumerState<DispatchNoteScreen> {
  final PrinterService _printerService = PrinterService();
  int _currentStep = 0;
  List<TinData> _selectedTins = [];
  // Create controller instance
  final TinsSelectionController _tinsController = TinsSelectionController();

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

  void _onPrintSuccess() {
    // Trigger reset through controller
    _tinsController.reset();

    setState(() {
      _selectedTins = [];
    });
  }

  void _submitTins(List<TinData> finalTins) {
    if (finalTins.isNotEmpty) {
      setState(() {
        _selectedTins = finalTins;
        _saveDispatchNote();
      });
    }
  }

  Future<void> _saveDispatchNote() async {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final Region? currentRegion = ref.watch(regionProvider).selectedRegion;
    if (_selectedTins.isEmpty) {
      showSnackBar(
        context: context,
        message: "No TINs to proceed. Please try again !",
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

    if (currentUser == null) {
      showSnackBar(
        context: context,
        message: "No user to save. Please try again !",
        type: MessageType.error,
      );
      return;
    }

    final dispatchNoteData = DispatchNoteSave(
      dispatchNumber: 'AAAA',
      tins: _selectedTins,
      route: currentRegion.region,
      dealerName: _selectedDealer!.name,
      dealerId: _selectedDealer!.accountCode,
      userId: currentUser.id,
      dispatchTime: DateTime.now(),
      dealerVatNo: _selectedDealer!.vatNo,
      dealerAddress: '${_selectedDealer!.address}, ${_selectedDealer!.city}',
    );
    late DispatchNoteSave savedDispatchNote;
    await save(
      context: context,
      dataUrl: 'dispatchNote/save',
      dataToSave: dispatchNoteData,
      onReceivedData: (rawReceivedData) {
        try {
          savedDispatchNote = rawReceivedData;
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Failed to process response for Dispatch Note: $e',
            type: MessageType.error,
          );
        }
      },
      onSuccess: () async {
        showSnackBar(
          context: context,
          message: 'Advice of Dispatch Note saved successfully!',
          type: MessageType.success,
        );
        final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');
        await _printerService.previewDispatchNotePdf(savedDispatchNote, details);
        _onPrintSuccess();
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
          selectedDealer: null,
          onDealerSelected: _onDealerSelected,
          onRegionSelectionRequested: _onRegionSelectionRequested,
        );
        break;
      case 1:
        currentView = SelectTinsView(
          dealer: _selectedDealer!,
          tins: _selectedTins,
          onSubmit: _submitTins,
          controller: _tinsController, // Pass the controller
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
      case 1:
        currentTitle = 'Select TINs';
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
