// --IMPORTANT : REMOVE THIS FILE LATER-- //

// Test Print Screen

import 'package:flutter/material.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
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

  // final dummyNote = DispatchNoteSave(
  //   dispatchNumber: "DN20260224001",
  //   tinNo: "PTIBDM202602170463",
  //   orderNo: "PADC2026021605834",
  //   payOndel: "N",
  //   route: "R01",

  //   dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
  //   dealerVatNo: "VAT123456789",
  //   dealerAddress: "No 199/4 Kanaththa Road, Molligoda, Wadduwa",
  //   dealerId: "AC2018023904",

  //   userId: "USR01",
  //   dispatchTime: DateTime.now(),

  //   noOfBoxes: 1,
  //   noOfTags: 0,
  //   noOfPlasticBoxes: 1,
  //   remarks: "-",
  //   parts: [
  //     Part(
  //       id: '1',
  //       partNo: "03100335",
  //       description: "BEARING NEEDLE [SCE188] - MAINSHAFT",
  //       requestQty: 10,
  //       price: 21.3,
  //     ),
  //     Part(
  //       id: '2',
  //       partNo: "24171094",
  //       description: "SHOCKABSORBER ASSEMBLY - REAR",
  //       requestQty: 6,
  //       price: 4500.00,
  //     ),
  //     Part(
  //       id: '3',
  //       partNo: "39132420",
  //       description: "BEARING BALL [6305] - CRANKSHAFT",
  //       requestQty: 5,
  //       price: 320.50,
  //     ),
  //     Part(
  //       id: '4',
  //       partNo: "39193120",
  //       description: "BEARING BALL - 28 X 68 X 18",
  //       requestQty: 4,
  //       price: 275.75,
  //     ),
  //     Part(
  //       id: '5',
  //       partNo: "AA101108",
  //       description: "GEAR SELECTER",
  //       requestQty: 5,
  //       price: 1890.00,
  //     ),
  //     Part(
  //       id: '6',
  //       partNo: "AA101481",
  //       description: "INNER CLUTCH RELEASE COMPLETE",
  //       requestQty: 5,
  //       price: 2150.00,
  //     ),
  //     Part(
  //       id: '7',
  //       partNo: "AB171044",
  //       description: "SHOCKABSORBER ASSEMBLY COMPLETE - FRONT",
  //       requestQty: 4,
  //       price: 5600.00,
  //     ),
  //     Part(
  //       id: '8',
  //       partNo: "AS00304013",
  //       description: "N/A",
  //       requestQty: 50,
  //       price: 12.00,
  //     ),
  //     Part(
  //       id: '9',
  //       partNo: "DS101277",
  //       description: "TENSIONER ASSEMBLY",
  //       requestQty: 5,
  //       price: 1340.00,
  //     ),
  //   ],
  // );

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
                  {
                    'name': 'Product C with extra text',
                    'qty': 3,
                    'price': 5.25,
                  },
                  {
                    'name': 'Product D with more details and description',
                    'qty': 1,
                    'price': 99.99,
                  },
                ];
                _printerService.previewThermalReceiptTestPdf(
                  items,
                  'Yasindu Ganegoda',
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Preview Test Dispatch Note',
              onPressed: () {
                final details = PrintFooterDetail(
                  formNo: 'PA-FO-53',
                  revNo: '01',
                  docNo: 'DC02',
                );
               // _printerService.previewDispatchNotePdf(dummyNote, details);
              },
            ),
          ],
        ),
      ),
    );
  }
}
