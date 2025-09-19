import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';

// Print Invoice Screen final view after dealer selection
class PrintInvoiceMainScreen extends StatefulWidget {
  final Dealer dealer;
  const PrintInvoiceMainScreen({super.key, required this.dealer});

  @override
  State<PrintInvoiceMainScreen> createState() => _PrintInvoiceMainScreenState();
}

class _PrintInvoiceMainScreenState extends State<PrintInvoiceMainScreen> {
  List<TinInvoice> _availableTins = [];
  final List<TinInvoice> _selectedTins = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadTinInvoices();
  }

  Future<void> loadTinInvoices() async {

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
   
    final filters = [
      ['dealerAccCode', '=', widget.dealer.accountCode],
    ];
    final encodedFilters = Uri.encodeComponent(jsonEncode(filters));
    final dataUrl = 'api/tin-invoices/list?filters=$encodedFilters';

    await inquire<TinInvoice>(
      context: context,
      dataUrl: dataUrl,
      onSuccess: (List<TinInvoice> data) {
        if (mounted) {
          setState(() {
            _availableTins = data;
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
      },
    );
  }

  void _onTinToggle(TinInvoice invoice) {
    setState(() {
      if (_selectedTins.contains(invoice)) {
        _selectedTins.remove(invoice);
      } else {
        _selectedTins.add(invoice);
      }
    });
  }

  void _onsubmit(){
              if (_selectedTins.isEmpty) {
                showSnackBar(
                  context: context,
                  message: "Please select at least one invoice to confirm.",
                  type: MessageType.warning,
                );
                return;
              }
              showSnackBar(
                context: context,
                message:
                    "Print Success! Confirmed ${_selectedTins.length} items.",
                type: MessageType.success,
              );
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // No top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          DealerInfoCard(dealer: widget.dealer),
          const SizedBox(height: 16),
          Expanded(child: _buildTinInvoiceArea()),
          const SizedBox(height: 16),
          _buildConfirmationBox(),
          const SizedBox(height: 20),
          ActionButton(
            icon: Icons.handshake_outlined,
            label: 'Agree (${_selectedTins.length})',
            onPressed: _onsubmit,
            disabled: _selectedTins.isEmpty,
          ),
        ],
      ),
    );
  }

  /// Builds the TIN invoice list area.
  Widget _buildTinInvoiceArea() {
    if (_isLoading) {
      return const Center(child: Text('Loading Invoices for the Dealer...'));
    }
    if (_availableTins.isEmpty || _errorMessage != null) {
      return const Center(
        child: Text('No outstanding TINs found for this dealer.'),
      );
    }
    return AppDataGrid<TinInvoice>(
      hasFilter: false, // <-- Hides the filter/search bar
      items: _availableTins,
      filterableFields: [],
      columns: [
        // Column 1: Invoice Number (using tinNo)
        DynamicColumn<TinInvoice>(
          label: 'Invoice Number',
          flex: 5,
          cellBuilder:
              (context, invoice) =>
              AutoSizeText(
                invoice.tinNo,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
        ),
        // Column 2: Invoice Amount
        DynamicColumn<TinInvoice>(
          label: 'Amount',
          flex: 3,
          cellBuilder:
              (context, invoice) => AutoSizeText(
                invoice.invAmount.toStringAsFixed(2),
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
        ),
        // Column 3: Selection Checkbox
        DynamicColumn<TinInvoice>(
          label: 'Confirm',
          flex: 2,
          cellBuilder:
              (context, invoice) => Center(
                child: Checkbox(
                  value: _selectedTins.contains(invoice),
                  activeColor: AppColors.primary,
                  checkColor: AppColors.white,
                  onChanged: (bool? value) {
                    _onTinToggle(invoice);
                  },
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildConfirmationBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: const Text(
        'Above all items were received in good condition',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
      ),
    );
  }
}
