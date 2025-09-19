import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_quantity_selector.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/cards/tin_info_card.dart';

// Final view of Invoice Screen Shows after Dealer TIN selections
class CreateInvoiceView extends StatefulWidget {
  final Dealer dealer;
  final TinData tindata;
  final VoidCallback onSubmit;

  const CreateInvoiceView({
    super.key,
    required this.dealer,
    required this.tindata,
    required this.onSubmit,
  });

  @override
  State<CreateInvoiceView> createState() => _CreateInvoiceViewState();
}

class _CreateInvoiceViewState extends State<CreateInvoiceView> {
  List<Part> _parts = [];
  List<Part> _selectedParts = [];
  bool _isLoading = true;
  String? _errorMessage;

  double get totalAmount {
    return _selectedParts.fold(
      0.0,
      (sum, part) => sum + (part.price * part.receivedQty),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadParts());
  }

  Future<void> _loadParts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await inquire<Part>(
      context: context,
      dataUrl: 'api/parts/list',
      onSuccess: (List<Part> data) {
        if (mounted) {
          setState(() {
            _parts = data;
            _isLoading = false;
          });
        }
      },
      onError: (String message) {
        if (mounted) {
          setState(() {
            _errorMessage = message;
            _isLoading = false;
          });
        }
        showSnackBar(
          context: context,
          message: _errorMessage!,
          type: MessageType.success,
        );
      },
    );
  }

  Widget _buildPartList() {
    if (_isLoading) {
      return const Center(child: Text("Loading parts..."));
    }

    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }

    return AppDataGrid<Part>(
      searchHintText: 'Search by Part No or ID',
      onFilterPressed: () {},
      filterableFields: ['partNo', 'id'],
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
          cellBuilder:
              (context, part) => Center(
                child: Checkbox(
                  value: _selectedParts.any((p) => p.id == part.id),
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) => _togglePartSelection(part.id),
                ),
              ),
        ),
        DynamicColumn<Part>(
          label: 'Receive Qty',
          flex: 3,
          cellBuilder: (context, part) {
            final selectedPart = _selectedParts.firstWhereOrNull(
              (p) => p.id == part.id,
            );
            return QuantitySelector(
              value: selectedPart?.receivedQty ?? 0,
              enabled:
                  selectedPart != null, 
              dialogTitle: 'Delivered Quantity',
              maxQuantity: part.requestQty,
              onChanged: (newValue) {
                setState(() => selectedPart!.receivedQty = newValue);
              },
            );
          },
        ),
      ],
      items: _parts,
    );
  }

  Future<void> _togglePartSelection(String partId) async {
    final sourcePart = _parts.firstWhere((p) => p.id == partId);
    final isCurrentlySelected = _selectedParts.any((p) => p.id == partId);

    if (isCurrentlySelected) {
      setState(() {
        _selectedParts.removeWhere((p) => p.id == partId);
      });
    } else {
      final newSelectedPart = sourcePart.copyWith(receivedQty: 1);
      setState(() {
        _selectedParts.add(newSelectedPart);
      });
      await _showQuantityDialog(newSelectedPart);
    }
  }

  Future<void> _showQuantityDialog(Part selectedPart) async {
    final newQuantity = await showDialog<int>(
      context: context,
      builder:
          (context) => QuantityEditDialog(
            initialQuantity: selectedPart.receivedQty,
            title: 'Delivered Quantity',
            maxQuantity: selectedPart.requestQty,
          ),
    );

    if (newQuantity != null && mounted) {
      setState(() {
        selectedPart.receivedQty = newQuantity;
      });
    }
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
              TinInfoDisplay(tinData: widget.tindata),
              const SizedBox(height: 12),
              SizedBox(height: 300.0, child: _buildPartList()),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTotalAmountSection(totalAmount),
              const SizedBox(height: 16),
              ActionButton(
                icon: Icons.check_circle_outline,
                label: 'Save',
                disabled: totalAmount == 0,
                onPressed: widget.onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmountSection(double totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          totalAmount.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}