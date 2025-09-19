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
//import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

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
  //final ValueChanged<String> onTinTextChanged;
  final ValueChanged<String> onBranchTextChanged;
  //final ValueChanged<TinData> onTinSelected;
  final ValueChanged<Bank> onBankSelected;
  final ValueChanged<BankBranch> onBranchSelected;
  final ValueChanged<DateTime?> onDateSelected;
  // final ValueChanged<bool> onTinCommitChanged;
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
  // --- The child's state is now ONLY for things purely related to the child's UI ---
  final _formKey = GlobalKey<FormState>();
  bool _isChildFormValid = false;

  // --- State for loading TIN invoices ---
  bool _isLoading = true;
  String? _errorMessage;
  List<TinInvoice> _availableTins = [];

  @override
  void initState() {
    super.initState();
    loadTinInvoices();
    // Schedule a validation check to run immediately after the widget is built.
    // This ensures that when a user navigates back to this screen with
    // pre-filled data, the form's validity and the submit button's state
    // are correctly evaluated right away.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Good practice to check if the widget is still in the tree
        _validateChildForm();
      }
    });
  }

  // NO CONTROLLERS, NO INITSTATE, NO DISPOSE, NO DIDUPDATEWIDGET NEEDED FOR STATE SYNC

  void _validateChildForm() {
    // We still need local validation for fields like amount format
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

    // Create the filter condition
    final filters = [
      ['dealerAccCode', '=', widget.dealer.accountCode],
    ];
    // Encode the filter to be URL-safe
    final encodedFilters = Uri.encodeComponent(jsonEncode(filters));
    final dataUrl = 'api/tin-invoices/list?filters=$encodedFilters';

    await inquire<TinInvoice>(
      context: context,
      dataUrl: dataUrl,
      onSuccess: (List<TinInvoice> data) {
        if (mounted) {
          setState(() {
            // CORRECTED: No longer filtering by receiptStatus here.
            // All TINs for the dealer will be shown. The checkbox in the UI
            // will handle the current selection state.
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
    // This now reads directly from the parent's state object via the widget property
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
      height: 250, // Constrain the height of the list
      child: AppDataGrid<TinInvoice>(
        // Updated search hint to include more fields
        searchHintText: 'Search by TIN, Mobile Inv, or Amount',
        onFilterPressed: () {},
        // Added mobileInvNo to the searchable fields
        filterableFields: const ['tinNo', 'mobileInvNo', 'invAmount'],
        items: _availableTins,
        columns: [
          // Column 1: TIN No
          DynamicColumn<TinInvoice>(
            label: 'TIN No',
            flex: 1, // Flex set to 1 for even distribution
            cellBuilder:
                (context, invoice) => Padding(
                  // Use EdgeInsets.only to specify a single side
                  padding: const EdgeInsets.only(right: 3.0), // Right padding
                  child: AutoSizeText(
                    invoice.tinNo,
                    style: const TextStyle(fontSize: 12),
                    minFontSize: 8, // Prevent text from becoming too small
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
          // Column 2: Mobile Inv No
          DynamicColumn<TinInvoice>(
            label: 'Mobile Inv No',
            flex: 1, // Flex set to 1 for even distribution
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
          // Column 3: Inv. Amount
          DynamicColumn<TinInvoice>(
            label: 'Inv. Amount',
            flex: 1, // Flex set to 1 for even distribution
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
          // Column 4: Payment On Delivery Status
          DynamicColumn<TinInvoice>(
            label: 'POD Status',
            flex: 1, // Flex set to 1 for even distribution
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
          // Column 5: Receipt Status (Checkbox)
          DynamicColumn<TinInvoice>(
            label: 'Receipt Status',
            flex: 1, // Flex set to 1 for even distribution
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
    // --- WIDGET LOGIC WITH UPDATED COLUMNS ---
    // return SizedBox(
    //   height: 250, // Constrain the height of the list
    //   child: AppDataGrid<TinInvoice>(
    //     // Updated search hint to include more fields
    //     searchHintText: 'Search by TIN, Mobile Inv, or Amount',
    //     onFilterPressed: () {},
    //     // Added mobileInvNo to the searchable fields
    //     filterableFields: const ['tinNo', 'mobileInvNo', 'invAmount'],
    //     items: _availableTins,
    //     columns: [
    //       // Column 1: TIN No
    //       DynamicColumn<TinInvoice>(
    //         label: 'TIN No',
    //         flex: 4,
    //         cellBuilder:
    //             (context, invoice) => Text(
    //               invoice.tinNo,
    //               style: const TextStyle(fontSize: 12),
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //       ),
    //       // Column 2: Mobile Inv No (NEW)
    //       DynamicColumn<TinInvoice>(
    //         label: 'Mobile Inv No',
    //         flex: 4,
    //         cellBuilder:
    //             (context, invoice) => Text(
    //               invoice.mobileInvNo,
    //               style: const TextStyle(fontSize: 12),
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //       ),
    //       // Column 3: Inv. Amount
    //       DynamicColumn<TinInvoice>(
    //         label: 'Inv. Amount',
    //         flex: 3,
    //         cellBuilder:
    //             (context, invoice) => Center(
    //               child: Text(
    //                 invoice.invAmount.toStringAsFixed(2),
    //                 style: const TextStyle(fontSize: 12),
    //               ),
    //             ),
    //       ),
    //       // Column 4: Payment On Delivery Status (NEW)
    //       DynamicColumn<TinInvoice>(
    //         label: 'POD Status', // Shortened for space
    //         flex: 4,
    //         cellBuilder:
    //             (context, invoice) => Center(
    //               child: Text(
    //                 invoice.paymentOnDeliveryStatus,
    //                 style: const TextStyle(
    //                   fontSize: 12,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //       ),
    //       // Column 5: Receipt Status (Checkbox)
    //       DynamicColumn<TinInvoice>(
    //         label: 'Receipt Status', // Renamed from "Select"
    //         flex: 2,
    //         cellBuilder:
    //             (context, invoice) => Center(
    //               child: Checkbox(
    //                 value: widget.selectedTins.contains(invoice),
    //                 activeColor: AppColors.primary,
    //                 checkColor: Colors.white,
    //                 onChanged: (bool? value) {
    //                   widget.onTinToggle(invoice);
    //                 },
    //               ),
    //             ),
    //       ),
    //     ],
    //   ),
    // );
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

              // AppSelectionField<TinData>(  // Removed Temporary This was for selecting single App
              //   // USE THE PASSED-IN CONTROLLER
              //   controller: widget.tinController,
              //   labelText: 'Select TIN Number',
              //   selectionSheetTitle: 'Select a TIN Number',
              //   initialValue: widget.selectedTin,
              //   onChanged: widget.onTinTextChanged,
              //   onSelected: widget.onTinSelected,
              //   onCommitStateChanged: widget.onTinCommitChanged,
              //   displayNames: const ['TIN Number', 'Total Value'],
              //   valueFields: const ['tinNumber', 'totalValue'],
              //   mainField: 'tinNumber',
              //   dataUrl: 'api/tins/list',
              //   // ...
              // ),
              //const SizedBox(height: 16),
              ActionButton(
                label: 'Add Credit Note',
                icon: Icons.add_card,
                onPressed: widget.addCreditnote,
                color: AppColors.success,
                disabled: !widget.dealer.hasBankGuarantee,
              ),
              const SizedBox(height: 16),
              AppTextField(
                // USE THE PASSED-IN CONTROLLER
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
                // USE THE PASSED-IN CONTROLLER
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
                // USE THE PASSED-IN CONTROLLER
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
                // USE THE PASSED-IN CONTROLLER
                controller: widget.amountController,
                labelText: 'Amount',
                keyboardType: TextInputType.number,
                isFinanceNum: true,
                // The amount controller needs a listener in the parent to trigger validation
                // or just pass a generic onChanged callback if you don't have one
                onChanged: (value) {
                  _validateChildForm(); // Local form validation still happens
                },
              ),
              const SizedBox(height: 48),
              ActionButton(
                label: 'Submit',
                icon: Icons.check_circle_outline,
                onPressed: widget.onSubmit,
                // The parent's validation flag + the child's local validation flag
                disabled: !widget.isFormValid || !_isChildFormValid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
