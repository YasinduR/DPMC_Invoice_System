// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myapp/models/bank_branch_model.dart';
// import 'package:myapp/models/bank_model.dart';
// import 'package:myapp/models/credit_note_model.dart';
// import 'package:myapp/models/dealer_model.dart';
// import 'package:myapp/models/region_model.dart';
// import 'package:myapp/models/tin_model.dart';
// import 'package:myapp/providers/region_provider.dart';
// import 'package:myapp/theme/app_theme.dart';
// import 'package:myapp/util/dialog_box.dart';
// import 'package:myapp/views/auth_dealer_view.dart';
// import 'package:myapp/views/region_selection_view.dart';
// import 'package:myapp/views/select_dealer_view.dart';
// import 'package:myapp/widgets/action_button.dart';
// import 'package:myapp/views/add_credit_note_view.dart';
// import 'package:myapp/widgets/app_help_text_field.dart';
// //import 'package:myapp/views/cheque_details_view.dart'; // Adjust path
// import 'package:myapp/widgets/app_page.dart';
// import 'package:myapp/util/snack_bar.dart';
// import 'package:myapp/widgets/date_picker_field.dart';
// import 'package:myapp/widgets/dealer_info_card.dart';
// import 'package:myapp/widgets/text_form_field.dart'; // Adjust path

// class RecieptScreen extends ConsumerStatefulWidget {
//   const RecieptScreen({super.key});

//   @override
//   ConsumerState<RecieptScreen> createState() => _RecieptScreenState();
// }

// class _RecieptScreenState extends ConsumerState<RecieptScreen> {
//   int _currentStep = 0;
//   List<CreditNote> _creditNotes = []; // This will be useful later
//   Dealer? _selectedDealer;

//   // Regional settings
//   Region? _selectedRegion;

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

//   void _onRegionSelectionRequested() {
//     setState(() {
//       _currentStep = -1; // Move to Region selection step
//     });
//   }
//   //--- Regional Settings

//   // This is the callback that will be passed to AddCreditNotesView.
//   // It receives the updated list FROM the child view.
//   void _updateAndSaveCreditNotes(List<CreditNote> updatedNotes) {
//     setState(() {
//       _creditNotes = updatedNotes;
//       _currentStep = 0;
//     });
//     showSnackBar(
//       context: context,
//       message: '${updatedNotes.length} credit notes have been saved.',
//       type: MessageType.success,
//     );
//     // Optional: Show a confirmation message
//   }

//   void _submitChequeDetails() {
//     // This is where you would process the data
//     // For now, we'll just show a success message and move to the next step
//     showSnackBar(
//       context: context,
//       message: 'Cheque Details Submitted!',
//       type: MessageType.success,
//     );

//     setState(() {
//       _currentStep = 2; // Move to the confirmation/summary view
//     });
//   }

//   void _gotoaddCreditNotes() {
//     setState(() {
//       _currentStep = 3; // Move to the confirmation/summary view
//     });
//   }

//   void _onback() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--; // Go back to the previous step
//       });
//     } else {
//       Navigator.of(context).pop(); // Exit the page
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
//         _currentStep = 1; // Move to Authenticate step
//       });
//     }
//   }

//   void _onAuthenticated() {
//     setState(() {
//       _currentStep = 2; // Move to Create Invoice step
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
//         return 'Select Region'; // New title
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

//   Widget _buildCurrentView() {
//     final selectedRegion = ref.watch(regionProvider).selectedRegion;
//     switch (_currentStep) {
//       case -1:
//         return SelectRegionView(
//           selectedRegion: selectedRegion,
//           onRegionSelected: _onRegionSelected,
//           onSubmit: _submitRegion,
//         );
//       case 0:
//         return SelectDealerView(
//           onRegionSelectionRequested: _onRegionSelectionRequested,
//           //dealers: _dealers,
//           selectedRegion: selectedRegion,
//           selectedDealer: _selectedDealer,
//           onDealerSelected: _onDealerSelected,
//           onSubmit: _submitDealer, // Pass submit callback
//         );

//       case 1:
//         return AuthenticateDealerView(
//           dealer: _selectedDealer!,
//           onAuthenticated: _onAuthenticated,
//         );

//       case 2:
//         return RecieptDetailsView(
//           onSubmit: _submitChequeDetails,
//           addCreditnote: _gotoaddCreditNotes,
//           dealer: _selectedDealer!,
//         );

//       case 3:
//         return AddCreditNotesView(
//           initialNotes: _creditNotes,
//           onSubmit: _updateAndSaveCreditNotes,
//         );

//       case 4:
//         // You can create a new view here for confirmation or summary
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

// class RecieptDetailsView extends StatefulWidget {
//   final Dealer dealer;
//   final TinData? selectedTin;
//   final Bank? selectedBank;
//   final BankBranch? selectedBranch;
//   final VoidCallback onSubmit;
//   final VoidCallback addCreditnote;

//   const RecieptDetailsView({
//     super.key,
//     required this.onSubmit,
//     required this.addCreditnote,
//     required this.dealer,
//     this.selectedTin,
//     this.selectedBank,
//     this.selectedBranch,
//   });

//   @override
//   State<RecieptDetailsView> createState() => _RecieptDetailsViewState();
// }

// class _RecieptDetailsViewState extends State<RecieptDetailsView> {
//   final _chequeNoController = TextEditingController();
//   final _amountController = TextEditingController();
//   final TextEditingController _tinController = TextEditingController();
//   final TextEditingController _bankController = TextEditingController();
//   final TextEditingController _branchController = TextEditingController();
//   // State to track if the selection is valid and committed.
//   bool _isTinSelectionCommitted = false;
//   bool _isBankSelectionCommitted = false;
//   bool _isBranchSelectionCommitted = false;
//   DateTime? _selectedChequeDate;
//   TinData? _selectedTin; // On submit Extract _selectedTin _selectedBank _selected
//   Bank? _selectedBank;
//   BankBranch? _selectedBranch;

//   bool _isFormValid = false;

//   @override
//   void initState() {
//     super.initState();
//     // If a TIN is pre-selected, populate the controller and set the initial state.
//     if (widget.selectedTin != null) {
//       _tinController.text = widget.selectedTin!.tinNumber;
//       _isTinSelectionCommitted = true;
//     }
//     if (widget.selectedBank != null) {
//       _bankController.text = widget.selectedBank!.bankName;
//       _isBankSelectionCommitted = true;
//     }

//     if (widget.selectedBranch != null) { 
//     _branchController.text = widget.selectedBranch!.branchName;
//     _isBranchSelectionCommitted = true;
//     }

//     // Add listeners to check form validity on every change
//     _chequeNoController.addListener(_validateForm);
//     _amountController.addListener(_validateForm);

//     _bankController.addListener(_onBankTextChanged);
//   }

//   void _onBankTextChanged() {
//   // If the text is manually changed and doesn't match the selected bank's name
//     if (_isBankSelectionCommitted && _bankController.text != _selectedBank?.bankName) {
//       setState(() {
//       // Reset bank selection
//       _selectedBank = null;
//       _isBankSelectionCommitted = false;

//       // Reset branch selection as it depends on the bank
//       _selectedBranch = null;
//       _branchController.text = '';
//       _isBranchSelectionCommitted = false;
//     });
//   }
// }

//   Future<bool> _handlePreRequestBank() async {
//     if (_selectedBank == null) {
//       showInfoDialog(
//         context: context,
//         title: 'Select a Bank First',
//         content: 'Please Select Bank.',
//         //isError: true,
//       );
//       // Prevent the selection sheet from opening
//       return false;
//     }
//     // Proceed if region is selected
//     return true;
//   }

//   void _validateForm() {
//     // This logic checks if all required fields are filled
//     final isValid =
//         _chequeNoController.text.isNotEmpty &&
//         _amountController.text.isNotEmpty &&
//         _selectedChequeDate != null;

//     // setState is only called if the validity state changes, which is efficient
//     if (isValid != _isFormValid) {
//       setState(() {
//         _isFormValid = isValid;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _chequeNoController.dispose();
//     _amountController.dispose();
//     _tinController.dispose();
//     _bankController.removeListener(_onBankTextChanged); 
//     _bankController.dispose(); 
//     _branchController.dispose(); 
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DealerInfoCard(dealer: widget.dealer),
//             const SizedBox(height: 12),
//             AppSelectionField<TinData>(
//               controller: _tinController,
//               labelText: 'Select TIN Number',
//               selectionSheetTitle: 'Select a TIN Number',
//               initialValue: widget.selectedTin,
//               //items: widget.tins,
//               onSelected: (TinData tin) {
//                 setState(() {
//                   _selectedTin = tin;
//                 });
//               }, // displayString: (tin) => tin.tinNumber,
//               onCommitStateChanged: (isCommitted) {
//                 setState(() {
//                   _isTinSelectionCommitted = isCommitted;
//                 });
//               },
//               displayNames: const ['TIN Number', 'Total Value'],
//               valueFields: const ['tinNumber', 'totalValue'],
//               mainField: 'tinNumber',
//               dataUrl: 'api/tins/list',
//             ),
//             const SizedBox(height: 12),
//             ActionButton(
//               label: 'Add Credit Note',
//               icon: Icons.add_card,
//               onPressed: widget.addCreditnote,
//               color: AppColors.success,
//             ),
//             const SizedBox(height: 16),
//             // REPLACEMENT: Using the CustomTextField widget
//             AppTextField(
//               controller: _chequeNoController,
//               labelText: 'Cheque No.',
//             ),
//             const SizedBox(height: 16),
//             const AppTextField(labelText: 'Account No.'), // Dummy for now
//             const SizedBox(height: 16),
//             DatePickerField(
//               labelText: 'Cheque Date',
//               selectedDate: _selectedChequeDate,
//               onDateSelected: (date) {
//                 setState(() {
//                   _selectedChequeDate = date;
//                   _validateForm(); // Validate after date selection
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             const AppTextField(labelText: 'To Be Deposited'), // Dummy
//             const SizedBox(height: 16),
//             // const AppTextField(labelText: 'Bank'), // Dummy
//             AppSelectionField<Bank>(
//               controller: _bankController,
//               labelText: 'Select Bank',
//               selectionSheetTitle: 'Select a Bank',
//               initialValue: widget.selectedBank,
//               //items: widget.tins,
//               onSelected: (Bank bank) {
//                 setState(() {
//                   if (_selectedBank != bank) {
//                     _selectedBranch = null;
//                     _branchController.text = '';
//                     _isBranchSelectionCommitted = false;

//                   }
//                   _selectedBank = bank;
//                 });
//               },
//               onCommitStateChanged: (isCommitted) {
//                 setState(() {
//                   _isBankSelectionCommitted = isCommitted;
//                 });
//               },
//               displayNames: const ['Bank Name'],
//               valueFields: const ['bankName'],
//               mainField: 'bankName',
//               dataUrl: 'api/bank/list',
//             ),
//             const SizedBox(height: 16),
//             // const AppTextField(labelText: 'Branch'), // Dummy
//             AppSelectionField<BankBranch>(
//               controller: _branchController,
//               labelText: 'Select Branch',
//               selectionSheetTitle: 'Select a Branch',
//               initialValue: widget.selectedBranch,
//               //items: widget.tins,
//               onSelected: (BankBranch branch) {
//                 setState(() {
//                   _selectedBranch = branch;
//                 });
//               },
//               onCommitStateChanged: (isCommitted) {
//                 setState(() {
//                   _isBranchSelectionCommitted = isCommitted;
//                 });
//               },
//               displayNames: const ['Branch Name', 'Bank Name'],
//               valueFields: const ['branchName', 'bankName'],
//               mainField: 'branchName',
//               dataUrl: 'api/branch/list',
//               preRequest: _handlePreRequestBank,
//               filterConditions:
//                   _selectedBank != null
//                       ? [
//                         ['bankCode', '=', _selectedBank!.bankCode],
//                         ['bankName', '=', _selectedBank!.bankName],
//                       ]
//                       : [],
//             ),

//             const SizedBox(height: 16),
//             // REPLACEMENT: Using the CustomTextField widget with keyboardType
//             AppTextField(
//               controller: _amountController,
//               labelText: 'Amount',
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 40),
//             ActionButton(
//               label: 'Submit',
//               icon: Icons.check_circle_outline,
//               onPressed: widget.onSubmit,
//               disabled:
//                   !_isFormValid ||
//                   !_isTinSelectionCommitted ||
//                   !_isBankSelectionCommitted ||
//                   !_isBranchSelectionCommitted,
//               // Button is disabled based on form validity
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
