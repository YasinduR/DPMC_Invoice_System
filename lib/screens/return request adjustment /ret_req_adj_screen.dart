import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/return_request_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/views/return_request_adjust_view.dart';
import 'package:myapp/views/select_return_request_view.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/models/dealer_model.dart';

// Return Request Adjust Screen
class RetReqAdjScreen extends ConsumerStatefulWidget {
  const RetReqAdjScreen({super.key});

  @override
  ConsumerState<RetReqAdjScreen> createState() => _RetReqAdjScreenState();
}

class _RetReqAdjScreenState extends ConsumerState<RetReqAdjScreen> {
  int _currentStep = 0;
  ReturnRequest? _selectedRetReq;

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
        _selectedRetReq = null;
        _currentStep = 1;
      }
    });
  }

  void _onRetReqSelected(ReturnRequest retReq) {
    setState(() {
      _selectedRetReq = retReq;
    });
  }

  void _submitReturnRequest() {
    if (_selectedRetReq != null) {
      setState(() {
        _currentStep = 2; // Move to Create Invoice step
      });
    }
  }

  Future<void> _updateReturnRequest(List<ReturnItem> selectedItems) async {

    if (_selectedRetReq == null || selectedItems.isEmpty) {
          showSnackBar(
            context: context,
            message: 'No Data to Save',
            type: MessageType.error,
          ); 
      return; // Exit early
    } else {
      final Set<String> originalPartNos = _selectedRetReq!.returnItems.map((item) => item.partNo).toSet();
      final Set<String> modifiedPartNos = selectedItems.map((item) => item.partNo).toSet();
      if (originalPartNos.length != modifiedPartNos.length || !originalPartNos.containsAll(modifiedPartNos)) {
        showSnackBar(
          context: context,
          message: 'The list of parts in the return request cannot be modified. Only quantities are editable.',
          type: MessageType.error,
        );
      return;
      }
      
      final authState = ref.watch(authProvider);
      final User? currentUser = authState.currentUser;

      final retReqData = ReturnRequest(
        requestUpdate: DateTime.now(),
        returnId: _selectedRetReq!.returnId,
        dealerId: _selectedRetReq!.dealerId,
        userId: _selectedRetReq!.userId,
        returnType: _selectedRetReq!.returnType,
        returnReason: _selectedRetReq!.returnReason,
        returnTime: _selectedRetReq!.returnTime,
        returnItems: selectedItems,
      );

      await save(
        context: context,
        user: currentUser,
        activityType: ActivityType.returnRequestAdjustment,
        dataUrl: 'return-request/update',
        dataToSave: retReqData,

        onSuccess: () {
          showSnackBar(
            context: context,
            message: 'Return Request updated successfully!',
            type: MessageType.success,
          );

          setState(() {
            _selectedRetReq = null;
            _currentStep = 1; // Move to the initial page
          });
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
          selectedDealer:null, 
          onDealerSelected: _onDealerSelected,
          onRegionSelectionRequested: _onRegionSelectionRequested,
        );
        break;
      case 1:
        currentView = SelectReturnRequestView(
          dealer: _selectedDealer!,
          selectedReturnRequest: _selectedRetReq,
          onSubmit: _submitReturnRequest,
          onReturnRequestSelected: _onRetReqSelected,
        );
        break;
      case 2:
        currentView = ReturnRequestView(
          dealer: _selectedDealer!,
          returnReq: _selectedRetReq!,
          onSubmit: _updateReturnRequest,
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
        currentTitle = 'Select Return Request';
        break;
      case 2:
        currentTitle = 'Return Request Adjustment';
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
