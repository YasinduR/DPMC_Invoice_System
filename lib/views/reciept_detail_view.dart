import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/app_text_form_field.dart';


// Main View of Reciept Screen 
class RecieptDetailsView extends StatefulWidget {
  final Dealer dealer;
  final VoidCallback onSubmit;
  final VoidCallback addCreditnote;

  // --- RECEIVE CONTROLLERS FROM PARENT ---
  final TextEditingController chequeNoController;
  final TextEditingController amountController;
  final TextEditingController tinController;
  final TextEditingController bankController;
  final TextEditingController branchController;

  // Data for read-only purposes (like filtering)
  final TinData? selectedTin;
  final Bank? selectedBank;
  final BankBranch? selectedBranch;
  final DateTime? selectedChequeDate;
  final bool isFormValid;

  // --- MULTI-TIN SELECTION ---
  final List<TinInvoice> selectedTins;
  final ValueChanged<TinInvoice> onTinToggle;

  // Callbacks
  final ValueChanged<String> onBankTextChanged;
  final ValueChanged<String> onBranchTextChanged;
  final ValueChanged<Bank> onBankSelected;
  final ValueChanged<BankBranch> onBranchSelected;
  final ValueChanged<DateTime?> onDateSelected;
  final ValueChanged<bool> onBankCommitChanged;
  final ValueChanged<bool> onBranchCommitChanged;

  const RecieptDetailsView({
    super.key,
    required this.dealer,
    required this.onSubmit,
    required this.addCreditnote,

    // Require controllers
    required this.chequeNoController,
    required this.amountController,
    required this.tinController,
    required this.bankController,
    required this.branchController,
    required this.selectedTins,
    required this.onTinToggle,

    this.selectedTin,
    this.selectedBank,
    this.selectedBranch,
    this.selectedChequeDate,
    required this.isFormValid,
    // required this.onTinSelected,
    required this.onBankSelected,
    required this.onBranchSelected,
    required this.onDateSelected,
    // required this.onTinCommitChanged,
    required this.onBankCommitChanged,
    required this.onBranchCommitChanged,
    required this.onBankTextChanged,
    //required this.onTinTextChanged,
    required this.onBranchTextChanged,
  });

  @override
  State<RecieptDetailsView> createState() => RecieptDetailsViewState();
}

class RecieptDetailsViewState extends State<RecieptDetailsView> {
  final _formKey = GlobalKey<FormState>();
  bool _isChildFormValid = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<TinInvoice> _availableTins = [];

  @override
  void initState() {
    super.initState();
    loadTinInvoices();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _validateChildForm();
      }
    });
  }


  void _validateChildForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isChildFormValid) {
      setState(() {
        _isChildFormValid = isValid;
      });
    }
  }

  /// Fetches the list of TIN invoices for the specific dealer.
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

  Future<bool> _handlePreRequestBank() async {
    if (widget.selectedBank == null) {
      showInfoDialog(
        context: context,
        title: 'Select a Bank First',
        content: 'Please Select Bank.',
      );
      return false;
    }
    return true;
  }

  Widget _buildTinInvoiceArea() {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Text('Loading TIN Invoices for the Dealer ...'),
      );
    }
    if (_errorMessage != null || _availableTins.isEmpty) {
      return SizedBox(
        height: 100,
        child: Text('No outstanding TINs found for this dealer.'),
      );
    }
    return SizedBox(
      height: 250,
      child: AppDataGrid<TinInvoice>(
        searchHintText: 'Search by TIN, Mobile Inv, or Amount',
        onFilterPressed: () {},
        filterableFields: const ['tinNo', 'mobileInvNo', 'invAmount'],
        items: _availableTins,
        columns: [
          DynamicColumn<TinInvoice>(
            label: 'TIN No',
            flex: 1,
            cellBuilder:
                (context, invoice) => Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: AutoSizeText(
                    invoice.tinNo,
                    style: const TextStyle(fontSize: 12),
                    minFontSize: 8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
          DynamicColumn<TinInvoice>(
            label: 'Mobile Inv No',
            flex: 1,
            cellBuilder:
                (context, invoice) => Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: AutoSizeText(
                    invoice.mobileInvNo,
                    style: const TextStyle(fontSize: 12),
                    minFontSize: 8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
          DynamicColumn<TinInvoice>(
            label: 'Inv. Amount',
            flex: 1,
            cellBuilder:
                (context, invoice) => Center(
                  child: AutoSizeText(
                    invoice.invAmount.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 12),
                    minFontSize: 8,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
          DynamicColumn<TinInvoice>(
            label: 'POD Status',
            flex: 1,
            cellBuilder:
                (context, invoice) => Center(
                  child: Text(
                    invoice.paymentOnDeliveryStatus,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ),
          DynamicColumn<TinInvoice>(
            label: 'Receipt Status',
            flex: 1,
            cellBuilder:
                (context, invoice) => Center(
                  child: Checkbox(
                    value: widget.selectedTins.contains(invoice),
                    activeColor: AppColors.primary,
                    checkColor: AppColors.white,
                    onChanged: (bool? value) {
                      widget.onTinToggle(invoice);
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DealerInfoCard(dealer: widget.dealer),
              const SizedBox(height: 16),
              _buildTinInvoiceArea(),
              const SizedBox(height: 16),
              ActionButton(
                label: 'Add Credit Note',
                icon: Icons.add_card,
                onPressed: widget.addCreditnote,
                color: AppColors.success,
                disabled: !widget.dealer.hasBankGuarantee,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: widget.chequeNoController,
                labelText: 'Cheque No.',
              ),
              const SizedBox(height: 16),
              DatePickerField(
                labelText: 'Select Cheque Date',
                selectedDate: widget.selectedChequeDate,
                onDateSelected: widget.onDateSelected,
              ),
              const SizedBox(height: 16),
              AppSelectionField<Bank>(
                controller: widget.bankController,
                labelText: 'Select Bank',
                selectionSheetTitle: 'Select a Bank',
                initialValue: widget.selectedBank,
                onChanged: widget.onBankTextChanged,
                onSelected: widget.onBankSelected,
                onCommitStateChanged: widget.onBankCommitChanged,
                displayNames: const ['Bank Name'],
                valueFields: const ['bankName'],
                mainField: 'bankName',
                dataUrl: 'api/bank/list',
              ),
              const SizedBox(height: 16),
              AppSelectionField<BankBranch>(
                controller: widget.branchController,
                labelText: 'Select Branch',
                selectionSheetTitle: 'Select a Branch',
                initialValue: widget.selectedBranch,
                onChanged: widget.onBranchTextChanged,
                onSelected: widget.onBranchSelected,
                onCommitStateChanged: widget.onBranchCommitChanged,
                displayNames: const ['Branch Name', 'Bank Name'],
                valueFields: const ['branchName', 'bankName'],
                mainField: 'branchName',
                dataUrl: 'api/branch/list',
                preRequest: _handlePreRequestBank,
                filterConditions:
                    widget.selectedBank != null
                        ? [
                          ['bankCode', '=', widget.selectedBank!.bankCode],
                        ]
                        : [],
                // ...
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: widget.amountController,
                labelText: 'Amount',
                keyboardType: TextInputType.number,
                isFinanceNum: true,
                onChanged: (value) {
                  _validateChildForm();
                },
              ),
              const SizedBox(height: 48),
              ActionButton(
                label: 'Submit',
                icon: Icons.check_circle_outline,
                onPressed: widget.onSubmit,
                disabled: !widget.isFormValid || !_isChildFormValid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
