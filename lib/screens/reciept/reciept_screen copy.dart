// import 'package:decimal/decimal.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myapp/models/bank_branch_model.dart';
// import 'package:myapp/models/bank_model.dart';
// import 'package:myapp/models/credit_note_model.dart';
// import 'package:myapp/models/dealer_model.dart';
// import 'package:myapp/models/reciept_model.dart';
// import 'package:myapp/models/region_model.dart';
// import 'package:myapp/models/tin_model.dart';
// import 'package:myapp/providers/region_provider.dart';
// import 'package:myapp/util/api_util.dart';
// import 'package:myapp/views/auth_dealer_view.dart';
// import 'package:myapp/views/reciept_detail_view.dart';
// import 'package:myapp/views/region_selection_view.dart';
// import 'package:myapp/views/select_dealer_view.dart';

// import 'package:myapp/views/add_credit_note_view.dart';
// //import 'package:myapp/views/cheque_details_view.dart'; // Adjust path
// import 'package:myapp/widgets/app_page.dart';
// import 'package:myapp/util/snack_bar.dart';

// // class RecieptScreen extends ConsumerStatefulWidget {
// //   const RecieptScreen({super.key});

// //   @override
// //   ConsumerState<RecieptScreen> createState() => _RecieptScreenState();
// // }

// // class _RecieptScreenState extends ConsumerState<RecieptScreen> {
// //   int _currentStep = 0;
// //   List<CreditNote> _creditNotes = [];
// //   Dealer? _selectedDealer;

// //   // Regional settings
// //   Region? _selectedRegion;

// //   void _onRegionSelected(Region region) {
// //     setState(() {
// //       _selectedRegion = region;
// //     });
// //   }

// //   void _submitRegion() {
// //     if (_selectedRegion != null) {
// //       ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
// //       showSnackBar(
// //         context: context,
// //         message: 'Region set to: ${_selectedRegion!.region}',
// //         type: MessageType.success,
// //       );
// //       setState(() {
// //         _currentStep = 0; // Move to the inital
// //       });
// //     }
// //   }

// //   void _onRegionSelectionRequested() {
// //     setState(() {
// //       _currentStep = -1; // Move to Region selection step
// //     });
// //   }
// //   //--- Regional Settings

// //   // ------------Form Element Validation and events------------
// //   final _chequeNoController = TextEditingController();
// //   final _amountController = TextEditingController();
// //   final _tinController = TextEditingController();
// //   final _bankController = TextEditingController();
// //   final _branchController = TextEditingController();

// //   bool _isTinSelectionCommitted = false;
// //   bool _isBankSelectionCommitted = false;
// //   bool _isBranchSelectionCommitted = false;
// //   DateTime? _selectedChequeDate;
// //   TinData? _selectedTin;
// //   Bank? _selectedBank;
// //   BankBranch? _selectedBranch;
// //   // bool _areChildFieldsValid = false;
// //   // We will manage this from the parent now
// //   bool _isReceiptFormValid = false;
// //   // final _formKey =
// //   //     GlobalKey<FormState>(); // Form Validty (to check correct formats)

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Add listeners to controllers here
// //     _chequeNoController.addListener(_validateReceiptForm);
// //     _amountController.addListener(_validateReceiptForm);

// //     _tinController.addListener(_onTinTextChanged);
// //     _bankController.addListener(_onBankTextChanged);
// //     _branchController.addListener(_onBranchTextChanged);
// //   }

// //   @override
// //   void dispose() {
// //     // Remove all listeners before disposing controllers.
// //     _chequeNoController.removeListener(_validateReceiptForm);
// //     _amountController.removeListener(_validateReceiptForm);
// //     _tinController.removeListener(_onTinTextChanged);
// //     _bankController.removeListener(_onBankTextChanged);
// //     _branchController.removeListener(_onBranchTextChanged);

// //     // Dispose of all controllers here.
// //     _chequeNoController.dispose();
// //     _amountController.dispose();
// //     _tinController.dispose();
// //     _bankController.dispose();
// //     _branchController.dispose();
// //     super.dispose();
// //   }

// //   void _validateReceiptForm() {
// //     final bool isValid =
// //         _chequeNoController.text.isNotEmpty &&
// //         _amountController.text.isNotEmpty &&
// //         _selectedChequeDate != null &&
// //         _isTinSelectionCommitted &&
// //         _isBankSelectionCommitted &&
// //         _isBranchSelectionCommitted;

// //     // final bool isOverallValid = _areChildFieldsValid && isValid;

// //     if (isValid != _isReceiptFormValid) {
// //       setState(() {
// //         _isReceiptFormValid = isValid;
// //       });
// //     }
// //   }

// //   // Move the text changed listener logic here too
// //   void _onBankTextChanged() {
// //     if (_isBankSelectionCommitted &&
// //         _bankController.text != _selectedBank?.bankName) {
// //       setState(() {
// //         _selectedBank = null;
// //         _isBankSelectionCommitted = false;
// //         _selectedBranch = null;
// //         _branchController.text = '';
// //         _isBranchSelectionCommitted = false;
// //       });
// //     }
// //     _validateReceiptForm();
// //   }

// //   void _onTinTextChanged() {
// //     if (_isTinSelectionCommitted &&
// //         _tinController.text != _selectedTin?.tinNumber) {
// //       setState(() {
// //         _selectedTin = null;
// //         _isTinSelectionCommitted = false;
// //       });
// //     }
// //     _validateReceiptForm();
// //   }

// //   void _onBranchTextChanged() {
// //     if (_isBranchSelectionCommitted &&
// //         _branchController.text != _selectedBranch?.branchName) {
// //       setState(() {
// //         _selectedBranch = null;
// //         _isBranchSelectionCommitted = false;
// //       });
// //     }
// //     _validateReceiptForm();
// //   }

// //   void _clearReceiptDetails() {
// //     _chequeNoController.clear();
// //     _amountController.clear();
// //     _tinController.clear();
// //     _bankController.clear();
// //     _branchController.clear();

// //     setState(() {
// //       _isTinSelectionCommitted = false;
// //       _isBankSelectionCommitted = false;
// //       _isBranchSelectionCommitted = false;
// //       _selectedChequeDate = null;
// //       _selectedTin = null;
// //       _selectedBank = null;
// //       _selectedBranch = null;
// //       _isReceiptFormValid = false;
// //       _creditNotes = [];
// //     });
// //   }
// //   //============================================================================//

// //   // This is the callback that will be passed to AddCreditNotesView.
// //   // It receives the updated list FROM the child view.
// //   void _updateAndSaveCreditNotes(List<CreditNote> updatedNotes) {
// //     setState(() {
// //       _creditNotes = updatedNotes;
// //       _currentStep = 2; // Move back to Checke Deposit Details
// //     });
// //     showSnackBar(
// //       context: context,
// //       message: '${updatedNotes.length} credit notes have been saved.',
// //       type: MessageType.success,
// //     );
// //   }

// //   void _onSubmit() async {
// //     // // 1. Validate that all required data objects are selected/entered.
// //     if (_selectedTin == null ||
// //         _selectedDealer == null ||
// //         _selectedBank == null ||
// //         _selectedBranch == null ||
// //         _selectedChequeDate == null ||
// //         _chequeNoController.text.isEmpty) {
// //       showSnackBar(
// //         context: context,
// //         message: 'Please fill in all required fields.',
// //         type: MessageType.error,
// //       );
// //       return;
// //     }
// //     // 2. Perform amount validation.
// //     final double chequeAmount = double.tryParse(_amountController.text) ?? 0.0;
// //     final double totalCreditNoteAmount = _creditNotes.fold(
// //       0.0,
// //       (sum, note) => sum + note.amount,
// //     );
// //     //final double totalPayment = totalCreditNoteAmount + chequeAmount;
// //     // final double totalDue = _selectedTin!.totalValue;

// //     // Convert your initial values to the high-precision 'Decimal' type.
// //     final totalPayment = Decimal.parse(
// //       (totalCreditNoteAmount + chequeAmount).toString(),
// //     );
// //     final totalDue = Decimal.parse(_selectedTin!.totalValue.toString());

// //     if (totalPayment != totalDue) {
// //       final difference = (totalPayment - totalDue).abs();
// //       final message =
// //           totalPayment < totalDue
// //               ? 'The payment is lower by ${difference.toStringAsFixed(2)}.'
// //               : 'The payment is higher by ${difference.toStringAsFixed(2)}.';
// //       showSnackBar(
// //         context: context,
// //         message: message,
// //         type: MessageType.warning,
// //       );
// //       return; // Stop the submission if amounts don't balance
// //     }
// //     // 3. Create the Receipt object using CODES from the selected objects.
// //     final receiptData = Receipt(
// //       dealerCode: _selectedDealer!.accountCode,
// //       chequeNumber: _chequeNoController.text,
// //       chequeAmount: chequeAmount,
// //       chequeDate: _selectedChequeDate!,
// //       bankCode: _selectedBank!.bankCode,
// //       branchCode: _selectedBranch!.branchCode,
// //       tinNumber: _selectedTin!.tinNumber,
// //       creditNotes: _creditNotes,
// //     );

// //     await save(
// //       context: context,
// //       dataUrl: 'api/receipts/save', // The specific endpoint for saving receipts
// //       dataToSave: receiptData,
// //       onSuccess: () {
// //         showSnackBar(
// //           context: context,
// //           message: 'Receipt saved successfully !',
// //           type: MessageType.success,
// //         );
// //         // You can reset the form or navigate away here
// //       },
// //       onError: (e) {
// //         String errorMessage = e.toString();

// //         if (errorMessage.startsWith('Exception: ')) {
// //           errorMessage = errorMessage.substring('Exception: '.length);
// //         }
// //         showSnackBar(
// //           context: context,
// //           message: errorMessage, // This will display our custom duplicate error
// //           type: MessageType.error,
// //         );
// //       },
// //     );
// //   }

// //   void _gotoaddCreditNotes() {
// //     setState(() {
// //       _currentStep = 3; // Move to the confirmation/summary view
// //     });
// //   }

// //   void _onback() {
// //     if (_currentStep > 0) {
// //       setState(() {
// //         _currentStep--; // Go back to the previous step
// //       });
// //     } else {
// //       Navigator.of(context).pop(); // Exit the page
// //     }
// //   }

// //   void _onDealerSelected(Dealer dealer) {
// //     setState(() {
// //       _selectedDealer = dealer;
// //     });
// //   }

// //   void _submitDealer() {
// //     if (_selectedDealer != null) {
// //       setState(() {
// //         _currentStep = 1; // Move to Authenticate step
// //       });
// //     }
// //   }

// //   void _onAuthenticated() {
// //     _clearReceiptDetails();
// //     setState(() {
// //       _currentStep = 2; // Move to Create Invoice step
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AppPage(
// //       title: _getCurrentTitle(),
// //       onBack: _onback,
// //       contentPadding: EdgeInsets.zero,
// //       child: _buildCurrentView(),
// //     );
// //   }

// //   String _getCurrentTitle() {
// //     switch (_currentStep) {
// //       case -1:
// //         return 'Select Region'; // New title
// //       case 0:
// //         return 'Select Dealer';
// //       case 1:
// //         return 'Authenticate Dealer';
// //       case 2:
// //         return 'Cheque Deposit Details';
// //       case 3:
// //         return 'Add Credit Notes';
// //       case 4:
// //         return 'Success';
// //       default:
// //         return 'Error';
// //     }
// //   }

// //   Widget _buildCurrentView() {
// //     final selectedRegion = ref.watch(regionProvider).selectedRegion;
// //     switch (_currentStep) {
// //       case -1:
// //         return SelectRegionView(
// //           selectedRegion: selectedRegion,
// //           onRegionSelected: _onRegionSelected,
// //           onSubmit: _submitRegion,
// //         );
// //       case 0:
// //         return SelectDealerView(
// //           onRegionSelectionRequested: _onRegionSelectionRequested,
// //           selectedRegion: selectedRegion,
// //           selectedDealer: _selectedDealer,
// //           onDealerSelected: _onDealerSelected,
// //           onSubmit: _submitDealer, // Pass submit callback
// //         );

// //       case 1:
// //         return AuthenticateDealerView(
// //           dealer: _selectedDealer!,
// //           onAuthenticated: _onAuthenticated,
// //         );

// //       case 2:
// //         return RecieptDetailsView(
// //           //onValidationChanged: _onChildValidationChanged,
// //           dealer: _selectedDealer!,
// //           onSubmit: _onSubmit,
// //           addCreditnote: _gotoaddCreditNotes,

// //           // Pass down controllers
// //           chequeNoController: _chequeNoController,
// //           amountController: _amountController,
// //           tinController: _tinController,
// //           bankController: _bankController,
// //           branchController: _branchController,

// //           // Pass down selected values
// //           selectedTin: _selectedTin,
// //           selectedBank: _selectedBank,
// //           selectedBranch: _selectedBranch,
// //           selectedChequeDate: _selectedChequeDate,

// //           isFormValid: _isReceiptFormValid,

// //           // Pass down callback functions to update the parent's state
// //           onTinSelected: (tin) => setState(() => _selectedTin = tin),
// //           onBankSelected: (bank) {
// //             setState(() {
// //               if (_selectedBank != bank) {
// //                 _selectedBranch = null;
// //                 _branchController.text = '';
// //                 _isBranchSelectionCommitted = false;
// //               }
// //               _selectedBank = bank;
// //             });
// //           },
// //           onBranchSelected:
// //               (branch) => setState(() => _selectedBranch = branch),
// //           onDateSelected: (date) {
// //             setState(() {
// //               _selectedChequeDate = date;
// //               _validateReceiptForm();
// //             });
// //           },
// //           onTinCommitChanged: (isCommitted) {
// //             setState(() {
// //               _isTinSelectionCommitted = isCommitted;
// //             });
// //             _validateReceiptForm();
// //           },
// //           onBankCommitChanged: (isCommitted) {
// //             setState(() {
// //               _isBankSelectionCommitted = isCommitted;
// //             });
// //             _validateReceiptForm();
// //           },
// //           onBranchCommitChanged: (isCommitted) {
// //             setState(() {
// //               _isBranchSelectionCommitted = isCommitted;
// //             });
// //             _validateReceiptForm();
// //           },
// //         );

// //       case 3:
// //         return AddCreditNotesView(
// //           initialNotes: _creditNotes,
// //           onSubmit: _updateAndSaveCreditNotes,
// //         );

// //       case 4:
// //         return Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.check_circle, color: Colors.green, size: 80),
// //               const SizedBox(height: 20),
// //               const Text(
// //                 'Submission Successful',
// //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //               ),
// //             ],
// //           ),
// //         );
// //       default:
// //         return AddCreditNotesView(onSubmit: _updateAndSaveCreditNotes);
// //     }
// //   }
// // }
// class RecieptScreen extends ConsumerStatefulWidget {
//   const RecieptScreen({super.key});

//   @override
//   ConsumerState<RecieptScreen> createState() => _RecieptScreenState();
// }

// class _RecieptScreenState extends ConsumerState<RecieptScreen> {
//   int _currentStep = 0;
//   List<CreditNote> _creditNotes = [];
//   Dealer? _selectedDealer;

//   // Regional settings
//   Region? _selectedRegion;

//   // --- Form data is now stored directly in the parent's state ---
//   String _chequeNo = '';
//   String _amount = '';
//   TinData? _selectedTin;
//   Bank? _selectedBank;
//   BankBranch? _selectedBranch;
//   DateTime? _selectedChequeDate;

//   // --- Selection commit flags remain in the parent ---
//   bool _isTinSelectionCommitted = false;
//   bool _isBankSelectionCommitted = false;
//   bool _isBranchSelectionCommitted = false;
//   bool _isReceiptFormValid = false;

//   @override
//   void initState() {
//     super.initState();
//     // No controllers to initialize here anymore.
//   }

//   @override
//   void dispose() {
//     // No controllers to dispose here anymore.
//     super.dispose();
//   }
  
//   // The rest of your regional settings methods (_onRegionSelected, etc.) remain the same...
//   void _onRegionSelected(Region region) {
//     setState(() {
//       _selectedRegion = region;
//     });
//   }

//   void _submitRegion() {
//     if (_selectedRegion != null) {
//       ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
//       showSnackBar(
//         context: context,
//         message: 'Region set to: ${_selectedRegion!.region}',
//         type: MessageType.success,
//       );
//       setState(() {
//         _currentStep = 0; // Move to the inital
//       });
//     }
//   }

//     void _onRegionSelectionRequested() {
//     setState(() {
//       _currentStep = -1; // Move to Region selection step
//     });
//   }


//   void _validateReceiptForm() {
//     final bool isValid = _chequeNo.isNotEmpty &&
//         _amount.isNotEmpty &&
//         _selectedChequeDate != null &&
//         _isTinSelectionCommitted &&
//         _isBankSelectionCommitted &&
//         _isBranchSelectionCommitted;

//     if (isValid != _isReceiptFormValid) {
//       setState(() {
//         _isReceiptFormValid = isValid;
//       });
//     }
//   }

//   void _clearReceiptDetails() {
//     setState(() {
//       _chequeNo = '';
//       _amount = '';
//       _selectedTin = null;
//       _selectedBank = null;
//       _selectedBranch = null;
//       _selectedChequeDate = null;
//       _isTinSelectionCommitted = false;
//       _isBankSelectionCommitted = false;
//       _isBranchSelectionCommitted = false;
//       _isReceiptFormValid = false;
//       _creditNotes = [];
//     });
//   }
//     void _onBankTextChanged(String currentText) {
//     // If a bank is currently selected AND the text in the box no longer
//     // matches the selected bank's name, it means the user has manually
//     // edited it. We must treat this as a deselection.
//     if (_selectedBank != null && currentText != _selectedBank!.bankName) {
//       setState(() {
//         _selectedBank = null;
//         _isBankSelectionCommitted = false;
        
//         // CRITICAL: Reset the dependent branch field as well
//         _selectedBranch = null;
//         _isBranchSelectionCommitted = false;
//       });
//       _validateReceiptForm(); // Re-validate after state change
//     }
//   }

//   void _onTinTextChanged(String currentText) {
//     // Apply the same logic for the TIN field
//     if (_selectedTin != null && currentText != _selectedTin!.tinNumber) {
//       setState(() {
//         _selectedTin = null;
//         _isTinSelectionCommitted = false;
//         // If other fields depended on TIN, you would reset them here.
//       });
//       _validateReceiptForm();
//     }
//   }


//     void _onBranchTextChanged(String currentText) {
//     // Apply the same logic for the TIN field
//     if (_selectedBranch != null && currentText != _selectedBranch!.branchName) {
//       setState(() {
//         _selectedBranch = null;
//         _isBranchSelectionCommitted = false;
//         // If other fields depended on TIN, you would reset them here.
//       });
//       _validateReceiptForm();
//     }
//   }

  
//   // ==================== Your other methods like _onSubmit, _gotoaddCreditNotes, etc. remain largely the same ====================
//   // Note: The _onSubmit method now uses the state variables (_chequeNo, _amount) directly instead of controller.text
//     void _onSubmit() async {
//     // 1. Validate that all required data objects are selected/entered.
//     if (_selectedTin == null ||
//         _selectedDealer == null ||
//         _selectedBank == null ||
//         _selectedBranch == null ||
//         _selectedChequeDate == null ||
//         _chequeNo.isEmpty) { // Use _chequeNo directly
//       showSnackBar(
//         context: context,
//         message: 'Please fill in all required fields.',
//         type: MessageType.error,
//       );
//       return;
//     }
//     // 2. Perform amount validation.
//     final double chequeAmount = double.tryParse(_amount) ?? 0.0; // Use _amount directly
//     final double totalCreditNoteAmount = _creditNotes.fold(
//       0.0,
//       (sum, note) => sum + note.amount,
//     );

//     final totalPayment = Decimal.parse(
//       (totalCreditNoteAmount + chequeAmount).toString(),
//     );
//     final totalDue = Decimal.parse(_selectedTin!.totalValue.toString());

//     if (totalPayment != totalDue) {
//       final difference = (totalPayment - totalDue).abs();
//       final message =
//           totalPayment < totalDue
//               ? 'The payment is lower by ${difference.toStringAsFixed(2)}.'
//               : 'The payment is higher by ${difference.toStringAsFixed(2)}.';
//       showSnackBar(
//         context: context,
//         message: message,
//         type: MessageType.warning,
//       );
//       return; 
//     }
//     // 3. Create the Receipt object.
//     final receiptData = Receipt(
//       dealerCode: _selectedDealer!.accountCode,
//       chequeNumber: _chequeNo, // Use _chequeNo
//       chequeAmount: chequeAmount,
//       chequeDate: _selectedChequeDate!,
//       bankCode: _selectedBank!.bankCode,
//       branchCode: _selectedBranch!.branchCode,
//       tinNumber: _selectedTin!.tinNumber,
//       creditNotes: _creditNotes,
//     );

//     await save(
//       context: context,
//       dataUrl: 'api/receipts/save', 
//       dataToSave: receiptData,
//       onSuccess: () {
//         showSnackBar(
//           context: context,
//           message: 'Receipt saved successfully !',
//           type: MessageType.success,
//         );
//       },
//       onError: (e) {
//         String errorMessage = e.toString();

//         if (errorMessage.startsWith('Exception: ')) {
//           errorMessage = errorMessage.substring('Exception: '.length);
//         }
//         showSnackBar(
//           context: context,
//           message: errorMessage,
//           type: MessageType.error,
//         );
//       },
//     );
//   }

//   void _gotoaddCreditNotes() {
//     setState(() {
//       _currentStep = 3; 
//     });
//   }
//     void _updateAndSaveCreditNotes(List<CreditNote> updatedNotes) {
//     setState(() {
//       _creditNotes = updatedNotes;
//       _currentStep = 2; // Move back to Checke Deposit Details
//     });
//     showSnackBar(
//       context: context,
//       message: '${updatedNotes.length} credit notes have been saved.',
//       type: MessageType.success,
//     );
//   }

//   void _onback() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--; 
//       });
//     } else {
//       Navigator.of(context).pop(); 
//     }
//   }

//   void _onDealerSelected(Dealer dealer) {
//     setState(() {
//       _selectedDealer = dealer;
//     });
//   }

//   void _submitDealer() {
//     if (_selectedDealer != null) {
//       setState(() {
//         _currentStep = 1; 
//       });
//     }
//   }

//   void _onAuthenticated() {
//     _clearReceiptDetails();
//     setState(() {
//       _currentStep = 2; 
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppPage(
//       title: _getCurrentTitle(),
//       onBack: _onback,
//       contentPadding: EdgeInsets.zero,
//       child: _buildCurrentView(),
//     );
//   }

//   String _getCurrentTitle() {
//     switch (_currentStep) {
//       case -1:
//         return 'Select Region'; 
//       case 0:
//         return 'Select Dealer';
//       case 1:
//         return 'Authenticate Dealer';
//       case 2:
//         return 'Cheque Deposit Details';
//       case 3:
//         return 'Add Credit Notes';
//       case 4:
//         return 'Success';
//       default:
//         return 'Error';
//     }
//   }

//   // --- Build method now passes data and callbacks to the child ---
//   Widget _buildCurrentView() {
//     final selectedRegion = ref.watch(regionProvider).selectedRegion;
//     switch (_currentStep) {
//         case -1:
//         return SelectRegionView(
//           selectedRegion: selectedRegion,
//           onRegionSelected: _onRegionSelected,
//           onSubmit: _submitRegion,
//         );
//       case 0:
//         return SelectDealerView(
//           onRegionSelectionRequested: _onRegionSelectionRequested,
//           selectedRegion: selectedRegion,
//           selectedDealer: _selectedDealer,
//           onDealerSelected: _onDealerSelected,
//           onSubmit: _submitDealer,
//         );

//       case 1:
//         return AuthenticateDealerView(
//           dealer: _selectedDealer!,
//           onAuthenticated: _onAuthenticated,
//         );

//       case 2:
//         return RecieptDetailsView(
//           dealer: _selectedDealer!,
//           onSubmit: _onSubmit,
//           addCreditnote: _gotoaddCreditNotes,

//           // Pass down initial data
//           initialChequeNo: _chequeNo,
//           initialAmount: _amount,
//           selectedTin: _selectedTin,
//           selectedBank: _selectedBank,
//           selectedBranch: _selectedBranch,
//           selectedChequeDate: _selectedChequeDate,
//           isFormValid: _isReceiptFormValid,
//           onBankTextChanged: _onBankTextChanged,
//           onTinTextChanged: _onTinTextChanged,
//           onBranchTextChanged: _onBranchTextChanged,

//           // Pass down callbacks to update parent's state
//           onChequeNoChanged: (value) {
//             setState(() => _chequeNo = value);
//             _validateReceiptForm();
//           },
//           onAmountChanged: (value) {
//             setState(() => _amount = value);
//             _validateReceiptForm();
//           },
//           onTinSelected: (tin) {
//             setState(() => _selectedTin = tin);
//              _validateReceiptForm();
//           },
//           onBankSelected: (bank) {
//             setState(() {
//               if (_selectedBank != bank) {
//                 _selectedBranch = null; 
//                 _isBranchSelectionCommitted = false;
//               }
//               _selectedBank = bank;
//             });
//              _validateReceiptForm();
//           },
//           onBranchSelected: (branch) {
//             setState(() => _selectedBranch = branch);
//              _validateReceiptForm();
//           },
//           onDateSelected: (date) {
//             setState(() => _selectedChequeDate = date);
//             _validateReceiptForm();
//           },
//           onTinCommitChanged: (isCommitted) {
//             setState(() => _isTinSelectionCommitted = isCommitted);
//             _validateReceiptForm();
//           },
//           onBankCommitChanged: (isCommitted) {
//             setState(() => _isBankSelectionCommitted = isCommitted);
//             _validateReceiptForm();
//           },
//           onBranchCommitChanged: (isCommitted) {
//             setState(() => _isBranchSelectionCommitted = isCommitted);
//             _validateReceiptForm();
//           },
//         );

//       case 3:
//         return AddCreditNotesView(
//           initialNotes: _creditNotes,
//           onSubmit: _updateAndSaveCreditNotes,
//         );

//         // ... other cases remain the same
//          case 4:
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 80),
//               const SizedBox(height: 20),
//               const Text(
//                 'Submission Successful',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         );
//       default:
//         return AddCreditNotesView(onSubmit: _updateAndSaveCreditNotes);
//     }
//   }
// }