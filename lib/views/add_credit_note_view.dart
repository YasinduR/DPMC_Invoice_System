import 'package:flutter/material.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/credit_note_model.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_table.dart';
import 'package:myapp/widgets/text_form_field.dart';

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
  final _crnController = TextEditingController();
  final _amountController = TextEditingController();
  // final List<CreditNote> _addedCreditNotes = [];
  late final List<CreditNote> _addedCreditNotes;

  @override
  void initState() {
    super.initState();
    // Initialize the local list with a *copy* of the list passed from the parent.
    // This is important so that changes are only saved when the user hits 'Submit'.
    _addedCreditNotes = List<CreditNote>.from(widget.initialNotes);
  }

  void _addNoteToList() {
    final crn = _crnController.text;
    final amount = double.tryParse(_amountController.text);

    if (crn.isNotEmpty && amount != null && amount > 0) {
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
      // Optional: Show an error message if input is invalid
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please enter a valid CRN and amount.')),
      // );
    }
  }

  void _removeNoteFromList(CreditNote note) {
    setState(() {
      _addedCreditNotes.remove(note);
    });
  }

  Widget _buildCRNList() {
    return FilterableListView<CreditNote>(
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
    _crnController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
          AppTextField(controller: _crnController, labelText: 'CRN No'),
          const SizedBox(height: 16),

          AppTextField(
            controller: _amountController,
            labelText: 'CRN Amount',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),

          // Add Button
          ActionButton(
            label: 'Add Credit Note',
            icon: Icons.add_card, // Example icon
            onPressed: _addNoteToList,
            color: AppColors.success,
          ),
          const SizedBox(height: 24),

          // // This Expanded widget will contain your scrollable list
          // Expanded(
          //   child:
          //       _buildCRNList(), // Assuming this returns a scrollable widget like ListView
          // ),

          // const SizedBox(height: 16),

          SizedBox(
                height: 300.0,
                child: _buildCRNList(),
              )
              ]

           )),
           
                  Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          const SizedBox(height: 16),
          ActionButton(
            label: 'Submit',
            onPressed: () => widget.onSubmit(_addedCreditNotes),
            disabled: _addedCreditNotes.isEmpty,
          ),
            ],
          ),
        ),
        ]


           
           );
          // AppTextField(controller: _crnController, labelText: 'CRN No'),
          // const SizedBox(height: 16),

          // AppTextField(
          //   controller: _amountController,
          //   labelText: 'CRN Amount',
          //   keyboardType: TextInputType.number,
          // ),
          // const SizedBox(height: 24),

          // // Add Button
          // ActionButton(
          //   label: 'Add Credit Note',
          //   icon: Icons.add_card, // Example icon
          //   onPressed: _addNoteToList,
          //   color: AppColors.success,
          // ),
          // const SizedBox(height: 24),

          // // This Expanded widget will contain your scrollable list
          // Expanded(
          //   child:
          //       _buildCRNList(), // Assuming this returns a scrollable widget like ListView
          // ),

          // const SizedBox(height: 16),

          // SizedBox(
          //       height: 300.0,
          //       child: _buildCRNList(),
          //     ),

          // Table of Added Notes
          // Expanded(
          //   child: FilterableListView<CreditNote>(
          //     items: _addedCreditNotes,
          //     searchHintText: 'Search by Credit Number',
          //     filterableFields: ['crnNumber'],
          //     columns: [
          //       DynamicColumn<CreditNote>(
          //         label: 'Credit Note No.',
          //         flex: 3,
          //         cellBuilder: (context, item) => Text(item.crnNumber),
          //       ),
          //       DynamicColumn<CreditNote>(
          //         label: 'Credit Note Amount',
          //         flex: 3,
          //         cellBuilder:
          //             (context, item) => Text(item.amount.toStringAsFixed(2)),
          //       ),
          //       DynamicColumn<CreditNote>(
          //         label: '',
          //         flex: 1,
          //         cellBuilder: (context, item) {
          //           return IconButton(
          //             icon: const Icon(Icons.close, color: AppColors.disabled),
          //             onPressed: () => _removeNoteFromList(item),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),

    //       const SizedBox(height: 16),
    //       ActionButton(
    //         label: 'Submit',
    //         onPressed: () => widget.onSubmit(_addedCreditNotes),
    //         disabled: _addedCreditNotes.isEmpty,
    //       ),
    //     ],
    //   ),
    // );
  }
}
