import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/credit_note_model.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_text_form_field.dart';
// ignore: unused_import
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart'; // Import the collection package for list comparison

class AddCreditNotesView extends StatefulWidget {
  // Callback to pass the final list of notes up to the parent
  final Function(List<CreditNote>) onSubmit;
  final List<CreditNote> initialNotes;

  const AddCreditNotesView({
    super.key,
    required this.onSubmit,
    this.initialNotes = const [],
  });

  @override
  State<AddCreditNotesView> createState() => _AddCreditNotesViewState();
}

class _AddCreditNotesViewState extends State<AddCreditNotesView> {
  final _formKey = GlobalKey<FormState>(); // 1. Add a GlobalKey for the Form
  final _crnController = TextEditingController();
  final _amountController = TextEditingController();
  // final List<CreditNote> _addedCreditNotes = [];
  late final List<CreditNote> _addedCreditNotes;
  late final List<CreditNote> _initialNotes;

  @override
  void initState() {
    super.initState();
    // Initialize the local list with a *copy* of the list passed from the parent.
    // This is important so that changes are only saved when the user hits 'Submit'.
    _addedCreditNotes = List<CreditNote>.from(widget.initialNotes);
    _initialNotes = List<CreditNote>.from(
      widget.initialNotes,
    ); // Represent initial list useful

    _crnController.addListener(() => setState(() {}));
    _amountController.addListener(() => setState(() {}));
  }

  bool _areListsEqual(List<CreditNote> listA, List<CreditNote> listB) {
    if (listA.length != listB.length) return false;
    return const DeepCollectionEquality.unordered().equals(listA, listB);
  }

  void _addNoteToList() {
    // 3. Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      final crn = _crnController.text;
      final amount = double.parse(_amountController.text);

      setState(() {
        _addedCreditNotes.add(CreditNote(crnNumber: crn, amount: amount));
      });
      _crnController.clear();
      _amountController.clear();
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    } else {
      showSnackBar(
        context: context,
        message: 'Please enter a valid CRN and amount.',
        type: MessageType.warning,
      );
    }
  }

  // void _addNoteToList() {
  //   final crn = _crnController.text;
  //   final amount = double.tryParse(_amountController.text);

  //   if (crn.isNotEmpty && amount != null && amount > 0) {
  //     setState(() {
  //       _addedCreditNotes.add(CreditNote(crnNumber: crn, amount: amount));
  //     });
  //     _crnController.clear();
  //     _amountController.clear();
  //     FocusScope.of(context).unfocus(); // Dismiss keyboard
  //   } else {
  //     showSnackBar(
  //       context: context,
  //       message: 'Please enter a valid CRN and amount.',
  //       type: MessageType.warning,
  //     );

  //   }
  // }

  void _removeNoteFromList(CreditNote note) {
    setState(() {
      _addedCreditNotes.remove(note);
    });
  }

  Widget _buildCRNList() {
    return AppDataGrid<CreditNote>(
      items: _addedCreditNotes,
      searchHintText: 'Search by Credit Number',
      filterableFields: ['crnNumber'],
      columns: [
        DynamicColumn<CreditNote>(
          label: 'Credit Note No.',
          flex: 3,
          cellBuilder: (context, item) => Text(item.crnNumber),
        ),
        DynamicColumn<CreditNote>(
          label: 'Credit Note Amount',
          flex: 3,
          cellBuilder: (context, item) => Text(item.amount.toStringAsFixed(2)),
        ),
        DynamicColumn<CreditNote>(
          label: '',
          flex: 1,
          cellBuilder: (context, item) {
            return IconButton(
              icon: const Icon(Icons.close, color: AppColors.disabled),
              onPressed: () => _removeNoteFromList(item),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _crnController.removeListener(() => setState(() {}));
    _amountController.removeListener(() => setState(() {}));
    _crnController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final isAddButtonDisabled =
        _crnController.text.isEmpty ||
        _amountController.text.isEmpty ||
        !isFormValid;
    final bool hasMadeChange = _areListsEqual(_addedCreditNotes, _initialNotes);
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                AppTextField(controller: _crnController, labelText: 'CRN No'),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _amountController,
                  labelText: 'CRN Amount',
                  keyboardType: TextInputType.number,
                  isFinanceNum: true,
                ),
                const SizedBox(height: 24),

                // Add Button
                ActionButton(
                  label: 'Add Credit Note',
                  icon: Icons.add_card, // Example icon
                  onPressed: _addNoteToList,
                  color: AppColors.success,
                  disabled: isAddButtonDisabled,
                ),
                const SizedBox(height: 24),

                SizedBox(height: 300.0, child: _buildCRNList()),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              ActionButton(
                label: 'Submit',
                onPressed: () => widget.onSubmit(_addedCreditNotes),
                disabled: hasMadeChange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
