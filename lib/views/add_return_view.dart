import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/tin_stat_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_option_picker.dart';
import 'package:myapp/widgets/app_quantity_selector.dart';
import 'package:myapp/widgets/app_radio_group.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/cards/info_card.dart';
import 'package:myapp/widgets/cards/tin_stats_card.dart';

// Final Step of Return screen after region/dealer/tin selections - Adds return request
class ReturnsView extends StatefulWidget {
  final Dealer dealer;
  final TinData tinData;
  final void Function(List<Part>, String, String) onSubmit; 

  const ReturnsView({
    super.key,
    required this.dealer,
    required this.tinData,
    required this.onSubmit,
  });

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  late List<Part> _items;
  List<Part> _selectedItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  double _pendingTotal = 0.0;

  String _selectedReturnType = 'Discrepancy Returns';
  String? _selectedReason;
  final List<String> _reasonOptions = [
    'LEAKAGES (PETROL/OIL)',
    'LOYALTY DISCOUNT',
    'MANUFACTURING DEFECT',
    'REFUND',
    'OTHERS',
    'Bead Failure - BF',
  ];

  @override
  void initState() {
    super.initState();
    _items = [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReturnItems());
  }

  Future<void> _loadReturnItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final parts = widget.tinData.parts;
      _items = parts.map((p) => p.copyWith()).toList();
      _selectedItems = [];
      _pendingTotal = _items.fold<double>(
        0.0,
        (sum, p) => sum + (p.requestQty * (p.price ?? 0)),
      );
    } catch (e) {
      _errorMessage = 'Failed to load parts';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _togglePartSelection(String partNo) async {
    final sourcePart = _items.firstWhere((p) => p.partNo == partNo);
    final isCurrentlySelected = _selectedItems.any((p) => p.partNo == partNo);

    if (isCurrentlySelected) {
      setState(() {
        _selectedItems.removeWhere((p) => p.partNo == partNo);
      });
      return;
    }

    final newQuantity = await showDialog<int>(
      context: context,
      builder: (context) => QuantityEditDialog(
        initialQuantity: sourcePart.requestQty,
        title: 'Return Quantity',
        maxQuantity: sourcePart.requestQty,
      ),
    );

    if (newQuantity != null && mounted) {
      final newSelectedPart = sourcePart.copyWith(receivedQty: sourcePart.requestQty - newQuantity);
      setState(() {
        _selectedItems.add(newSelectedPart);
      });
    }
  }

  Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SelectionModal(
        title: 'Reason',
        options: _reasonOptions,
        initialValue: _selectedReason,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedReason = result;
      });
    }
  }

  bool get isAnyItemSelected => _selectedItems.isNotEmpty;

  void _toggleSelectAll(bool? selected) {
    if (selected == null) return;
    setState(() {
      if (selected) {
        _selectedItems =
            _items.map((item) => item.copyWith(receivedQty: 0)).toList();
      } else {
        _selectedItems.clear();
      }
    });
  }

  Widget _buildItemsList() {
    if (_isLoading) {
      return const Center(child: Text("Loading items..."));
    }

    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }
    final isAllSelected = _selectedItems.length == _items.length && _items.isNotEmpty;
    return AppDataGrid<Part>(
      searchHintText: 'Search by Part No or Quantity',
      onFilterPressed: () {},
      filterableFields: const ['partNo', 'requestQty'],
      isAllSelected: isAllSelected,
      onSelectAllChanged: _toggleSelectAll,
      items: _items,
      columns: [
        DynamicColumn<Part>(
          label: 'Part No',
          flex: 3,
          cellBuilder:
              (context, part) => Text(
                part.partNo,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
        ),
        DynamicColumn<Part>(
          label: 'Request Qty',
          flex: 2,
          cellBuilder:
              (context, part) =>
                  Center(child: Text(part.requestQty.toString())),
        ),
        DynamicColumn<Part>(
          label: 'Select',
          flex: 2,
          cellBuilder: (context, part) => Center(
            child: Checkbox(
              value: _selectedItems.any((p) => p.partNo == part.partNo),
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              onChanged: (_) => _togglePartSelection(part.partNo),
            ),
          ),
        ),
        DynamicColumn<Part>(
          label: 'Return Qty',
          flex: 3,
          cellBuilder: (context, part) {
            final selectedPart =
                _selectedItems.firstWhereOrNull((p) => p.partNo == part.partNo);
            return QuantitySelector(
              value: selectedPart?.returnQty ?? 0,
              enabled: selectedPart != null,
              dialogTitle: 'Return Quantity',
              maxQuantity: part.requestQty,
              onChanged: (newValue) {
                setState(() {
                  final sp = selectedPart!;
                  final idx = _selectedItems.indexWhere((p) => p.partNo == sp.partNo);
                  if (idx != -1) {
                    _selectedItems[idx] = sp.copyWith(receivedQty: sp.requestQty - newValue);
                  }
                });
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DealerInfoCard(dealer: widget.dealer),
              const SizedBox(height: 12),
              InfoDisplay(info: widget.tinData.tinNumber),
              const SizedBox(height: 8),
              if (_pendingTotal > 0) ...[
                TinStatsCard(
                  stats: TinStat(approved: _items.length, totalPayment: _pendingTotal),
                  firstLabel: 'Pending Orders',
                  secondLabel: 'Pending Amount',
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),

              SizedBox(height: 250.0, child: _buildItemsList()),

              const SizedBox(height: 24),
              TitledRadioGroup(
                title: 'Return Type',
                options: const ['Field Returns', 'Discrepancy Returns'],
                selectedValue: _selectedReturnType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedReturnType = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              PickerFormField(
                headerLabelText: 'Reason',
                inputFieldLabelText: 'Select a reason',
                selectedOption: _selectedReason,
                onTap: _showReasonPicker,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Save',
            disabled: !isAnyItemSelected || _selectedReason == null,
            onPressed: () {
                  widget.onSubmit(_selectedItems,_selectedReturnType,_selectedReason!); // Pass _selectedParts here
                },
          ),
        ),
      ],
    );
  }
}
