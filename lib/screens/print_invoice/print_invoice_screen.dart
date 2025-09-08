import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/providers/region_provider.dart';
// import 'package:myapp/theme/app_theme.dart';
// import 'package:myapp/models/invoic_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/util/api_util.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/views/auth_dealer_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_table.dart';
import 'package:myapp/widgets/dealer_info_card.dart';

// --- MAIN WIDGET: Manages the flow state ---
class PrintInvoiceScreen extends ConsumerStatefulWidget {
  const PrintInvoiceScreen({super.key});

  @override
  ConsumerState<PrintInvoiceScreen> createState() => _PrintInvoiceScreenState();
}

class _PrintInvoiceScreenState extends ConsumerState<PrintInvoiceScreen> {
  int _currentStep = 0;
  //Dealer? _selectedDealer;

  // Regional settings
  Region? _selectedRegion;

  void _onRegionSelected(Region region) {
    setState(() {
      _selectedRegion = region;
    });
  }

  void _submitRegion() {
    if (_selectedRegion != null) {
      ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
      showSnackBar(
        context: context,
        message: 'Region set to: ${_selectedRegion!.region}',
        type: MessageType.success,
      );
      setState(() {
        _currentStep = 0; // Move to the inital
      });
    }
  }

  void _onRegionSelectionRequested() {
    setState(() {
      _currentStep = -1; // Move to Region selection step
    });
  }
  //--- Regional Settings

  // Dealer Selection
  Dealer? _selectedDealer;
  void _onDealerSelected(Dealer dealer) {
    setState(() {
      _selectedDealer = dealer;
    });
  }

  void _submitDealer() {
    if (_selectedDealer != null) {
      setState(() {
        _currentStep = 1; // Move to Authenticate step
      });
    }
  }

  void _onAuthenticated() {
    setState(() {
      _currentStep = 2; // Move to Create Invoice step
    });
  }
  //--- Dealer Selection

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    final selectedRegion = ref.watch(regionProvider).selectedRegion;

    switch (_currentStep) {
      case -1:
        currentView = SelectRegionView(
          selectedRegion: selectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion,
        );
        break;
      case 0:
        currentView = SelectDealerView(
          //dealers: _dealers,
          selectedRegion: selectedRegion,
          selectedDealer: _selectedDealer,
          onDealerSelected: _onDealerSelected,
          onSubmit: _submitDealer, // Pass submit callback
          onRegionSelectionRequested: _onRegionSelectionRequested,
        );
        break;
      case 1:
        currentView = AuthenticateDealerView(
          dealer: _selectedDealer!,
          onAuthenticated: _onAuthenticated,
        );
        break;
      case 2:
        currentView = PrintInvoiceMainScreen(dealer: _selectedDealer!);
        break;
      default:
        currentView = const Center(child: Text('Error: Invalid step'));
    }

    final String currentTitle;
    switch (_currentStep) {
      case -1:
        currentTitle = 'Select Region'; // New title
        break;
      case 0:
        currentTitle = 'Select Dealer';
        break;
      case 1:
        currentTitle = 'Authenticate Dealer';
        break;
      case 2:
        currentTitle = 'Print Invoice';
        break;
      default:
        currentTitle = 'Error';
    }
    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}







class PrintInvoiceMainScreen extends StatefulWidget {
  final Dealer dealer;
  const PrintInvoiceMainScreen({super.key, required this.dealer});

  @override
  State<PrintInvoiceMainScreen> createState() =>
      _PrintInvoiceMainScreenState();
}

class _PrintInvoiceMainScreenState extends State<PrintInvoiceMainScreen> {
  List<TinInvoice> _availableTins = [];
  final List<TinInvoice> _selectedTins = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadTinInvoices();
  }


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
  /// Toggles the selection state of a given TIN invoice.
  void _onTinToggle(TinInvoice invoice) {
    setState(() {
      if (_selectedTins.contains(invoice)) {
        _selectedTins.remove(invoice);
      } else {
        _selectedTins.add(invoice);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // No top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          DealerInfoCard(dealer: widget.dealer),
          const SizedBox(height: 16),
          Expanded(child: _buildTinInvoiceArea()),
          const SizedBox(height: 16),
          _buildConfirmationBox(),
          const SizedBox(height: 20),
          ActionButton(
            icon: Icons.handshake_outlined,
            label: 'Agree (${_selectedTins.length})',
            onPressed: () {
              // Only proceed if at least one item is selected
              if (_selectedTins.isEmpty) {
                showSnackBar(
                  context: context,
                  message: "Please select at least one invoice to confirm.",
                  type: MessageType.warning,
                );
                return;
              }
              showSnackBar(
                context: context,
                message:
                    "Print Success! Confirmed ${_selectedTins.length} items.",
                type: MessageType.success,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the TIN invoice list area.
  Widget _buildTinInvoiceArea() {
    if (_isLoading) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading Invoices for the Dealer...'),
        ],
      ));
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }
    if (_availableTins.isEmpty) {
      return const Center(
          child: Text('No outstanding TINs found for this dealer.'));
    }
    return FilterableListView<TinInvoice>(
      hasFilter: false, // <-- Hides the filter/search bar
      items: _availableTins,
      // filterableFields are still required, even if the UI is hidden
      filterableFields: const ['tinNo', 'invAmount'],
      columns: [
        // Column 1: Invoice Number (using tinNo)
        DynamicColumn<TinInvoice>(
          label: 'Invoice Number',
          flex: 5,
          cellBuilder: (context, invoice) => Text(invoice.tinNo),
        ),
        // Column 2: Invoice Amount
        DynamicColumn<TinInvoice>(
          label: 'Amount',
          flex: 3,
          cellBuilder: (context, invoice) => Text(
              invoice.invAmount.toStringAsFixed(2),
              textAlign: TextAlign.right),
        ),
        // Column 3: Selection Checkbox
        DynamicColumn<TinInvoice>(
          label: 'Confirm',
          flex: 2,
          cellBuilder: (context, invoice) => Center(
            child: Checkbox(
              value: _selectedTins.contains(invoice),
              onChanged: (bool? value) {
                _onTinToggle(invoice);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: const Text(
        'Above all items were received in good condition',
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.w500),
      ),
    );
  }
}


















// class PrintInvoiceMainScreen extends StatelessWidget {



  
//   final Dealer dealer;
//   const PrintInvoiceMainScreen({super.key, required this.dealer});

//   final List<InvoiceItem> _invoiceItems = const [
//     InvoiceItem(invoiceNumber: 'MIN2025111700000567', invoiceAmount: '24000'),
//     InvoiceItem(invoiceNumber: 'MIN2025111700000444', invoiceAmount: '24000'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // No top padding
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 24),
//           DealerInfoCard(dealer: dealer),
//           const SizedBox(height: 16),
//           _buildInvoiceTable(),
//           const Spacer(),
//           _buildConfirmationBox(),
//           const SizedBox(height: 20),

//           ActionButton(
//             icon: Icons.handshake_outlined,
//             label: 'Agree',
//             onPressed: () {
//               showSnackBar(
//                 context: context,
//                 message: "Print Success !",
//                 type: MessageType.success,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build the invoice list
//   Widget _buildInvoiceTable() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           // Table Header
//           const Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Text(
//                   'Invoice Number',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   'Invoice Amount',
//                   textAlign: TextAlign.right,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5),

//           // Table Rows from data
//           ..._invoiceItems
//               .map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Text(
//                           item.invoiceNumber,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           item.invoiceAmount,
//                           textAlign: TextAlign.right,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfirmationBox() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: AppColors.success.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.success.withOpacity(0.5)),
//       ),
//       child: const Text(
//         'Above all items were received in good condition',
//         style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }
