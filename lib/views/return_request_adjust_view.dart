import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/return_request_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_quantity_selector.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/cards/info_card.dart';

// Final view of Invoice Screen Shows after Dealer TIN selections
class ReturnRequestView extends StatefulWidget {
  final Dealer dealer;
  final ReturnRequest returnReq;
  final void Function(List<ReturnItem>) onSubmit;

  const ReturnRequestView({
    super.key,
    required this.dealer,
    required this.returnReq,
    required this.onSubmit,
  });

  @override
  State<ReturnRequestView> createState() => _ReturnRequestViewState();
}

class _ReturnRequestViewState extends State<ReturnRequestView> {
  List<ReturnItem> _items = [];
  List<ReturnItem> _modifiedItems = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadParts());
  }

  @override
  void dispose() {
    super.dispose();
  }

// Check whether existing items and modified items are equal
  bool _areReturnItemsEqual(List<ReturnItem> listA, List<ReturnItem> listB) {
    if (listA.length != listB.length) {
      return false; 
    }
    final Map<String, int> mapA = {
      for (var item in listA) item.partNo: item.returnQty
    };
    for (var itemB in listB) {
      if (!mapA.containsKey(itemB.partNo)) {
        return false;
      }
      if (mapA[itemB.partNo] != itemB.returnQty) {
        return false; 
      }
    }
    return true;
  }


  void _onSubmit() {
    if (_areReturnItemsEqual(_items, _modifiedItems)) {
      showSnackBar(
        context: context,
        message: 'Please Adjust Return Items Before Submit',
        type: MessageType.error,
      );
    } else {
      widget.onSubmit(_modifiedItems);
    }
  }

  void _loadParts() {
    try {
      setState(() {
        _items = widget.returnReq.returnItems;
        _modifiedItems =
            widget.returnReq.returnItems
                .map(
                  (item) => ReturnItem(
                    partNo: item.partNo,
                    returnQty: item.returnQty,
                    requestQty: item.requestQty,
                  ),
                )
                .toList();
        if (_items.isEmpty) {
          _errorMessage = 'No Data Found';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Widget _buildPartList() {
    if (_isLoading) {
      return const Center(child: Text("Loading parts..."));
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage ?? ' An Error Occured'));
    }

    return AppDataGrid<ReturnItem>(
      searchHintText: 'Search by Part No',
      onFilterPressed: () {},
      filterableFields: ['partNo'],
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
          label: 'Return Qty',
          flex: 2,
          cellBuilder:
              (context, part) => Center(child: Text(part.returnQty.toString())),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Modified Return Qty',
          flex: 3,
          cellBuilder: (context, part) {
            final selectedItem = _modifiedItems.firstWhereOrNull(
              (p) => p.partNo == part.partNo,
            );
            return QuantitySelector(
              value: selectedItem?.returnQty ?? 0,
              enabled: selectedItem != null,
              dialogTitle: 'New Return Quantity',
              maxQuantity: part.requestQty,
              minQuantity: 0,
              onChanged: (newValue) {
                setState(() => selectedItem!.returnQty = newValue);
              },
            );
          },
        ),
      ],
      items: _items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool noChanges = _areReturnItemsEqual(_items, _modifiedItems);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DealerInfoCard(dealer: widget.dealer),
              const SizedBox(height: 12),
              InfoDisplay(info: widget.returnReq.returnId),
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
              const SizedBox(height: 16),
              ActionButton(
                icon: Icons.check_circle_outline,
                label: 'Update',
                disabled: noChanges,
                onPressed: _onSubmit,
                // onPressed: () {
                //   widget.onSubmit(_modifiedItems); // Pass _selectedItems here
                // },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
