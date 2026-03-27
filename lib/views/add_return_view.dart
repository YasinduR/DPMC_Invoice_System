import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/tin_stat_model.dart';
import 'package:myapp/services/api_util_service.dart';
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
  final void Function(List<ReturnItem>, String, String) onSubmit;
  final List<Part>? pendingParts; // optional pending parts (from invoice flow)

  const ReturnsView({
    super.key,
    required this.dealer,
    required this.tinData,
    required this.onSubmit,
    this.pendingParts,
  });

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  List<ReturnItem> _items = [];
  List<ReturnItem> _selectedItems = []; // Initialize with an empty list
  bool _isLoading = true; // Flag to manage loading state
  String? _errorMessage; // To store any potential error message
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReturnItems());
  }

  Future<void> _loadReturnItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 1) If pendingParts is provided (coming from invoice flow), use them.
    if (widget.pendingParts != null && widget.pendingParts!.isNotEmpty) {
      final parts = widget.pendingParts!;
      final mapped = parts
          .map((p) => ReturnItem(partNo: p.partNo, requestQty: p.requestQty, returnQty: p.requestQty))
          .toList();
      final total = parts.fold<double>(0.0, (sum, p) => sum + (p.requestQty * (p.price ?? 0)));
      if (mounted) {
        setState(() {
          _items = mapped;
          _selectedItems = mapped.map((m) => m.copyWith(returnQty: m.requestQty)).toList();
          _pendingTotal = total;
          _isLoading = false;
        });
      }
      return;
    }

    // 2) If tinData already contains parts (direct return flow after TIN select), use them.
    if (widget.tinData.parts.isNotEmpty) {
      final parts = widget.tinData.parts;
      final mapped = parts
          .map((p) => ReturnItem(partNo: p.partNo, requestQty: p.requestQty, returnQty: p.requestQty))
          .toList();
      final total = parts.fold<double>(0.0, (sum, p) => sum + (p.requestQty * (p.price ?? 0)));
      if (mounted) {
        setState(() {
          _items = mapped;
          _selectedItems = mapped.map((m) => m.copyWith(returnQty: m.requestQty)).toList();
          _pendingTotal = total;
          _isLoading = false;
        });
      }
      return;
    }

    // 3) Fallback: load from generic return-items endpoint
    // await inquire<ReturnItem>(
    //   context: context,
    //   dataUrl: 'return-items/list',
    //   onSuccess: (List<ReturnItem> data) {
    //     if (mounted) {
    //       setState(() {
    //         _items = data;
    //         _isLoading = false;
    //       });
    //     }
    //   },
    //   onError: (String message) {
    //     if (mounted) {
    //       setState(() {
    //         _errorMessage = message;
    //         _isLoading = false;

    //         showSnackBar(
    //           context: context,
    //           message: _errorMessage!,
    //           type: MessageType.success,
    //         );
    //       });
    //     }
    //   },
    // );
  }

  Future<void> _togglePartSelection(String partNo) async {
    final sourcePart = _items.firstWhere((p) => p.partNo == partNo);
    final isCurrentlySelected = _selectedItems.any((p) => p.partNo == partNo);

    if (isCurrentlySelected) {
      setState(() {
        _selectedItems.removeWhere((p) => p.partNo == partNo);
      });
    } else {
      final newSelectedPart = sourcePart.copyWith(returnQty: 1);
      setState(() {
        _selectedItems.add(newSelectedPart);
      });
      await _showQuantityDialog(newSelectedPart);
    }
  }

  Future<void> _showQuantityDialog(ReturnItem selectedItem) async {
    final newQuantity = await showDialog<int>(
      context: context,
      builder:
          (context) => QuantityEditDialog(
            initialQuantity: selectedItem.returnQty,
            title: 'Return Quantity',
            maxQuantity: selectedItem.requestQty,
          ),
    );

    if (newQuantity != null && mounted) {
      setState(() {
        selectedItem.returnQty = newQuantity;
      });
    }
  }

  void _toggleSelectAll(bool? selected) {
  if (selected == null) return;
  setState(() {
    if (selected) {
      _selectedItems = _items.map((item) => item.copyWith(returnQty: item.requestQty)).toList();
    } else {
      _selectedItems.clear();
    }
  });
}

  // void _togglePartSelection(String partNo) {
  //   setState(() {
  //     final part = _items.firstWhere((p) => p.partNo == partNo);
  //     part.isSelected = !part.isSelected;
  //   });
  // }

  Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SelectionModal(
            title: 'Reason',
            options: _reasonOptions,
            initialValue: _selectedReason,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedReason = result;
      });
    }
  }

  bool get isAnyItemSelected {
    //return _items.any((item) => item.isSelected);
    return _selectedItems.isNotEmpty;
  }

  Widget _buildItemsList() {
    if (_isLoading) {
      return const Center(child: Text("Loading items..."));
    }

    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }
    final isAllSelected = _selectedItems.length == _items.length && _items.isNotEmpty;
    return AppDataGrid<ReturnItem>(
      searchHintText: 'Search by Part No or Quantity',
      onFilterPressed: () {},
      filterableFields: const ['partNo', 'requestQty'],
      isAllSelected:isAllSelected,
      onSelectAllChanged:_toggleSelectAll,
      items: _items,
      columns: [
        DynamicColumn<ReturnItem>(
          label: 'Part No',
          flex: 3,
          cellBuilder:
              (context, part) => Text(
                part.partNo,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Request Qty',
          flex: 2,
          cellBuilder:
              (context, part) =>
                  Center(child: Text(part.requestQty.toString())),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Select',
          flex: 2,
          cellBuilder:
              (context, part) => Center(
                // child: Checkbox(
                //   value: part.isSelected,
                //   activeColor: AppColors.primary,
                //   checkColor: Colors.white,
                //   onChanged: (value) => _togglePartSelection(part.partNo),
                // ),
                child: Checkbox(
                  value: _selectedItems.any((p) => p.partNo == part.partNo),
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) => _togglePartSelection(part.partNo),
                ),
              ),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Return Qty',
          flex: 3,
          cellBuilder: (context, part) {
            final selectedPart = _selectedItems.firstWhereOrNull(
              (p) => p.partNo == part.partNo,
            );
            return QuantitySelector(
              value: selectedPart?.returnQty ?? 0,
              enabled: selectedPart != null,
              dialogTitle: 'Return Quantity',
              maxQuantity: part.requestQty,
              onChanged: (newValue) {
                setState(() => selectedPart!.returnQty = newValue);
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
