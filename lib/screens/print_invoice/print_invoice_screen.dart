
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/views/print_invoice_view.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/views/auth_dealer_view.dart';
import 'package:myapp/widgets/app_page.dart';


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
