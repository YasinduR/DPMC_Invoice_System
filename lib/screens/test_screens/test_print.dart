// --IMPORTANT : REMOVE THIS FILE LATER-- //

// Test Print Screen  

import 'package:flutter/material.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_page.dart';

class TestPrintPage extends StatefulWidget {
  const TestPrintPage({super.key});

  @override
  State<TestPrintPage> createState() => _TestPrintPageState();
}

class _TestPrintPageState extends State<TestPrintPage> {
  final PrinterService _printerService = PrinterService();

  @override
  void initState() {
    super.initState();
    _printerService.initPrinterServices(); // Initialize the printer service
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Test Printing & Previews',
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Action button for Thermal Receipt Preview
            ActionButton(
              label: 'Preview Test PDF',
              onPressed: () {
                final items = [
                  {'name': 'Product A', 'qty': 2, 'price': 10.50},
                  {'name': 'Product B', 'qty': 1, 'price': 25.00},
                  {'name': 'Product C with extra text', 'qty': 3, 'price': 5.25},
                  {'name': 'Product D with more details and description', 'qty': 1, 'price': 99.99},
                ];
                _printerService.previewThermalReceiptPdf(items, 'Yasindu Ganegoda');
                // showSnackBar(
                //   context: context,
                //   message: 'Generating PDF preview for thermal receipt...',
                //   type: MessageType.success,
                // );
              },
            ),
            // const SizedBox(height: 16),

            // // Action button for Invoice (PDF)
            // ActionButton(
            //   label: 'Print Invoice (PDF)',
            //   onPressed: () {
            //     final invoiceData = {
            //       'customerName': 'Jane Smith',
            //       'customerAddress': '456 Oak Ave',
            //       'customerCity': 'Town, State',
            //       'invoiceNumber': 'INV-2025-001',
            //       'date': '2025-10-24',
            //       'items': [
            //         {'name': 'Consultation Fee', 'qty': 1, 'price': 150.00},
            //         {'name': 'Software License', 'qty': 3, 'price': 50.00},
            //         {'name': 'Support Package', 'qty': 1, 'price': 75.00},
            //       ],
            //       'totalAmount': '375.00', // Manually calculated for example
            //     };
            //     _printerService.generateAndPrintInvoice(invoiceData);
            //     // showSnackBar(
            //     //   context: context,
            //     //   message: 'Generating and opening invoice PDF...',
            //     //   type: MessageType.success,
            //     // );
            //   },
            // ),
            // const SizedBox(height: 16),

            // // Action button for Report (PDF)
            // ActionButton(
            //   label: 'Print Monthly Report (PDF)',
            //   onPressed: () {
            //     _printerService.generateAndPrintReport(
            //       'Monthly Sales Report - Oct 2025',
            //       'This is a detailed report showing sales figures for the past month. Total revenue: \$15,000. Top selling product: Product X. Customer feedback has been positive, indicating good market acceptance for new offerings. Further analysis required for Q4 projections. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            //     );
            //     // showSnackBar(
            //     //   context: context,
            //     //   message: 'Generating and opening monthly report PDF...',
            //     //   type: MessageType.success,
            //     // );
            //   },
            // ),
            // const SizedBox(height: 16),

            // // Optional: Button to show information about thermal printer readiness
            // ActionButton(
            //   label: 'Check Thermal Printer Status (Future)',
            //   onPressed: () {
            //     showInfoDialog(
            //       context: context,
            //       title: 'Thermal Printer Integration',
            //       content: 'The thermal printer commands are being generated internally, but actual printing functionality is not yet active. This feature will be enabled in a future update.',
            //       // You can customize the icon if you have one for info or future features
            //       // icon: Icons.info_outline,
            //     );
            //   },
            //   color: Colors.blueGrey, // Differentiate this button
            // ),
          ],
        ),
      ),
    );
  }
}