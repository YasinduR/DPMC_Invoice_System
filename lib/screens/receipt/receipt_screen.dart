import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/credit_note_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/receipt_detail_view.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/views/select_dealer_view.dart';

import 'package:myapp/views/add_credit_note_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class ReceiptScreen extends ConsumerStatefulWidget {
  const ReceiptScreen({super.key});

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen> {
  final PrinterService _printerService = PrinterService();
  int _currentStep = 0;
  List<CreditNote> _creditNotes = [];
  Dealer? _selectedDealer;
  Region? _selectedRegion;
  String? _podStatus;

  final GlobalKey<ReceiptDetailsViewState> _receiptDetailsKey =
      GlobalKey<ReceiptDetailsViewState>();
  // --- Controllers are now created and managed in the parent's state ---
  late final TextEditingController _chequeNoController;
  late final TextEditingController _chequeNoConfirmController;
  late final TextEditingController _amountController;
  late final TextEditingController _tinController;
  late final TextEditingController _bankController;
  late final TextEditingController _branchController;

  // --- Form data objects remain in the parent ---
  List<TinInvoice> _selectedTins = [];
  TinData? _selectedTin;
  Bank? _selectedBank;
  BankBranch? _selectedBranch;
  DateTime? _selectedChequeDate;

  // --- State flags remain in the parent ---
  bool _isTinSelectionCommitted = false;
  bool _isBankSelectionCommitted = false;
  bool _isBranchSelectionCommitted = false;
  bool _isReceiptFormValid = false;

  @override
  void initState() {
    super.initState();
    // Initialize all controllers here
    _chequeNoController = TextEditingController();
    _chequeNoConfirmController = TextEditingController();
    _amountController = TextEditingController();
    _tinController = TextEditingController();
    _bankController = TextEditingController();
    _branchController = TextEditingController();

    // Add listeners to controllers that need to trigger validation on text change.
    _chequeNoController.addListener(_validateReceiptForm);
    _chequeNoConfirmController.addListener(_validateReceiptForm);
    _amountController.addListener(_validateReceiptForm);
  }

  @override
  void dispose() {
    // Dispose all controllers here to prevent memory leaks
    _chequeNoController.dispose();
    _chequeNoConfirmController.dispose();
    _amountController.dispose();
    _tinController.dispose();
    _bankController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  void _clearReceiptDetails() {
    _chequeNoController.clear();
    _chequeNoConfirmController.clear();
    _amountController.clear();
    _tinController.clear();
    _bankController.clear();
    _branchController.clear();

    setState(() {
      _isTinSelectionCommitted = false;
      _isBankSelectionCommitted = false;
      _isBranchSelectionCommitted = false;
      _selectedChequeDate = null;
      _selectedTin = null;
      _selectedTins = [];
      _selectedBank = null;
      _selectedBranch = null;
      _isReceiptFormValid = false;
      _creditNotes = [];
    });
  }

  void _podStatusToggle(status) {
    setState(() {
      _selectedTins = [];
      _podStatus = status;
    });
  }

  void _validateReceiptForm() {
    final bool isValid =
        _chequeNoController.text.isNotEmpty &&
        _chequeNoConfirmController.text.isNotEmpty &&
        _chequeNoController.text == _chequeNoConfirmController.text &&
        _amountController.text.isNotEmpty &&
        _selectedChequeDate != null &&
        _selectedTins.isNotEmpty && // Check if at least one TIN is selected
        // _isTinSelectionCommitted &&
        _isBankSelectionCommitted &&
        _isBranchSelectionCommitted;

    if (isValid != _isReceiptFormValid) {
      setState(() {
        _isReceiptFormValid = isValid;
      });
    }
  }

  // --- Text changed handlers de-select the object if the text no longer matches ---
  void _onBankTextChanged(String currentText) {
    if (_selectedBank != null && currentText != _selectedBank!.bankName) {
      setState(() {
        _selectedBank = null;
        _isBankSelectionCommitted = false;
        // CRITICAL: Also clear the dependent branch state and controller text
        _selectedBranch = null;
        _isBranchSelectionCommitted = false;
        _branchController.clear();
      });
      _validateReceiptForm();
    }
  }

  void _onTinTextChanged(String currentText) {
    if (_selectedTin != null && currentText != _selectedTin!.tinNumber) {
      setState(() {
        _selectedTin = null;
        _isTinSelectionCommitted = false;
      });
      _validateReceiptForm();
    }
  }

  void _toggleTinSelection(TinInvoice tin) {
    setState(() {
      if (_selectedTins.contains(tin)) {
        _selectedTins.remove(tin);
      } else {
        _selectedTins.add(tin);
      }
    });
    _validateReceiptForm();
  }

  void _onBranchTextChanged(String currentText) {
    if (_selectedBranch != null && currentText != _selectedBranch!.branchName) {
      setState(() {
        _selectedBranch = null;
        _isBranchSelectionCommitted = false;
      });
      _validateReceiptForm();
    }
  }

  void _onSubmit() async {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;

    if (!_isReceiptFormValid || currentUser == null) {
      showSnackBar(
        context: context,
        message:
            'Please fill in all required fields and make valid selections.',
        type: MessageType.error,
      );
      return;
    }

    final double chequeAmount = double.tryParse(_amountController.text) ?? 0.0;
    final double totalCreditNoteAmount = _creditNotes.fold(
      0.0,
      (sum, note) => sum + note.amount,
    );

    final totalDue = _selectedTins.fold(
      Decimal.zero,
      (sum, tin) => sum + Decimal.parse(tin.invAmount.toString()),
    );

    final totalPayment = Decimal.parse(
      (totalCreditNoteAmount + chequeAmount).toString(),
    );

    if (totalPayment != totalDue) {
      final difference = (totalPayment - totalDue).abs();
      final message =
          totalPayment < totalDue
              ? 'The payment is lower by ${difference.toStringAsFixed(2)}.'
              : 'The payment is higher by ${difference.toStringAsFixed(2)}.';
      showSnackBar(
        context: context,
        message: message,
        type: MessageType.warning,
      );

      return;
    }

    if (_selectedTins.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Please select at least one TIN invoice to proceed.',
        type: MessageType.warning,
      );
      return;
    }
    final podStatuses =
        _selectedTins.map((tin) => tin.paymentOnDeliveryStatus).toSet();

    if (podStatuses.length > 1) {
      showSnackBar(
        context: context,
        message:
            'All selected invoices must have the same Payment on Delivery status.',
        type: MessageType.warning,
      );
      return;
    }

    final receiptData = Receipt(
      // receiptTime: Datetime.now(),
      receiptNo: 'AAA',
      userId: currentUser.id,
      dealerName: _selectedDealer!.name,
      dealerCode: _selectedDealer!.accountCode,
      chequeNumber: _chequeNoController.text,
      chequeAmount: chequeAmount,
      chequeDate: _selectedChequeDate!,
      bankCode: _selectedBank!.bankCode,
      branchCode: _selectedBranch!.branchCode,
      branchName: _selectedBranch!.branchName,
      tins: _selectedTins,
      creditNotes: _creditNotes,
      receiptTime: DateTime.now(),
    );
    late Receipt savedReceipt;

    await save(
      context: context,
      user: currentUser,
      activityType: ActivityType.receiptSave,
      dataUrl: 'receipts/save',
      dataToSave: receiptData,
      onReceivedData: (rawReceivedData) {
        try {
          savedReceipt = rawReceivedData;
        } catch (e) {
          showSnackBar(
            context: context,
            message: 'Failed to process response for Receipt: $e',
            type: MessageType.error,
          );
        }
      },
      onSuccess: () {
        showSnackBar(
          context: context,
          message: 'Receipt saved successfully!',
          type: MessageType.success,
        );
        _clearReceiptDetails();
        _receiptDetailsKey.currentState?.loadTinInvoices();
        final details = PrintFooterDetail(formNo: 'PA-FO-53', revNo: '01');
        PrinterService.previewThermalReceiptPdf(savedReceipt, details);
      },
      onError: (e) {
        String errorMessage = e.toString().replaceFirst('Exception: ', '');
        showSnackBar(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      },
    );
  }

  // --- Other navigation and state update methods ---
  // void _onDealerSelected(Dealer dealer) =>
  //     setState(() => _selectedDealer = dealer);

  void _onDealerSelected(Dealer dealer) {
    setState(() {
      _selectedDealer = dealer;
      if (_selectedDealer != null) {
        _currentStep = 1;
      }
    });
  }

  // void _submitDealer() {
  //   if (_selectedDealer != null) setState(() => _currentStep = 1);
  // }

  // void _onAuthenticated() => {
  //   _clearReceiptDetails(),
  //   setState(() => _currentStep = 2),
  // };

  void _gotoaddCreditNotes() => setState(() => _currentStep = 2);

  void _onback() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--; // Go back to the previous step
      });
    } else {
      Navigator.of(context).pop(); // Exit the page
    }
  }

  void _updateAndSaveCreditNotes(List<CreditNote> updatedNotes) {
    setState(() {
      _creditNotes = updatedNotes;
      _currentStep = 1; // Move back
    });
    showSnackBar(
      context: context,
      message: '${updatedNotes.length} credit notes have been saved.',
      type: MessageType.success,
    );
  }

  // --- Regional settings methods (unchanged) ---
  void _onRegionSelected(Region region) =>
      setState(() => _selectedRegion = region);
  void _submitRegion() {
    if (_selectedRegion != null) {
      ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
      showSnackBar(
        context: context,
        message: 'Region set to: ${_selectedRegion!.region}',
        type: MessageType.success,
      );
      setState(() {
        _currentStep = 0;
      });
    }
  }

  void _onRegionSelectionRequested() => setState(() => _currentStep = -1);

  String _getCurrentTitle() {
    switch (_currentStep) {
      case -1:
        return 'Select Region';
      case 0:
        return 'Select Dealer';
      case 1:
        return 'Receipt Details';
      case 2:
        return 'Add Credit Notes';
      case 3:
        return 'Success';
      default:
        return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool confirmOnNavigate = _currentStep >= 1;
    return AppPage(
      title: _getCurrentTitle(),
      onBack: _onback,
      confirmOnNavigate: confirmOnNavigate,
      contentPadding: EdgeInsets.zero,
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    final selectedRegion = ref.watch(regionProvider).selectedRegion;

    switch (_currentStep) {
      case -1:
        return SelectRegionView(
          selectedRegion: selectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion,
        );
      case 0:
        return SelectDealerView(
          onRegionSelectionRequested: _onRegionSelectionRequested,
          selectedRegion: selectedRegion,
          selectedDealer: null,
          onDealerSelected: _onDealerSelected,
          //onSubmit: _submitDealer,
        );

      case 1:
        return ReceiptDetailsView(
          key: _receiptDetailsKey, // Refresh Tin Data on succussful cheque save
          dealer: _selectedDealer!,
          onSubmit: _onSubmit,
          addCreditnote: _gotoaddCreditNotes,
          chequeNoController: _chequeNoController,
          chequeNoConfirmController: _chequeNoConfirmController,
          amountController: _amountController,
          tinController: _tinController,
          bankController: _bankController,
          branchController: _branchController,
          selectedTins: _selectedTins,
          onTinToggle: _toggleTinSelection,
          onPodStatusToggle: _podStatusToggle,
          selectedPODstatus:_podStatus,
          selectedTin: _selectedTin,
          selectedBank: _selectedBank,
          selectedBranch: _selectedBranch,
          selectedChequeDate: _selectedChequeDate,
          isFormValid: _isReceiptFormValid,
          onBankTextChanged: _onBankTextChanged,
          onBranchTextChanged: _onBranchTextChanged,
          onBankSelected: (bank) {
            setState(() {
              if (_selectedBank != bank) {
                _selectedBranch = null;
                _isBranchSelectionCommitted = false;
                _branchController.clear();
              }
              _selectedBank = bank;
              _bankController.text = bank.bankName; // Sync controller text
            });
            _validateReceiptForm();
          },
          onBranchSelected: (branch) {
            setState(() {
              _selectedBranch = branch;
              _branchController.text =
                  branch.branchName; // Sync controller text
            });
            _validateReceiptForm();
          },
          onDateSelected: (date) {
            setState(() => _selectedChequeDate = date);
            _validateReceiptForm();
          },
          onBankCommitChanged: (isCommitted) {
            setState(() => _isBankSelectionCommitted = isCommitted);
            _validateReceiptForm();
          },
          onBranchCommitChanged: (isCommitted) {
            setState(() => _isBranchSelectionCommitted = isCommitted);
            _validateReceiptForm();
          },
        );
      case 2:
        return AddCreditNotesView(
          initialNotes: _creditNotes,
          onSubmit: _updateAndSaveCreditNotes,
        );
      case 3:
        return const Center(child: Text("Success View"));
      default:
        return const Center(child: Text("Error: Invalid Step"));
    }
  }
}
