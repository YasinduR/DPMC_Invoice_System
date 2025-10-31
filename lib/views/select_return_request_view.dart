import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/return_request_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';

// Return Request selection view shows after the dealer selection
class SelectReturnRequestView extends StatefulWidget {
  final Dealer dealer;
  final Function(ReturnRequest) onReturnRequestSelected;
  final VoidCallback onSubmit;
  final ReturnRequest? selectedReturnRequest;

  const SelectReturnRequestView({
    super.key,
    required this.onReturnRequestSelected,
    required this.onSubmit,
    required this.dealer,
    this.selectedReturnRequest,
  });

  @override
  State<SelectReturnRequestView> createState() => _SelectReturnRequestViewState();
}

class _SelectReturnRequestViewState extends State<SelectReturnRequestView> {
  final TextEditingController _retReqController = TextEditingController();
  bool _isRetReqSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedReturnRequest != null) {
      _retReqController.text = widget.selectedReturnRequest!.returnId;
      _isRetReqSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _retReqController.dispose();
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

          AppSelectionField<ReturnRequest>(
            controller: _retReqController,
            labelText: 'Select Return Request',
            selectionSheetTitle: 'Select a Return Request',
            initialValue: widget.selectedReturnRequest,
            onSelected: widget.onReturnRequestSelected,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isRetReqSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['Return ID', 'Return Type','Return Reason'],
            valueFields: const ['returnId', 'returnType','returnReason'],
            mainField: 'returnId',
            dataUrl: 'api/return-request/list',
            filterConditions:
                widget.dealer != null
                    ? [
                      ['dealerId', '=', widget.dealer.accountCode],
                    ]
                    : [],
          ),

          const Spacer(),

          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isRetReqSelectionCommitted,
          ),
        ],
      ),
    );
  }
}