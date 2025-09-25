import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

// Dealer Selection View
class SelectDealerView extends StatefulWidget {
  final Function(Dealer) onDealerSelected;
  final VoidCallback onSubmit;
  final Dealer? selectedDealer;
  final Region? selectedRegion;
  final VoidCallback onRegionSelectionRequested;

  const SelectDealerView({
    super.key,
    required this.onDealerSelected,
    required this.onSubmit,
    this.selectedDealer,
    this.selectedRegion,
    required this.onRegionSelectionRequested,
  });

  @override
  State<SelectDealerView> createState() => _SelectDealerViewState();
}

class _SelectDealerViewState extends State<SelectDealerView> {
  final TextEditingController _dealerController = TextEditingController();
  bool _isDealerSelectionCommitted = false;
  Dealer? _currentSelectedDealer; // Track the currently selected dealer

  @override
  void initState() {
    super.initState();
    if (widget.selectedDealer != null) {
      _dealerController.text = widget.selectedDealer!.name;
      _isDealerSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _dealerController.dispose();
    super.dispose();
  }

  Future<bool> _handlePreRequest() async {
    if (widget.selectedRegion == null) {
      final bool wantsToSelectRegion = await showConfirmationDialog(
        context: context,
        title: 'No Region Selected',
        content:
            'You must select a region before choosing a dealer. Navigate to the region selection page?',
        confirmButtonText: 'Yes, Select Region',
        cancelButtonText: 'Cancel',
      );

      if (wantsToSelectRegion) {
        widget.onRegionSelectionRequested();
      }

      return false;
    }
    return true;
  }

  void _handleAuthentication() async {
    if (_currentSelectedDealer == null) {
      return;
    }
    if (_currentSelectedDealer!.isLocked == true) {
      return;
    }
    
    final String? pin = await showPinVerificationDialog(
      context: context,
      title: 'Authenticate Dealer',
    );
    if (pin == null) {
      return;
    } else {
      dealerLogin(
        context: context,
        dealerCode: _currentSelectedDealer?.accountCode ?? ' ',
        pin: pin,
        onSuccess: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          if (mounted) {
            widget.onSubmit();
          }
        },
        onError: (e) {
          if (mounted) {
            String errorMessage = e.toString().replaceFirst('Exception: ', '');
            
            showSnackBar(
              context: context,
              message: errorMessage,
              type: MessageType.error,
            );
            // Integrate Mechanism to Reload dealer later because dealer.islocked might be changed.

          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField<Dealer>(
            controller: _dealerController,
            labelText: 'Select Dealer',
            selectionSheetTitle: 'Select a Dealer',
            initialValue: widget.selectedDealer,
            preRequest: _handlePreRequest,
            onSelected: (dealer) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _currentSelectedDealer =
                    dealer; 
              });
              widget.onDealerSelected(dealer);
              _handleAuthentication();
            },
            onCommitStateChanged: (isCommitted) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _isDealerSelectionCommitted = isCommitted;
              });
            },
            showHelperOnInitialization: true,
            displayNames: const ['Account Code', 'Name', 'Address', 'City'],
            valueFields: const ['accountCode', 'name', 'address', 'city'],
            mainField: 'name',
            dataUrl: 'api/dealers/list',
            filterConditions:
                widget.selectedRegion != null
                    ? [
                      ['region', '=', widget.selectedRegion!.region],
                    ]
                    : [],
          ),
          const Spacer(),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Authenticate',
            onPressed: _handleAuthentication,
            disabled: !_isDealerSelectionCommitted || _currentSelectedDealer!.isLocked,
          ),
        ],
      ),
    );
  }
}
