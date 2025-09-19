// Step 3 TIN Number Selection
import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';
//import 'package:myapp/widgets/old/custom_selection_form_field.dart';
import 'package:myapp/widgets/cards/dealer_info_card.dart';
//import 'package:myapp/widgets/selection_sheet.dart';

class SelectTinNumberView extends StatefulWidget {
  final Dealer dealer;
  //final List<TinData> tins;
  final Function(TinData) onTinNumberSelected;
  final VoidCallback onSubmit;
  final TinData? selectedTin;

  const SelectTinNumberView({
    super.key,
    //required this.tins,
    required this.onTinNumberSelected,
    required this.onSubmit,
    required this.dealer,
    this.selectedTin,
  });

  @override
  State<SelectTinNumberView> createState() => _SelectTinNumberViewState();
}

class _SelectTinNumberViewState extends State<SelectTinNumberView> {
  final TextEditingController _tinController = TextEditingController();
  // State to track if the selection is valid and committed.
  bool _isTinSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    // If a TIN is pre-selected, populate the controller and set the initial state.
    if (widget.selectedTin != null) {
      _tinController.text = widget.selectedTin!.tinNumber;
      _isTinSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display dealer information at the top.
          DealerInfoCard(dealer: widget.dealer),
          const SizedBox(height: 16),

          // Use the reusable AppSelectionField for TIN selection.
          AppSelectionField<TinData>(
            controller: _tinController,
            labelText: 'Select TIN Number',
            selectionSheetTitle: 'Select a TIN Number',
            initialValue: widget.selectedTin,
            //items: widget.tins,
            onSelected: widget.onTinNumberSelected,
           // displayString: (tin) => tin.tinNumber,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isTinSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['TIN Number', 'Total Value'],
            valueFields: const ['tinNumber', 'totalValue'],
            mainField: 'tinNumber',
            dataUrl: 'api/tins/list',
          ),

          const Spacer(),

          // The submit button's state is now controlled by the selection field.
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isTinSelectionCommitted,
          ),
        ],
      ),
    );
  }
}

// class SelectTinNumberView extends StatefulWidget {
//   final Dealer dealer;
//   final List<TinData> tins;
//   final Function(TinData) onTinNumberSelected;
//   final VoidCallback onSubmit;
//   final TinData? selectedTin;

//   const SelectTinNumberView({
//     super.key,
//     required this.tins,
//     required this.onTinNumberSelected,
//     required this.onSubmit,
//     required this.dealer,
//     this.selectedTin,
//   });

//   @override
//   State<SelectTinNumberView> createState() => _SelectTinNumberViewState();
// }

// class _SelectTinNumberViewState extends State<SelectTinNumberView> {
//   // State variables for filtering logic.
//   late List<TinData> _filteredTins;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the filtered list with all TINs.
//     _filteredTins = widget.tins;
//     // Add a listener to handle filtering as the user types.
//     _searchController.addListener(_filterTins);
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is removed.
//     _searchController.dispose();
//     super.dispose();
//   }

//   // Function to filter the list of TINs based on the search query.
//   void _filterTins() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredTins =
//           widget.tins.where((tin) {
//             // Search by both TIN number and total value.
//             return tin.tinNumber.toLowerCase().contains(query) ||
//                 tin.totalValue.toString().toLowerCase().contains(query);
//           }).toList();
//     });
//   }

//   // Shows the modal bottom sheet for TIN selection.
//   Future<void> _showTinSelection(BuildContext context) async {
//     final selectedTin = await showModalBottomSheet<TinData>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return SelectionSheet<TinData>(
//           title: 'Select TIN Number',
//           items: _filteredTins, // Use the filtered list.
//           searchController: _searchController, // Pass the search controller.
//           headerBuilder: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   'TIN Number',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   'Total Value',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           itemBuilder: (TinData tin) {
//             return InkWell(
//               onTap: () => Navigator.of(context).pop(tin),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 12.0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(child: Text(tin.tinNumber)),
//                     Expanded(
//                       child: Text(tin.totalValue.toStringAsFixed(2)),
//                     ), // Format value for display
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//     if (selectedTin != null) {
//       widget.onTinNumberSelected(selectedTin);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DealerInfoCard(dealer: widget.dealer),
//           const SizedBox(height: 16),
//           CustomSelectionFormField<TinData>(
//             labelText: 'Select TIN Number',
//             selectedValue: widget.selectedTin,
//             displayString: (tin) => tin.tinNumber,
//             onShowPicker: _showTinSelection,
//           ),
//           const Spacer(),
//           ActionButton(
//             icon: Icons.check_circle_outline,
//             label: 'Submit',
//             onPressed: widget.onSubmit,
//             disabled: widget.selectedTin == null,
//           ),
//         ],
//       ),
//     );
//   }
// }
