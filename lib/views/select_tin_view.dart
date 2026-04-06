import 'package:flutter/material.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
// import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/cards/dealer_info_detail_card.dart';
import 'package:myapp/services/api_util_service.dart';
// import 'package:myapp/widgets/cards/tin_stats_card.dart';
import 'package:myapp/models/tin_stat_model.dart';

// TIN selection view shows after the dealer selection
class SelectTinNumberView extends StatefulWidget {
  final Dealer dealer;
  //final Function(TinData) onTinNumberSelected;
  final Function(TinData) onSubmit;
  final TinData? selectedTin;
  final TinStat? tinStat;

  const SelectTinNumberView({
    super.key,
    //required this.onTinNumberSelected,
    required this.onSubmit,
    required this.dealer,
    this.selectedTin,
    this.tinStat,
  });

  @override
  State<SelectTinNumberView> createState() => _SelectTinNumberViewState();
}

class _SelectTinNumberViewState extends State<SelectTinNumberView> {
  final TextEditingController _tinController = TextEditingController();
  bool _isTinSelectionCommitted = false;
  TinStat? _tinStat;
  TinData? _currentSelectedTin;

  @override
  void initState() {
    super.initState();
     _tinStat = widget.tinStat ?? const TinStat();
    if (widget.selectedTin != null) {
      _tinController.text = widget.selectedTin!.tinNumber;
      _currentSelectedTin = widget.selectedTin!;
      _isTinSelectionCommitted = true;
    }
    //_loadTinCounts();
  }

  // Future<void> _loadTinCounts() async {
  //   await inquire<TinData>(
  //     context: context,
  //     dataUrl: 'tins/list',
  //     filters: {'dealerCode': widget.dealer.accountCode},
  //     onSuccess: (List<TinData> data) {
  //       if (!mounted) return;
  //       setState(() {
  //         _tinStat = TinStat.fromTinList(data);
  //       });
  //     },
  //     onError: (String message) {
  //       if (!mounted) return;
  //       setState(() {
  //         if (message.contains('No data found')) {
  //           _tinStat = const TinStat();
  //         } else {
  //           _tinStat = TinStat(error: message);
  //         }
  //       });
  //     },
  //   );
  // }

  @override
  void didUpdateWidget(covariant SelectTinNumberView old) {
    super.didUpdateWidget(old);
    if (widget.selectedTin?.tinNumber != old.selectedTin?.tinNumber) {
      _tinController.text = widget.selectedTin?.tinNumber ?? '';
    }
  }

  void _onTinSubmitted() {
    if (_currentSelectedTin != null) {
      if (_currentSelectedTin?.paymentStatus == 'A') {
        widget.onSubmit(_currentSelectedTin!);
      } else {
        showSnackBar(
          context: context,
          message: 'Please Select Approved TIN !',
          type: MessageType.warning,
        );
        _tinController.clear();
        setState(() {
          _isTinSelectionCommitted = false;
        });
      }
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
          // Modified to use DealerInfoDetailCard by Darshan R on 06/04/2026
          // DealerInfoCard(dealer: widget.dealer),
          DealerInfoDetailCard(
            dealer: widget.dealer,
            firstLabel: 'Pending Invoices',
            firstValue: _tinStat?.approved.toString()?? '0',
            secondLabel: 'Pending Value',  
            secondValue: formatNumber(_tinStat?.totalPayment?? 0),
          ),
          const SizedBox(height: 16),

          // TinStatsCard(
          //   stats: _tinStat?? const TinStat(),
          //   firstLabel: 'Pending Invoices',
          //   secondLabel: 'Pending Value',
          // ),
          // const SizedBox(height: 12),

          AppSelectionField<TinData>(
            controller: _tinController,
            labelText: 'Select TIN Number',
            selectionSheetTitle: 'Select a TIN Number',
            layoutType:
                SelectionSheetLayoutType
                    .card, // Modified by Darshan R on 18/03/2026
            initialValue: widget.selectedTin,
            //onSelected: widget.onTinNumberSelected,
            onSelected: (tin) {
              setState(() {
                _currentSelectedTin = tin;
              });
            },
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isTinSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['TIN Number', 'Total Value', 'Payment Status'],
            valueFields: const ['tinNumber', 'totalValue', 'paymentStatus'],
            mainField: 'tinNumber',
            dataUrl: 'tins/list',
            filterConditions: [
              ['dealerCode', '=', widget.dealer.accountCode],
            ],
            // added color rule for payment status by Darshan R on 10/03/2026
            colorRules: [
              DataHelperColorRule<TinData>(
                shouldColor: (t) => true,
                startColumnIndex: 0,
                endColumnIndex: 2,
                coloredCellBuilder: (ctx, t) => Text(t.tinNumber),
                decorationBuilder:
                    (ctx, t) => BoxDecoration(color: t.paymentStatusColor),
              ),
            ],
          ),

          const Spacer(),

          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: _onTinSubmitted,
            disabled: !_isTinSelectionCommitted,
          ),
        ],
      ),
    );
  }
}
