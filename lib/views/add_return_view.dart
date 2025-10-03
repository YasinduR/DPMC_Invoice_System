import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_option_picker.dart';
import 'package:myapp/widgets/app_radio_group.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/cards/tin_info_card.dart';

// Final Step of Return screen after region/dealer/tin selections - Adds return request
class ReturnsView extends StatefulWidget {
  final Dealer dealer;
  final TinData tinData;
  final VoidCallback onSubmit;

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
  
  List<ReturnItem> _items = []; // Initialize with an empty list
  bool _isLoading = true; // Flag to manage loading state
  String? _errorMessage; // To store any potential error message

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

    await inquire<ReturnItem>(
      context: context,
      dataUrl: 'api/return-items/list',
      onSuccess: (List<ReturnItem> data) {
        if (mounted) {
          setState(() {
            _items = data;
            _isLoading = false;
          });
        }
      },
      onError: (String message) {
        if (mounted) {
          setState(() {
            _errorMessage = message;
            _isLoading = false;

            showSnackBar(
              context: context,
              message: _errorMessage!,
              type: MessageType.success,
            );
          });
        }
      },
    );
  }

  void _togglePartSelection(String partNo) {
    setState(() {
      final part = _items.firstWhere((p) => p.partNo == partNo);
      part.isSelected = !part.isSelected;
    });
  }

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
    return _items.any((item) => item.isSelected);
  }

  Widget _buildItemsList() {
    if (_isLoading) {
      return const Center(child: Text("Loading items..."));
    }

    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }
    return AppDataGrid<ReturnItem>(
      searchHintText: 'Search by Part No or Quantity',
      onFilterPressed: () {},
      filterableFields: const ['partNo', 'requestQty'],
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
                child: Checkbox(
                  value: part.isSelected,
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) => _togglePartSelection(part.partNo),
                ),
              ),
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
              TinInfoDisplay(tinData: widget.tinData),
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
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ), 
          child: ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Save',
            disabled: !isAnyItemSelected || _selectedReason == null,
            onPressed: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}
