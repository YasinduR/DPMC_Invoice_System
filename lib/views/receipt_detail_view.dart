import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/app_image_upload_field.dart';
import 'package:myapp/widgets/app_radio_group.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
import 'package:myapp/widgets/app_text_form_field.dart';

// Main View of Receipt Screen
// Main View of Receipt Screen
class ReceiptDetailsView extends StatefulWidget {
  final Dealer dealer;
  final VoidCallback onSubmit;
  final double usableAmount;

  // --- RECEIVE CONTROLLERS FROM PARENT ---
  final TextEditingController chequeNoController;
  final TextEditingController chequeNoConfirmController;
  final TextEditingController amountController;
  final TextEditingController claimedAmountController;
  final TextEditingController tinController;
  final TextEditingController bankController;
  final TextEditingController branchController;

  // Data for read-only purposes (like filtering)
  final TinData? selectedTin;
  final Bank? selectedBank;
  final BankBranch? selectedBranch;
  final DateTime? selectedChequeDate;
  final String? selectedPODstatus;
  final File? selectedImage;
  final bool isFormValid;

  // --- MULTI-TIN SELECTION ---
  final List<TinInvoice> selectedTins;
  final void Function(List<TinInvoice>, bool) toggleAll;

  // Callbacks
  final ValueChanged<String> onBankTextChanged;
  final ValueChanged<String> onBranchTextChanged;
  final ValueChanged<String> onClaimedAmountChanged;
  final ValueChanged<Bank> onBankSelected;
  final ValueChanged<TinInvoice> onTinToggle;
  final ValueChanged<BankBranch> onBranchSelected;
  final ValueChanged<File?> onFileChanged;
  final ValueChanged<DateTime?> onDateSelected;
  final ValueChanged<bool> onBankCommitChanged;
  final ValueChanged<bool> onBranchCommitChanged;
  final ValueChanged<String> onPodStatusToggle;

  const ReceiptDetailsView({
    super.key,
    required this.dealer,
    required this.onSubmit,
    required this.usableAmount,

    // Require controllers
    required this.chequeNoController,
    required this.chequeNoConfirmController,
    required this.amountController,
    required this.claimedAmountController,
    required this.tinController,
    required this.bankController,
    required this.branchController,
    required this.selectedTins,
    required this.onTinToggle,
    required this.toggleAll,
    required this.onPodStatusToggle,

    this.selectedTin,
    this.selectedBank,
    this.selectedBranch,
    this.selectedPODstatus,
    this.selectedChequeDate,
    this.selectedImage,
    required this.isFormValid,
    // required this.onTinSelected,
    required this.onBankSelected,
    required this.onBranchSelected,
    required this.onDateSelected,
    // required this.onTinCommitChanged,
    required this.onBankCommitChanged,
    required this.onBranchCommitChanged,
    required this.onBankTextChanged,
    required this.onClaimedAmountChanged,
    //required this.onTinTextChanged,
    required this.onBranchTextChanged,
    required this.onFileChanged,
    String? selectedPODStatus,
  });

  @override
  State<ReceiptDetailsView> createState() => ReceiptDetailsViewState();
}

class ReceiptDetailsViewState extends State<ReceiptDetailsView> {
  final _formKey = GlobalKey<FormState>();
  bool _isChildFormValid = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<TinInvoice> _availableTins = [];
  //File? _uploadedImage;

  @override
  void initState() {
    super.initState();
    loadTinInvoices();
    //_uploadedImage = widget.selectedImage;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _validateChildForm();
      }
    });
  }

  // @override
  // void didUpdateWidget(ReceiptDetailsView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.selectedPODstatus != widget.selectedPODstatus) {
  //     loadTinInvoices(status: widget.selectedPODstatus);
  //   }
  // }

  void _validateChildForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isChildFormValid) {
      setState(() {
        _isChildFormValid = isValid;
      });
    }
  }

  /// Fetches the list of TIN invoices for the specific dealer.
  Future<void> loadTinInvoices({String? status}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final statusToUse =
        status ?? widget.selectedPODstatus?.substring(0, 1) ?? 'Y';

    final filters = [
      ['dealerAccCode', '=', widget.dealer.accountCode],
      ['paymentOnDeliveryStatus', '=', statusToUse],
    ];
    final encodedFilters = Uri.encodeComponent(jsonEncode(filters));
    final dataUrl = 'tin-invoices/list?filters=$encodedFilters';

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
    final isAllSelected =
        widget.selectedTins.length == _availableTins.length &&
        _availableTins.isNotEmpty;
    return SizedBox(
      height: 250,
      child: AppDataGrid<TinInvoice>(
        isAllSelected: isAllSelected,
        onSelectAllChanged: (value) {
          if (value != null) {
            widget.toggleAll(_availableTins, value);
          }
        },
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
                    formatNumber(invoice.invAmount),
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
              TitledRadioGroup(
                title: 'Payment On Delivery',
                options: const ['Yes', 'No'],
                selectedValue: widget.selectedPODstatus ?? 'Yes',
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      if (value == 'Yes') {
                        loadTinInvoices(status: 'Y');
                      } else {
                        loadTinInvoices(status: 'N');
                      }
                      widget.onPodStatusToggle(value);
                    });
                    //
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildTinInvoiceArea(),
              const SizedBox(height: 16),
              // ActionButton(
              //   label: 'Add Credit Note',
              //   icon: Icons.add_card,
              //   onPressed: widget.addCreditnote,
              //   type: ActionButtonType.tertiary,
              //   disabled: !widget.dealer.hasBankGuarantee,
              // ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(
                        'usable_${widget.usableAmount.toStringAsFixed(2)}',
                      ),
                      initialValue: formatNumber(widget.usableAmount),
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Usable Amount',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: widget.claimedAmountController,
                      labelText: 'Claimed Amount',
                      keyboardType: TextInputType.number,
                      isFinanceNum: true,
                      onChanged: (value) {
                        widget.onClaimedAmountChanged(value);
                        _validateChildForm();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        final claimedAmount = parseCurrency(value);
                        if (claimedAmount > 5000.0) {
                          return 'Claimed amount cannot exceed 5000';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                    //keyboardType: TextInputType.number,
                    //keyboardType
                    controller: widget.chequeNoController,
                    isDigitOnly: true,
                    maxLength: 6,
                    errorMaxLines: 2,
                    labelText: 'Cheque Number',
                    onChanged: (value) {
                      _validateChildForm();
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return null;
                      }
                      if (widget.chequeNoController.text.length < 6) {
                        return 'Cheque number must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  ),
                  const SizedBox(width: 12), // spacing between fields
                  Expanded(
                    child: AppTextField(
                    isDigitOnly: true,
                    maxLength: 6,
                    controller: widget.chequeNoConfirmController,
                    labelText: 'Confirm Cheque No.',
                    errorMaxLines: 2,
                    onChanged: (value) {
                      _validateChildForm();
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return null;
                      }
                      if (value != widget.chequeNoController.text) {
                        return 'Cheque numbers do not match';
                      }
                      return null;
                    },
                    ),
                    ),
                  ],
              ),
              // AppTextField(
              //   controller: widget.chequeNoController,
              //   labelText: 'Cheque No.',
              //   onChanged: (value) {
              //     _validateChildForm();
              //   },
              // ),
              // const SizedBox(height: 16),
              // AppTextField(
              //   controller: widget.chequeNoConfirmController,
              //   labelText: 'Cheque No. Confirm',
              //   onChanged: (value) {
              //     _validateChildForm();
              //   },
              //   validator: (value) {
              //     if (value?.isEmpty ?? true) {
              //       return null;
              //     }
              //     if (value != widget.chequeNoController.text) {
              //       return 'Cheque Nos do not match';
              //     }
              //     return null;
              //   },
              // ),
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
                displayNames: const ['Bank Name', 'BankCode'],
                valueFields: const ['bankName', 'bankCode'],
                mainField: 'bankName',
                dataUrl: 'bank/list',
                layoutType: SelectionSheetLayoutType.card,
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
                displayNames: const ['Branch Name', 'Branch code'],
                valueFields: const ['branchName', 'branchCode'],
                mainField: 'branchName',
                dataUrl: 'branch/list',
                preRequest: _handlePreRequestBank,
                filterConditions:
                    widget.selectedBank != null
                        ? [
                          ['bankCode', '=', widget.selectedBank!.bankCode],
                        ]
                        : [],
                layoutType: SelectionSheetLayoutType.card,
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
              const SizedBox(height: 16),
              ImageUploadField(
                label: 'Upload Receipt Image', 
                onImageSelected: (file) {
                  //_uploadedImage = file;
                  widget.onFileChanged(file); 
                }, 
                selectedImage: widget.selectedImage,
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
