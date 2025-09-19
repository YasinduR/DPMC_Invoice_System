import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';

// TIN selection view shows after the dealer selection
class SelectTinNumberView extends StatefulWidget {
  final Dealer dealer;
  final Function(TinData) onTinNumberSelected;
  final VoidCallback onSubmit;
  final TinData? selectedTin;

  const SelectTinNumberView({
    super.key,
    required this.onTinNumberSelected,
    required this.onSubmit,
    required this.dealer,
    this.selectedTin,
  });

  @override
  State<SelectTinNumberView> createState() => _SelectTinNumberViewState();
}

class _SelectTinNumberViewState extends State<SelectTinNumberView> {
  final TextEditingController _tinController = TextEditingController();
  bool _isTinSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedTin != null) {
      _tinController.text = widget.selectedTin!.tinNumber;
      _isTinSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DealerInfoCard(dealer: widget.dealer),
          const SizedBox(height: 16),

          AppSelectionField<TinData>(
            controller: _tinController,
            labelText: 'Select TIN Number',
            selectionSheetTitle: 'Select a TIN Number',
            initialValue: widget.selectedTin,
            onSelected: widget.onTinNumberSelected,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isTinSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['TIN Number', 'Total Value'],
            valueFields: const ['tinNumber', 'totalValue'],
            mainField: 'tinNumber',
            dataUrl: 'api/tins/list',
          ),

          const Spacer(),

          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isTinSelectionCommitted,
          ),
        ],
      ),
    );
  }
}