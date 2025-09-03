import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/util/dialog_box.dart';
//import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_help_text_field.dart';

class SelectDealerView extends StatefulWidget {
  //final List<Dealer> dealers;
  final Function(Dealer) onDealerSelected;
  final VoidCallback onSubmit;
  final Dealer? selectedDealer;
  final Region? selectedRegion;
  final VoidCallback onRegionSelectionRequested;

  const SelectDealerView({
    super.key,
    //required this.dealers,
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
  // 1. This is the only state we need to track now.
  bool _isDealerSelectionCommitted = false;

  

  @override
  void initState() {
    super.initState();
    // If a dealer is pre-selected, the state is initially valid.
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

  // MODIFIED: This function no longer navigates. It just calls the callback.
  Future<bool> _handlePreRequest() async {
    if (widget.selectedRegion == null) {
      final bool wantsToSelectRegion = await showConfirmationDialog(
        context: context,
        title: 'No Region Selected',
        content: 'You must select a region before choosing a dealer. Navigate to the region selection page?',
        confirmButtonText: 'Yes, Select Region',
        cancelButtonText: 'Cancel',
      );

      // --- If user says yes, notify the parent widget ---
      if (wantsToSelectRegion) {
        widget.onRegionSelectionRequested();
      }

      // Prevent the selection sheet from opening
      return false;
    }
    // Proceed if region is selected
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

            //items: widget.dealers,
            onSelected: widget.onDealerSelected,
            //displayString: (dealer) => dealer.name,
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