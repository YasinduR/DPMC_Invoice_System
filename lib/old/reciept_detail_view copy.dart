// import 'package:flutter/material.dart';
// import 'package:myapp/models/bank_branch_model.dart';
// import 'package:myapp/models/bank_model.dart';
// import 'package:myapp/models/dealer_model.dart';
// import 'package:myapp/models/tin_model.dart';
// import 'package:myapp/theme/app_theme.dart';
// import 'package:myapp/util/dialog_box.dart';
// import 'package:myapp/widgets/action_button.dart';
// import 'package:myapp/widgets/app_help_text_field.dart';
// import 'package:myapp/widgets/date_picker_field.dart';
// import 'package:myapp/widgets/dealer_info_card.dart';
// import 'package:myapp/widgets/text_form_field.dart';

// // class RecieptDetailsView extends StatefulWidget {
// //    // final GlobalKey<FormState> formKey;

// //   //final ValueChanged<bool> onValidationChanged;
// //   final Dealer dealer;
// //   final VoidCallback onSubmit;
// //   final VoidCallback addCreditnote;

// //   // Controllers from parent
// //   final TextEditingController chequeNoController;
// //   final TextEditingController amountController;
// //   final TextEditingController tinController;
// //   final TextEditingController bankController;
// //   final TextEditingController branchController;

// //   // State values from parent
// //   final TinData? selectedTin;
// //   final Bank? selectedBank;
// //   final BankBranch? selectedBranch;
// //   final DateTime? selectedChequeDate;
// //   // final bool isTinSelectionCommitted;
// //   // final bool isBankSelectionCommitted;
// //   // final bool isBranchSelectionCommitted;
// //   final bool isFormValid;

// //   // Callbacks to update parent state
// //   final ValueChanged<TinData> onTinSelected;
// //   final ValueChanged<Bank> onBankSelected;
// //   final ValueChanged<BankBranch> onBranchSelected;
// //   final ValueChanged<DateTime?> onDateSelected;
// //   final ValueChanged<bool> onTinCommitChanged;
// //   final ValueChanged<bool> onBankCommitChanged;
// //   final ValueChanged<bool> onBranchCommitChanged;

// //   const RecieptDetailsView({
// //     super.key,
// //     //required this.onValidationChanged, // Add to constructor
// //     required this.dealer,
// //     required this.onSubmit,
// //     required this.addCreditnote,
// //     required this.chequeNoController,
// //     required this.amountController,
// //     required this.tinController,
// //     required this.bankController,
// //     required this.branchController,
// //     this.selectedTin,
// //     this.selectedBank,
// //     this.selectedBranch,
// //     this.selectedChequeDate,
// //     // required this.isTinSelectionCommitted,
// //     // required this.isBankSelectionCommitted,
// //     // required this.isBranchSelectionCommitted,
// //     required this.isFormValid,
// //     required this.onTinSelected,
// //     required this.onBankSelected,
// //     required this.onBranchSelected,
// //     required this.onDateSelected,
// //     required this.onTinCommitChanged,
// //     required this.onBankCommitChanged,
// //     required this.onBranchCommitChanged
// //   });

// //   @override
// //   State<RecieptDetailsView> createState() => _RecieptDetailsViewState();
// // }

// // class _RecieptDetailsViewState extends State<RecieptDetailsView> {
// //   // --- ALL STATE HAS BEEN REMOVED FROM HERE ---
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isChildFormValid= false;
// //   //= _formKey.currentState?.validate() ?? false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // The parent now handles initializing controllers and adding listeners.
// //     // This initState can often be removed unless you have other local, non-data state.

// //     // If you need to populate controllers from initial widget values, do it here.
// //     if (widget.selectedTin != null && widget.tinController.text.isEmpty) {
// //       widget.tinController.text = widget.selectedTin!.tinNumber;
// //     }
// //     if (widget.selectedBank != null && widget.bankController.text.isEmpty) {
// //       widget.bankController.text = widget.selectedBank!.bankName;
// //     }
// //     if (widget.selectedBranch != null && widget.branchController.text.isEmpty) {
// //       widget.branchController.text = widget.selectedBranch!.branchName;
// //     }

// //     widget.chequeNoController.addListener(_validateChildForm);
// //     widget.amountController.addListener(_validateChildForm);
// //   }

// //     void _validateChildForm() {
// //     _isChildFormValid = _formKey.currentState?.validate() ?? false;
// //    // widget.onValidationChanged(isChildFormValid);
// //   }

// //   Future<bool> _handlePreRequestBank() async {
// //     if (widget.selectedBank == null) {
// //       // Use widget.selectedBank
// //       showInfoDialog(
// //         context: context,
// //         title: 'Select a Bank First',
// //         content: 'Please Select Bank.',
// //       );
// //       return false;
// //     }
// //     return true;
// //   }

// //   // --- _validateForm and _onBankTextChanged have been moved to the parent ---

// //   // --- dispose is also simplified as the parent now owns the controllers ---
// //   @override
// //   void dispose() {
// //     // Parent handles disposal of controllers.
// //     super.dispose();
// //         widget.chequeNoController.removeListener(_validateChildForm);
// //     widget.amountController.removeListener(_validateChildForm);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Form(
// //       key: _formKey,
// //       autovalidateMode: AutovalidateMode.onUserInteraction, // For real-time feedback
// //       child:SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             DealerInfoCard(dealer: widget.dealer),
// //             const SizedBox(height: 12),
// //             AppSelectionField<TinData>(
// //               controller: widget.tinController, // Use widget.tinController
// //               labelText: 'Select TIN Number',
// //               selectionSheetTitle: 'Select a TIN Number',
// //               initialValue: widget.selectedTin,
// //               onSelected: widget.onTinSelected, // Use callback
// //               onCommitStateChanged: widget.onTinCommitChanged, // Use callback
// //               displayNames: const ['TIN Number', 'Total Value'],
// //               valueFields: const ['tinNumber', 'totalValue'],
// //               mainField: 'tinNumber',
// //               dataUrl: 'api/tins/list',
// //             ),
// //             const SizedBox(height: 12),
// //             ActionButton(
// //               label: 'Add Credit Note',
// //               icon: Icons.add_card,
// //               onPressed: widget.addCreditnote,
// //               color: AppColors.success,
// //               disabled: !widget.dealer.hasBankGuarantee,
// //             ),
// //             const SizedBox(height: 16),
// //             AppTextField(
// //               controller:
// //                   widget.chequeNoController, // Use controller from widget
// //               labelText: 'Cheque No.',
// //             ),
// //             const SizedBox(height: 16),
// //             DatePickerField(
// //               labelText: 'Cheque Date',
// //               selectedDate: widget.selectedChequeDate, // Use value from widget
// //               onDateSelected: widget.onDateSelected, // Use callback from widget
// //             ),
// //             const SizedBox(height: 16),
// //             AppSelectionField<Bank>(
// //               controller: widget.bankController, // Use widget.bankController
// //               labelText: 'Select Bank',
// //               selectionSheetTitle: 'Select a Bank',
// //               initialValue: widget.selectedBank,
// //               onSelected: widget.onBankSelected, // Use callback
// //               onCommitStateChanged: widget.onBankCommitChanged,
// //               displayNames: const ['Bank Name'],
// //               valueFields: const ['bankName'],
// //               mainField: 'bankName',
// //               dataUrl: 'api/bank/list', // Use callback
// //               //...
// //             ),
// //             const SizedBox(height: 16),
// //             AppSelectionField<BankBranch>(
// //               controller:
// //                   widget.branchController, // Use widget.branchController
// //               labelText: 'Select Branch',
// //               selectionSheetTitle: 'Select a Branch',
// //               initialValue: widget.selectedBranch,
// //               onSelected: widget.onBranchSelected, // Use callback
// //               onCommitStateChanged: widget.onBranchCommitChanged,
// //               displayNames: const ['Branch Name', 'Bank Name'],
// //               valueFields: const ['branchName', 'bankName'],
// //               mainField: 'branchName',
// //               dataUrl: 'api/branch/list', // Use callback
// //               preRequest: _handlePreRequestBank,
// //               filterConditions:
// //                   widget.selectedBank != null
// //                       ? [
// //                         ['bankCode', '=', widget.selectedBank!.bankCode],
// //                         ['bankName', '=', widget.selectedBank!.bankName],
// //                       ]
// //                       : [],
// //             ),
// //             const SizedBox(height: 16),
// //             AppTextField(
// //               controller: widget.amountController, // Use controller from widget
// //               labelText: 'Amount',
// //               keyboardType: TextInputType.number,
// //               isFinanceNum: true,
// //             ),
// //             const SizedBox(height: 40),
// //             ActionButton(
// //               label: 'Submit',
// //               icon: Icons.check_circle_outline,
// //               onPressed: widget.onSubmit,
// //               // Use validation flags from parent
// //               disabled: !widget.isFormValid && !_isChildFormValid,
// //             ),
// //           ],
// //         ),
// //       ),
// //     ));
// //   }
// // }
// class RecieptDetailsView extends StatefulWidget {
//   final Dealer dealer;
//   final VoidCallback onSubmit;
//   final VoidCallback addCreditnote;

//   // Initial data values from parent
//   final String initialChequeNo;
//   final String initialAmount;
//   final TinData? selectedTin;
//   final Bank? selectedBank;
//   final BankBranch? selectedBranch;
//   final DateTime? selectedChequeDate;
//   final bool isFormValid;

//   // Callbacks to update parent state

//   final ValueChanged<String> onBankTextChanged;
//   final ValueChanged<String> onTinTextChanged;
//   final ValueChanged<String> onBranchTextChanged;

//   final ValueChanged<String> onChequeNoChanged;
//   final ValueChanged<String> onAmountChanged;
//   final ValueChanged<TinData> onTinSelected;
//   final ValueChanged<Bank> onBankSelected;
//   final ValueChanged<BankBranch> onBranchSelected;
//   final ValueChanged<DateTime?> onDateSelected;
//   final ValueChanged<bool> onTinCommitChanged;
//   final ValueChanged<bool> onBankCommitChanged;
//   final ValueChanged<bool> onBranchCommitChanged;

//   const RecieptDetailsView({
//     super.key,
//     required this.dealer,
//     required this.onSubmit,
//     required this.addCreditnote,
//     required this.initialChequeNo,
//     required this.initialAmount,
//     this.selectedTin,
//     this.selectedBank,
//     this.selectedBranch,
//     this.selectedChequeDate,
//     required this.isFormValid,
//     required this.onChequeNoChanged,
//     required this.onAmountChanged,
//     required this.onTinSelected,
//     required this.onBankSelected,
//     required this.onBranchSelected,
//     required this.onDateSelected,
//     required this.onTinCommitChanged,
//     required this.onBankCommitChanged,
//     required this.onBranchCommitChanged,

//     required this.onBankTextChanged,
//     required this.onTinTextChanged,
//     required this.onBranchTextChanged,
//   });

//   @override
//   State<RecieptDetailsView> createState() => _RecieptDetailsViewState();
// }

// class _RecieptDetailsViewState extends State<RecieptDetailsView> {
//   // --- Controllers are now local to the child widget's state ---
//   late final TextEditingController _chequeNoController;
//   late final TextEditingController _amountController;
//   late final TextEditingController _tinController;
//   late final TextEditingController _bankController;
//   late final TextEditingController _branchController;

//   final _formKey = GlobalKey<FormState>();
//   bool _isChildFormValid = false;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with the initial data from the parent
//     _chequeNoController = TextEditingController(text: widget.initialChequeNo);
//     _amountController = TextEditingController(text: widget.initialAmount);
//     _tinController = TextEditingController(text: widget.selectedTin?.tinNumber);
//     _bankController = TextEditingController(
//       text: widget.selectedBank?.bankName,
//     );
//     _branchController = TextEditingController(
//       text: widget.selectedBranch?.branchName,
//     );

//     // Add listeners to call the parent's callbacks
//     _chequeNoController.addListener(() {
//       widget.onChequeNoChanged(_chequeNoController.text);
//       _validateChildForm();
//     });
//     _amountController.addListener(() {
//       widget.onAmountChanged(_amountController.text);
//       _validateChildForm();
//     });
//   }

//   // This is a new method to handle when the parent's data changes
//   @override
//   void didUpdateWidget(covariant RecieptDetailsView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // If the parent rebuilds and provides a new bank or tin, update the local controller's text.
//     // if (widget.selectedBank != oldWidget.selectedBank) {
//     //   _bankController.text = widget.selectedBank?.bankName ?? '';
//     // }
//     // if (widget.selectedBranch != oldWidget.selectedBranch) {
//     //   _branchController.text = widget.selectedBranch?.branchName ?? '';
//     // }
//     // if (widget.selectedTin != oldWidget.selectedTin) {
//     //   _tinController.text = widget.selectedTin?.tinNumber ?? '';
//     // }
//   }

//   @override
//   void dispose() {
//     // Dispose all local controllers
//     _chequeNoController.dispose();
//     _amountController.dispose();
//     _tinController.dispose();
//     _bankController.dispose();
//     _branchController.dispose();
//     super.dispose();
//   }

//   void _validateChildForm() {
//     setState(() {
//       _isChildFormValid = _formKey.currentState?.validate() ?? false;
//     });
//   }

//   Future<bool> _handlePreRequestBank() async {
//     if (widget.selectedBank == null) {
//       showInfoDialog(
//         context: context,
//         title: 'Select a Bank First',
//         content: 'Please Select Bank.',
//       );
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               DealerInfoCard(dealer: widget.dealer),
//               const SizedBox(height: 12),
//               AppSelectionField<TinData>(
//                 controller: _tinController, // Use local controller
//                 labelText: 'Select TIN Number',
//                 selectionSheetTitle: 'Select a TIN Number',
//                 initialValue: widget.selectedTin,
//                 onChanged: widget.onTinTextChanged,
//                 onSelected: (tin) {
//                   widget.onTinSelected(tin);
//                   _tinController.text =
//                       tin.tinNumber; // Manually update controller
//                 },
//                 onCommitStateChanged: widget.onTinCommitChanged,
//                 displayNames: const ['TIN Number', 'Total Value'],
//                 valueFields: const ['tinNumber', 'totalValue'],
//                 mainField: 'tinNumber',
//                 dataUrl: 'api/tins/list',
//               ),
//               const SizedBox(height: 12),
//               ActionButton(
//                 label: 'Add Credit Note',
//                 icon: Icons.add_card,
//                 onPressed: widget.addCreditnote,
//                 color: AppColors.success,
//                 disabled: !widget.dealer.hasBankGuarantee,
//               ),
//               const SizedBox(height: 16),
//               AppTextField(
//                 controller: _chequeNoController, // Use local controller
//                 labelText: 'Cheque No.',
//               ),
//               const SizedBox(height: 16),
//               DatePickerField(
//                 labelText: 'Cheque Date',
//                 selectedDate: widget.selectedChequeDate,
//                 onDateSelected: widget.onDateSelected,
//               ),
//               const SizedBox(height: 16),
//               AppSelectionField<Bank>(
//                 controller: _bankController, // Use local controller
//                 labelText: 'Select Bank',
//                 selectionSheetTitle: 'Select a Bank',
//                 initialValue: widget.selectedBank,
//                 onChanged:
//                     (bank) => {
//                       widget.onBankTextChanged,
//                       _branchController.clear(),
//                     },
//                 onSelected: (bank) {
//                   widget.onBankSelected(bank);
//                   _bankController.text = bank.bankName; // Manually update
//                   if (widget.selectedBank != bank) {
//                     _branchController.clear(); // Clear branch if bank changes
//                   }
//                 },
//                 onCommitStateChanged: widget.onBankCommitChanged,
//                 displayNames: const ['Bank Name'],
//                 valueFields: const ['bankName'],
//                 mainField: 'bankName',
//                 dataUrl: 'api/bank/list',
//               ),
//               const SizedBox(height: 16),
//               AppSelectionField<BankBranch>(
//                 controller: _branchController, // Use local controller
//                 labelText: 'Select Branch',
//                 selectionSheetTitle: 'Select a Branch',
//                 initialValue: widget.selectedBranch,
//                 onChanged: widget.onBranchTextChanged,
//                 onSelected: (branch) {
//                   widget.onBranchSelected(branch);
//                   _branchController.text = branch.branchName; // Manually update
//                 },
//                 onCommitStateChanged: widget.onBranchCommitChanged,
//                 displayNames: const ['Branch Name', 'Bank Name'],
//                 valueFields: const ['branchName', 'bankName'],
//                 mainField: 'branchName',
//                 dataUrl: 'api/branch/list',
//                 preRequest: _handlePreRequestBank,
//                 filterConditions:
//                     widget.selectedBank != null
//                         ? [
//                           ['bankCode', '=', widget.selectedBank!.bankCode],
//                         ]
//                         : [],
//               ),
//               const SizedBox(height: 16),
//               AppTextField(
//                 controller: _amountController, // Use local controller
//                 labelText: 'Amount',
//                 keyboardType: TextInputType.number,
//                 isFinanceNum: true,
//                 onChanged: (value) {
//                   widget.onAmountChanged(value);
//                   _validateChildForm();
//                 },
//               ),
//               const SizedBox(height: 40),
//               ActionButton(
//                 label: 'Submit',
//                 icon: Icons.check_circle_outline,
//                 onPressed: widget.onSubmit,
//                 disabled: !widget.isFormValid || !_isChildFormValid,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
