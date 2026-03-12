import 'package:flutter/material.dart';
//import 'package:collection/collection.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/app_data_grid.dart';


class SelectTinsView extends StatefulWidget {
  final Dealer dealer;
  final Function(List<TinData>) onSubmit;
  final List<TinData> tins;
  final TinsSelectionController controller; // Add controller

  const SelectTinsView({
    super.key,
    required this.dealer,
    required this.onSubmit,
    this.tins = const [],
    required this.controller,
  });

  @override
  State<SelectTinsView> createState() => _SelectTinsViewState();
}

class _SelectTinsViewState extends State<SelectTinsView> {
  final TextEditingController _tinController = TextEditingController();

  TinData? _selectedTin;

  late final List<TinData> _addedTins;
  
  //late final List<TinData> _tins;

  bool _isTinSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    // Register the reset callback with the controller
    widget.controller.registerResetCallback(_reset);
    _addedTins = List<TinData>.from(widget.tins);
    //_tins = List<TinData>.from(widget.tins);
  }

   // Private reset method
  void _reset() {
    setState(() {
      _addedTins.clear();
      _selectedTin = null;
      _tinController.clear();
      _isTinSelectionCommitted = false;
    });
  }

  void _onTinAdd() {
    if (_selectedTin == null) return;

    if (_selectedTin!.paymentStatus != 'A') {
      showSnackBar(
        context: context,
        message: 'Please Select Approved TIN !',
        type: MessageType.warning,
      );
      return;
    }

    // Prevent duplicates
    if (_addedTins.any((t) => t.tinNumber == _selectedTin!.tinNumber)) {
      showSnackBar(
        context: context,
        message: 'TIN already added!',
        type: MessageType.warning,
      );
      return;
    }

    setState(() {
      _addedTins.add(_selectedTin!);
      _selectedTin = null;
      _tinController.clear();
      _isTinSelectionCommitted = false;
    });

    FocusScope.of(context).unfocus();
  }

  void _removeTin(TinData tin) {
    setState(() {
      _addedTins.remove(tin);
    });
  }

  Widget _buildTinGrid() {
    return AppDataGrid<TinData>(
      items: _addedTins,
      hasFilter: false,
      noDataMessage: '',
      //searchHintText: 'Search by TIN Number',
      filterableFields: ['tinNumber'],
      columns: [
        DynamicColumn<TinData>(
          label: 'TIN Number',
          flex: 3,
          cellBuilder: (context, item) => Text(item.tinNumber),
        ),
        DynamicColumn<TinData>(
          label: 'Total Value',
          flex: 2,
          cellBuilder:
              (context, item) => Text(item.totalValue.toStringAsFixed(2)),
        ),
        DynamicColumn<TinData>(
          label: '',
          flex: 1,
          cellBuilder: (context, item) {

                return buildGridIconButton(
      onPressed: () => _removeTin(item),
      buttonType: IconButtonType.remove,

    );
            // return IconButton(
            //   icon: const Icon(Icons.close, color: Colors.grey),
            //   onPressed: () => _removeTin(item),
            // );
          },
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    await widget.onSubmit(_addedTins);
    // setState(() {
    //   _addedTins.clear();
    //   _selectedTin = null;
    //   _tinController.clear();
    //   _isTinSelectionCommitted = false;
    // });
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
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
                  onSelected: (tin) {
                    _selectedTin = tin;
                  },
                  onCommitStateChanged: (isCommitted) {
                    setState(() {
                      _isTinSelectionCommitted = isCommitted;
                    });
                  },
                  displayNames: const [
                    'TIN Number',
                    'Total Value',
                    'Payment Status',
                  ],
                  valueFields: const [
                    'tinNumber',
                    'totalValue',
                    'paymentStatus',
                  ],
                  mainField: 'tinNumber',
                  dataUrl: 'tins/list',
                  filterConditions: [
                    ['dealerCode', '=', widget.dealer.accountCode],
                  ],
                  // added color rule for payment status by Darshan R on 11/03/2026
                  colorRules: [
                    DataHelperColorRule<TinData>(
                      shouldColor: (t) => true,
                      startColumnIndex: 0,
                      endColumnIndex: 2,
                      coloredCellBuilder: (ctx, t) => Text(t.tinNumber),
                      decorationBuilder: (ctx, t) => BoxDecoration(
                            color:t.paymentStatusColor,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ActionButton(
                  icon: Icons.add,
                  label: 'Add TIN',
                  onPressed: _onTinAdd,
                  disabled: !_isTinSelectionCommitted,
                  type: ActionButtonType.tertiary,
                ),

                const SizedBox(height: 24),

                Expanded(child: _buildTinGrid()),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Proceed',
            onPressed: _onSubmit,
            disabled: _addedTins.isEmpty,
          ),
        ),
      ],
    );
  }
}



// Create a controller to manage the state externally
class TinsSelectionController {
  TinsSelectionController._privateConstructor();
  static final TinsSelectionController _instance = TinsSelectionController._privateConstructor();
  factory TinsSelectionController() => _instance;
  VoidCallback? _resetCallback;
  void registerResetCallback(VoidCallback callback) {
    _resetCallback = callback;
  }
  void reset() {
    _resetCallback?.call();
  }
  void dispose() {
    _resetCallback = null;
  }
}