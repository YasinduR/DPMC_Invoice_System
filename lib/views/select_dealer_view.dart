import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';


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
    required this.onRegionSelectionRequested
  });

  @override
  State<SelectDealerView> createState() => _SelectDealerViewState();
}

class _SelectDealerViewState extends State<SelectDealerView> {
  final TextEditingController _dealerController = TextEditingController();
  bool _isDealerSelectionCommitted = false;
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
        content: 'You must select a region before choosing a dealer. Navigate to the region selection page?',
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
            onSelected: widget.onDealerSelected,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isDealerSelectionCommitted = isCommitted;
              });
            },
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
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isDealerSelectionCommitted,
          ),
        // 
        ],
      ),
    );
  }
}