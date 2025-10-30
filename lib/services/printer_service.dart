import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List

// For thermal printers (ESC/POS) - keeping for future implementation
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // For future Bluetooth connection
import 'package:intl/intl.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/reciept_model.dart';
import 'package:myapp/models/return_save_model.dart';

// For PDF printing and preview
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrinterService {
  // --- Thermal Printer (ESC/POS) related - for future use ---
  // FlutterBluePlus _flutterBlue = FlutterBluePlus.instance; // For future Bluetooth scanning/connection
  // BluetoothDevice _connectedDevice; // To store a connected printer device

  late CapabilityProfile _profile; // Loaded once for ESC/POS command generation
  final String CompanyName = 'David Pieris Motor Company (Pvt) Ltd';
  final String CompanyAddress = '120, 120A,Pannipitya Road, Battaramulla.';
  final String CompanyContact = 'Tel: 014419300, Fax: 0114700101';

  Future<void> initPrinterServices() async {
    _profile = await CapabilityProfile.load(); //
    // No actual thermal printer connection logic here for now.
    // This method is kept for future expansion of thermal printing.
  }

  // Helpers For PDF previews
  // Company Header Along with Print Title
  pw.Column _companyHeaderPdf(String topic) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          CompanyName,
          style: const pw.TextStyle(fontSize: 10), // Standard font size
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          CompanyAddress,
          style: const pw.TextStyle(fontSize: 10), // Standard font size
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          CompanyContact,
          style: const pw.TextStyle(fontSize: 10), // Standard font size
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          topic.toUpperCase(), // Ensure topic is uppercase as in the image
          style: const pw.TextStyle(fontSize: 10), // Standard font size
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 20), // Space after the topic
      ],
    );
  }

  // Helper for label : Value Table Rows
  pw.TableRow _buildDetailTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10), // Label text
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            ':',
            style: const pw.TextStyle(fontSize: 10), // Colon
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10), // Value text
          ),
        ),
      ],
    );
  }

  // End of Helpers
  // PDF Previews
  // --- Return PDF method ---
  Future<void> previewThermalReturnPdf(Return returnObj) async {
    final pdf = pw.Document();
    final formattedReturnDate = DateFormat(
      'yyyy/MM/dd',
    ).format(returnObj.returnTime);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Company Header
              _companyHeaderPdf(returnObj.returnType),

              pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5), // For labels like 'Route'
                  1: const pw.FixedColumnWidth(
                    8,
                  ), // For the colon ':' - fixed small width
                  2: const pw.FlexColumnWidth(5.5), // For values
                },
                children: [
                  _buildDetailTableRow('Route', returnObj.route.toUpperCase()),
                  _buildDetailTableRow('TIN No', returnObj.tinNo.toUpperCase()),
                  _buildDetailTableRow(
                    'Dealer Name',
                    returnObj.dealerName.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'User',
                    returnObj.userId.toUpperCase(),
                  ), // Using userId as per your model
                  _buildDetailTableRow(
                    'Return Date',
                    formattedReturnDate.toUpperCase(),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'Return Reason : ${returnObj.returnReason}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),

              pw.SizedBox(height: 10), // Space before the table
              pw.Divider(thickness: 0.5),

              // Return Items Table
              pw.Table.fromTextArray(
                headers: ['Part No', 'Req. Qty', 'Ret. Qty'],
                data:
                    returnObj.returnItems.map((item) {
                      return [
                        item.partNo,
                        item.requestQty.toString(),
                        item.returnQty.toString(),
                      ];
                    }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10), // Not bold
                cellAlignments: {
                  0: pw.Alignment.centerLeft, // Part column
                  1: pw.Alignment.centerRight, // Requested Quantity
                  2: pw.Alignment.centerRight, // Returned Quantity
                },
                headerAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.2),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.8),
                },
                border: null,
                headerDecoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 20),

              // Signature Section
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  '         -----------------                  -----------------',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  '     Dealer Signature         Driver Signature',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  '      Dealer Stamp        ',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    '-----------------',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    'Security Sig. & Stamp',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              // SIGNATURE SECTION
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Invoice PDF
  Future<void> previewThermalInvoicePdf(InvoiceSave invoiceObj) async {
    final pdf = pw.Document();
    final formattedInvoiceDate = DateFormat(
      'yyyy/MM/dd',
    ).format(invoiceObj.invoiceTime);

    // Function to build the common invoice page content
    pw.Page _buildInvoicePageContent(String headerText) {
      return pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Company Header (dynamic based on headerText)
              _companyHeaderPdf(headerText),

              // Address Section
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('To:', style: pw.TextStyle(fontSize: 10)),
                  pw.Text(
                    invoiceObj.dealerName,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    invoiceObj.dealerAddress,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),

              // Invoice Details Table
              pw.Table(
                border: null,
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FixedColumnWidth(8),
                  2: const pw.FlexColumnWidth(5.5),
                },
                children: [
                  _buildDetailTableRow(
                    'A/C No',
                    invoiceObj.dealerId.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'Order No',
                    invoiceObj.orderNo.toUpperCase(),
                  ),
                  _buildDetailTableRow('Route', invoiceObj.route.toUpperCase()),
                  _buildDetailTableRow(
                    'VAT',
                    invoiceObj.dealerVatNo.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'Invoice No',
                    invoiceObj.invoiceNumber.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'TIN No',
                    invoiceObj.tinNo.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'Pay on Del',
                    invoiceObj.payOndel.toUpperCase(),
                  ),
                  _buildDetailTableRow('User', invoiceObj.userId.toUpperCase()),
                  _buildDetailTableRow(
                    'Date',
                    formattedInvoiceDate.toUpperCase(),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              pw.SizedBox(
                width: 200,
                child: // // Parts Table
                    pw.Table(
                  border: null,
                  tableWidth: pw.TableWidth.max,
                  columnWidths: {
                    0: const pw.FlexColumnWidth(
                      1,
                    ), // Changed to FlexColumnWidth to absorb remaining space
                    1: const pw.FixedColumnWidth(40),
                    2: const pw.FixedColumnWidth(30),
                    3: const pw.FixedColumnWidth(50),
                  },
                  children: [
                    // Header Row
                    pw.TableRow(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Part No.',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              'Description',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              'Unit Rs.',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Qty',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Disc',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Net Sale',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Data Rows for each item
                    ...invoiceObj.parts.map((item) {
                      final netSale =
                          (item.price - item.discount) * item.receivedQty;
                      return pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.bottom,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                item.partNo,
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                              pw.Text(
                                item.description,
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                              pw.Text(
                                item.price.toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              item.receivedQty.toString(),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              item.discount.toStringAsFixed(2),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              netSale.toStringAsFixed(2),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 5),

              // Total Amount section
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      invoiceObj.invoiceAmount.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    pw.Text(
                      '=================',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              // "Above goods received" text
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Above goods recieved in good condition',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Add the Customer Copy page using the common method
    pdf.addPage(_buildInvoicePageContent('CREDIT INVOICE - CUSTOMER COPY'));

    // Add the Office Copy page using the common method
    pdf.addPage(_buildInvoicePageContent('CREDIT INVOICE - OFFICE COPY'));

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- Return PDF method ---
  Future<void> previewThermalReceiptPdf(Receipt recObj) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('yyyy/MM/dd').format(recObj.recieptTime);
    final formattedDepDate = DateFormat('yyyy/MM/dd').format(recObj.chequeDate);
    final double fontSize = 10;
    final double chequeAmount = recObj.chequeAmount;
    final double totalCreditNoteAmount = recObj.creditNotes.fold(
      0.0,
      (sum, note) => sum + note.amount,
    );


    
  // Helper for label : Value Table Rows
  pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10), // Label text
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            ' ',
            style: const pw.TextStyle(fontSize: 10), // Colon
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10), // Value text
          ),
        ),
      ],
    );
  }

    pw.TableRow _buildBoldTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            label,
              style: pw.TextStyle(fontSize: fontSize,fontWeight: pw.FontWeight.bold,), // Value text
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            ' ',
              style: pw.TextStyle(fontSize: fontSize,fontWeight: pw.FontWeight.bold,), // Value text
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            value,
              style: pw.TextStyle(fontSize: fontSize,fontWeight: pw.FontWeight.bold,), // Value text
          ),
        ),
      ],
    );
  }


    // pw.TableRow _buildTableRow(String label, String value) {
    //   return pw.TableRow(
    //     children: [
    //       pw.Align(
    //         alignment: pw.Alignment.centerLeft,
    //         child: pw.Text(
    //           label,
    //           style: pw.TextStyle(fontSize: fontSize), // Label text
    //         ),
    //       ),
    //       pw.Align(
    //         alignment: pw.Alignment.centerLeft,
    //         child: pw.Text(
    //           value,
    //           style: pw.TextStyle(fontSize: fontSize), // Value text
    //         ),
    //       ),
    //     ],
    //   );
    // }

    //     pw.TableRow _buildBoldTableRow(String label, String value) {
    //   return pw.TableRow(
    //     children: [
    //       pw.Align(
    //         alignment: pw.Alignment.centerLeft,
    //         child: pw.Text(
    //           label,
    //           style: pw.TextStyle(fontSize: fontSize,fontWeight: pw.FontWeight.bold,), // Label text
    //         ),
    //       ),
    //       pw.Align(
    //         alignment: pw.Alignment.centerLeft,
    //         child: pw.Text(
    //           value,
    //           style: pw.TextStyle(fontSize: fontSize,fontWeight: pw.FontWeight.bold,), // Value text
    //         ),
    //       ),
    //     ],
    //   );
    // }

    pw.TableRow _buildSingleRow(String label) {
      return pw.TableRow(
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: fontSize), // Label text
            ),
          )
        ],
      );
    }

    // final totalDue = recObj.tins.fold(
    //   Decimal.zero,
    //   (sum, tin) => sum + Decimal.parse(tin.invAmount.toString()),
    // );

    final totalPayment = Decimal.parse(
      (totalCreditNoteAmount + chequeAmount).toString(),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Company Header
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'PROVISIONAL RECEIPT',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
              _companyHeaderPdf('OFFICE'),

              pw.Divider(thickness: 0.5),
              pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5), // For labels like 'Route'
                  1: const pw.FixedColumnWidth(
                    8,
                  ), // For the colon ':' - fixed small width
                  2: const pw.FlexColumnWidth(5.5), // For values
                },
                children: [
                  _buildDetailTableRow('Date', formattedDate),
                  _buildDetailTableRow(
                    'Cashier Code',
                    recObj.userId.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'AC No',
                    recObj.dealerCode.toUpperCase(),
                  ),
                  _buildDetailTableRow(
                    'Receipt No',
                    recObj.recieptNo.toUpperCase(),
                  ), // Using userId as per your model
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),

               pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(1), // For labels like 'Route'
                },
                children: [
                  _buildSingleRow('Recieved with Thanks'),
                  _buildSingleRow('Being Settlement of'),

                ],
              ),
              // pw.Text(
              //   'Recieved with Thanks',
              //   style: pw.TextStyle(fontSize: fontSize),
              // ),
             // pw.SizedBox(height: 10),
             // pw.Text('Being Settlement of', style: pw.TextStyle(fontSize: fontSize)),
              // pw.Table.fromTextArray(
              //   headers: ['Invoice Numbers', 'Amount'],
              //   data:
              //       recObj.tins.map((tin) {
              //         return [tin.mobileInvNo, tin.invAmount];
              //       }).toList(),
              //   headerStyle: pw.TextStyle(
              //     fontWeight: pw.FontWeight.bold,
              //     fontSize: fontSize,
              //   ),
              //   cellStyle: pw.TextStyle(fontSize: fontSize), // Not bold
              //   cellAlignments: {
              //     0: pw.Alignment.centerLeft, // Part column
              //     1: pw.Alignment.centerRight, // Requested Quantity
              //   },
              //   headerAlignments: {
              //     0: pw.Alignment.centerLeft,
              //     1: pw.Alignment.centerRight,
              //   },
              //   columnWidths: {
              //     0: const pw.FlexColumnWidth(2),
              //     1: const pw.FlexColumnWidth(1),
              //   },
              //   border: null,
              //   headerDecoration: const pw.BoxDecoration(
              //     border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
              //   ),
              // ),
              // pw.SizedBox(height: 10), // Space before the table
              pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(4), // For labels like 'Route'
                  1: const pw.FixedColumnWidth(
                    8,
                  ), // For the colon ':' - fixed small width
                  2: const pw.FlexColumnWidth(3), // For values
                },
                children: [
                    
                    _buildBoldTableRow(
                    'Invoice Numbers',
                    'Amount (Rs.)',
                  ),
                  //   _buildDetailTableRowmod(
                  //   '   ',
                  //   '   ',
                  // ),
                      ...recObj.tins.map(
      (item) => _buildTableRow(
        item.mobileInvNo.toString(), // Assuming mobileInvNo can be directly converted to string
        item.invAmount.toStringAsFixed(2), // Assuming invAmount is a double and needs formatting
      ),
    ),
                ],
              ),
            pw.Divider(thickness: 0.5),
                pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(4), // For labels like 'Route'
                  1: const pw.FixedColumnWidth(
                    8,
                  ), // For the colon ':' - fixed small width
                  2: const pw.FlexColumnWidth(3), // For values
                },
                children: [
                  _buildTableRow(
                    'Total Amount',
                    totalPayment.toStringAsFixed(2),
                  ),
                  _buildTableRow(
                    'Total Claimable Amount',
                    '(   -' + totalCreditNoteAmount.toStringAsFixed(2) + ')',
                  ),
                  _buildTableRow(
                    'Total Amount Recieved',
                    chequeAmount.toStringAsFixed(2),
                  ),
                 _buildTableRow('', '==========='),
                ],
              ),
              pw.SizedBox(height: 10),
                pw.Table(
                border: null, // No border for a clean look
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  // 1: const pw.FixedColumnWidth(8),
                  // 2: const pw.FlexColumnWidth(4),
                },
                children: [
                  _buildSingleRow('Payment Method: Cheque'),
                  _buildSingleRow('Bank and Branch:'),
                  _buildSingleRow('  ${recObj.branchName.toUpperCase()}'),
                   _buildSingleRow('Check No / Card No: ${recObj.chequeNumber.toUpperCase()}'),
                   _buildSingleRow('To be Deposited Date: $formattedDepDate'),
                  // _buildDetailTableRow(
                  //   'Bank and Branch',
                  //   recObj.branchName.toUpperCase(),
                  // ),
                  // _buildDetailTableRow(
                  //   'Check No / Card No',
                  //   recObj.chequeNumber,
                  // ),
                  // _buildDetailTableRow(
                  //   'To be Deposited Date',
                  //   formattedDepDate,
                  // ), // Using userId as per your model
                ],
              ),
              // pw.Table(
              //   border: null, // No border for a clean look
              //   columnWidths: {
              //     0: const pw.FlexColumnWidth(3),
              //     1: const pw.FixedColumnWidth(8),
              //     2: const pw.FlexColumnWidth(4),
              //   },
              //   children: [
              //     _buildDetailTableRow('Payment Method', 'Cheque'),
              //     _buildDetailTableRow(
              //       'Bank and Branch',
              //       recObj.branchName.toUpperCase(),
              //     ),
              //     _buildDetailTableRow(
              //       'Check No/ Card No',
              //       recObj.chequeNumber,
              //     ),
              //     _buildDetailTableRow(
              //       'To be Deposited Date',
              //       formattedDepDate,
              //     ), // Using userId as per your model
              //   ],
              // ),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  // Future<void> previewThermalInvoicePdf(InvoiceSave invoiceObj) async {
  //   final pdf = pw.Document();
  //   final formattedInvoiceDate = DateFormat('yyyy/MM/dd').format(invoiceObj.invoiceTime);

  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.roll80,
  //       margin: const pw.EdgeInsets.all(10),
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             // Company Header
  //             _companyHeaderPdf('CREDIT INVOICE - CUSTOMER COPY'),

  //             // Address Section (already left-aligned with crossAxisAlignment.start)
  //             pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start, // Ensures left alignment
  //               children: [
  //                 pw.Text('To:', style: pw.TextStyle(fontSize: 10)),
  //                 pw.Text(invoiceObj.dealerName, style: pw.TextStyle(fontSize: 10)),
  //                 pw.Text(invoiceObj.dealerAddress, style: pw.TextStyle(fontSize: 10)),
  //               ],
  //             ),
  //             pw.SizedBox(height: 15),

  //             // Invoice Details Table
  //             pw.Table(
  //               border: null,
  //               columnWidths: {
  //                 0: const pw.FlexColumnWidth(2.5),
  //                 1: const pw.FixedColumnWidth(8),
  //                 2: const pw.FlexColumnWidth(5.5),
  //               },
  //               children: [
  //                 _buildDetailTableRow('A/C No', invoiceObj.dealerId.toUpperCase()),
  //                 _buildDetailTableRow('Order No', invoiceObj.orderNo.toUpperCase()),
  //                 _buildDetailTableRow('Route', invoiceObj.route.toUpperCase()),
  //                 _buildDetailTableRow('VAT', invoiceObj.dealerVatNo.toUpperCase()),
  //                 _buildDetailTableRow('Invoice No', invoiceObj.invoiceNumber.toUpperCase()),
  //                 _buildDetailTableRow('TIN No', invoiceObj.tinNo.toUpperCase()),
  //                 _buildDetailTableRow('Pay on Del', invoiceObj.payOndel.toUpperCase()),
  //                 _buildDetailTableRow('User', invoiceObj.userId.toUpperCase()),
  //                 _buildDetailTableRow('Date', formattedInvoiceDate.toUpperCase()),
  //               ],
  //             ),
  //             pw.SizedBox(height: 10),

  //             // Parts Table (custom structure to match the image with Unit Price under Description)
  //             pw.Table(
  //               border: null,
  //               tableWidth: pw.TableWidth.max, // Use maximum available width
  //               columnWidths: {
  //                 // 0: const pw.FlexColumnWidth(2.5), // Combined: Description -- Part No. and Unit Rs.
  //                 // 1: const pw.FlexColumnWidth(1), // Qty
  //                 // 2: const pw.FlexColumnWidth(1), // Disc
  //                 // 3: const pw.FlexColumnWidth(1.5), // Net Sale
  //                 0: const pw.FixedColumnWidth(70), // Combined: Description -- Part No. and Unit Rs.
  //                 1: const pw.FixedColumnWidth(40), // Qty
  //                 2: const pw.FixedColumnWidth(30), // Disc
  //                 3: const pw.FixedColumnWidth(50), // Net Sale
  //               //  4: const pw.FixedColumnWidth(55.0), // Net Sale
  //               },
  //               children: [
  //                 // Header Row
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Column( // Combined header for Description -- Part No. and Unit Rs.
  //                       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                       children: [
  //                         pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                         pw.Text('Part No.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                         pw.Text('Unit Rs.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                       ],
  //                     ),
  //                     pw.Align(
  //                       alignment: pw.Alignment.centerRight, // Align header for Qty
  //                       child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                     ),
  //                     pw.Align(
  //                       alignment: pw.Alignment.centerRight, // Align header for Disc
  //                       child: pw.Text('Disc', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                     ),
  //                     pw.Align(
  //                       alignment: pw.Alignment.centerRight, // Align header for Net Sale
  //                       child: pw.Text('Net Sale', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
  //                     ),
  //                   ],
  //                 ),
  //                 // Data Rows for each item
  //                 ...invoiceObj.parts.map((item) {
  //                   final netSale = (item.price - item.discount) * item.receivedQty;
  //                   return pw.TableRow(
  //                     // Important: Align content to the bottom of the row to match the image's baseline
  //                     verticalAlignment: pw.TableCellVerticalAlignment.bottom,
  //                     children: [
  //                       // First column: Part No., Description (N/A), and Unit Price
  //                       pw.Column(
  //                         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                         children: [
  //                           pw.Text(item.partNo, style: const pw.TextStyle(fontSize: 10)),
  //                           pw.Text(item.description, style: const pw.TextStyle(fontSize: 10)),
  //                           pw.Text(item.price.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 10)), // Unit Price here
  //                         ],
  //                       ),
  //                       // Quantity
  //                       pw.Align(
  //                         alignment: pw.Alignment.centerRight,
  //                         child: pw.Text(item.receivedQty.toString(), style: const pw.TextStyle(fontSize: 10)),
  //                       ),
  //                       // Discount
  //                       pw.Align(
  //                         alignment: pw.Alignment.centerRight,
  //                         child: pw.Text(item.discount.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 10)),
  //                       ),
  //                       // Net Sale
  //                       pw.Align(
  //                         alignment: pw.Alignment.centerRight,
  //                         child: pw.Text(netSale.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 10)),
  //                       ),
  //                     ],
  //                   );
  //                 }),
  //               ],
  //             ),

  //             pw.Divider(thickness: 0.5),
  //             pw.SizedBox(height: 5),

  //             // Total Amount section (moved to bottom right)
  //             pw.Align(
  //               alignment: pw.Alignment.centerRight, // Aligns the Column to the right
  //               child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.end, // Ensures text within the column is right-aligned
  //                 children: [
  //                   pw.Text(
  //                     invoiceObj.invoiceAmount.toStringAsFixed(2),
  //                     style: pw.TextStyle(
  //                       fontWeight: pw.FontWeight.bold,
  //                       fontSize: 10,
  //                     ),
  //                   ),
  //                   pw.Text('=================', style: pw.TextStyle(fontSize: 10)),
  //                 ],
  //               ),
  //             ),
  //             pw.SizedBox(height: 10), // Space between total and "Above goods..."
  //             // "Above goods received" text (centered)
  //             pw.Align(
  //               alignment: pw.Alignment.center,
  //               child: pw.Text(
  //                 'Above goods recieved in good condition',
  //                 style: pw.TextStyle(
  //                   fontWeight: pw.FontWeight.bold,
  //                   fontSize: 10,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }
  // --- Invoice PDF method --
  // Future<void> previewThermalInvoicePdf(InvoiceSave invoiceObj) async {
  //     final pdf = pw.Document();
  //     final formattedInvoiceDate = DateFormat('yyyy/MM/dd').format(invoiceObj.invoiceTime);
  //     pdf.addPage(
  //       pw.Page(
  //         pageFormat: PdfPageFormat.roll80,
  //         margin: const pw.EdgeInsets.all(10),
  //         build: (pw.Context context) {
  //           return pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.center,
  //             children: [
  //               // Company Header
  //               _companyHeaderPdf('CREDIT INVOICE - CUSTOMER COPY'),

  //               pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 pw.Text('To:', style: pw.TextStyle(fontSize: 10)),
  //                 pw.Text(invoiceObj.dealerName, style:  pw.TextStyle(fontSize: 10)),
  //                 pw.Text(invoiceObj.dealerAddress, style:  pw.TextStyle(fontSize: 10)),
  //               ],
  //             ),
  //              pw.SizedBox(height: 15),
  //               pw.Table(
  //       border: null, // No border for a clean look
  //       columnWidths: {
  //         0: const pw.FlexColumnWidth(2.5), // For labels like 'Route'
  //         1: const pw.FixedColumnWidth(8), // For the colon ':' - fixed small width
  //         2: const pw.FlexColumnWidth(5.5), // For values
  //       },
  //       children: [
  //         _buildDetailTableRow('A/C No', invoiceObj.dealerId.toUpperCase()),
  //         _buildDetailTableRow('Order No', invoiceObj.orderNo.toUpperCase()),
  //         _buildDetailTableRow('Route', invoiceObj.route.toUpperCase()),
  //         _buildDetailTableRow('VAT', invoiceObj.dealerVatNo.toUpperCase()),
  //         _buildDetailTableRow('Invoice No', invoiceObj.invoiceNumber.toUpperCase()),
  //         _buildDetailTableRow('TIN No', invoiceObj.tinNo.toUpperCase()),
  //         _buildDetailTableRow('Pay on Del', invoiceObj.payOndel.toUpperCase()),
  //         _buildDetailTableRow('User', invoiceObj.userId.toUpperCase()), // Using userId as per your model
  //         _buildDetailTableRow('Date', formattedInvoiceDate.toUpperCase()),
  //       ],
  //     ),
  //               pw.SizedBox(height: 10), // Space before the table
  //               pw.Divider(thickness: 0.5),
  //               pw.Table.fromTextArray(
  //   headers: ['Part No', 'Quantity', 'Unit', 'Net Sale'], // Added 'Net Sale' header
  //   data: invoiceObj.parts.map((item) {
  //     final netSale = item.price * item.receivedQty; // Calculate net sale
  //     return [
  //       item.partNo,
  //       item.receivedQty.toString(),
  //       item.price.toStringAsFixed(2), // Formats price to two decimal places
  //       netSale.toStringAsFixed(2), // Formats net sale to two decimal places
  //     ];
  //   }).toList(),
  //   headerStyle: pw.TextStyle(
  //     fontWeight: pw.FontWeight.bold,
  //     fontSize: 10,
  //   ),
  //   cellStyle: const pw.TextStyle(fontSize: 10), // Not bold
  //   cellAlignments: {
  //     0: pw.Alignment.centerLeft,
  //     1: pw.Alignment.centerRight,
  //     2: pw.Alignment.centerRight,
  //     3: pw.Alignment.centerRight, // Alignment for Net Sale column
  //   },
  //   headerAlignments: {
  //     0: pw.Alignment.centerLeft,
  //     1: pw.Alignment.centerRight,
  //     2: pw.Alignment.centerRight,
  //     3: pw.Alignment.centerRight, // Alignment for Net Sale header
  //   },
  //   columnWidths: {
  //     0: const pw.FlexColumnWidth(2.2),
  //     1: const pw.FlexColumnWidth(1.5),
  //     2: const pw.FlexColumnWidth(1.8),
  //     3: const pw.FlexColumnWidth(1.8), // Width for Net Sale column
  //   },
  //   border: null,
  //   headerDecoration: const pw.BoxDecoration(
  //     border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
  //   ),
  // ),
  // pw.Divider(thickness: 0.5),
  // pw.SizedBox(height: 20),
  //               pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.end,
  //               children: [
  //                 pw.Text(invoiceObj.invoiceAmount.toStringAsFixed(2), style: pw.TextStyle(fontSize: 10)),
  //                 pw.Text('=================', style:  pw.TextStyle(fontSize: 10)),
  //               ],
  //             ),
  //               pw.Align(
  //                 alignment: pw.Alignment.center,
  //                 child: pw.Text(
  //                   'Above goods recieved in good condition', // Formats invoiceAmount to two decimal places
  //                   style: pw.TextStyle(
  //                   fontWeight: pw.FontWeight.bold,
  //                   fontSize: 10,
  //                 )
  //                 ),
  //               ),
  //              // Return Items Table
  //               // pw.Table.fromTextArray(
  //               //   headers: ['Part No', 'Quantity', 'Price'],
  //               //   data: invoiceObj.parts.map((item) {
  //               //     return [
  //               //       item.partNo,
  //               //       item.receivedQty.toString(),
  //               //       item.price.toStringAsFixed(2), // Formats price to two decimal places
  //               //     ];
  //               //   }).toList(),
  //               //   headerStyle: pw.TextStyle(
  //               //     fontWeight: pw.FontWeight.bold,
  //               //     fontSize: 10,
  //               //   ),
  //               //   cellStyle: const pw.TextStyle(fontSize: 10), // Not bold
  //               //   cellAlignments: {
  //               //     0: pw.Alignment.centerLeft,
  //               //     1: pw.Alignment.centerRight,
  //               //     2: pw.Alignment.centerRight,
  //               //   },
  //               //   headerAlignments: {
  //               //     0: pw.Alignment.centerLeft,
  //               //     1: pw.Alignment.centerRight,
  //               //     2: pw.Alignment.centerRight,
  //               //   },
  //               //   columnWidths: {
  //               //     0: const pw.FlexColumnWidth(2.2),
  //               //     1: const pw.FlexColumnWidth(1.5),
  //               //     2: const pw.FlexColumnWidth(1.8),
  //               //   },
  //               //   border: null,
  //               //   headerDecoration: const pw.BoxDecoration(
  //               //     border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
  //               //   ),
  //               // ),
  //               // pw.Divider(thickness: 0.5),
  //               pw.SizedBox(height: 20),
  //               //   pw.Align(
  //               //   alignment: pw.Alignment.centerLeft,
  //               //   child: pw.Text(
  //               //     'Total Amount : ${invoiceObj.invoiceAmount.toStringAsFixed(2)}', // Formats invoiceAmount to two decimal places
  //               //     style: pw.TextStyle(
  //               //     fontWeight: pw.FontWeight.bold,
  //               //     fontSize: 10,
  //               //   )
  //               //   ),
  //               // ),

  //             ],
  //           );
  //         },
  //       ),
  //     );

  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdf.save(),
  //     );

  //   }

  /// End Of PDF Previews
  ///

  //// Testing Methods

  // A common data structure to hold receipt information
  // This ensures both ESC/POS generation and PDF preview use the same data.
  // This is Similar to Dataset in crystal report application ERP
  Map<String, dynamic> _buildReceiptData(
    // Used For Testing
    List<Map<String, dynamic>> items,
    String customerName,
  ) {
    double total = 0;
    for (var item in items) {
      final qty = item['qty'] as int;
      final price = item['price'] as double;
      total += (qty * price);
    }

    return {
      'storeName': 'YOUR STORE NAME',
      'customerName': customerName,
      'items': items,
      'total': total,
      'date':
          DateTime.now().toLocal().toString().split(
            ' ',
          )[0], // Simple date format
      'time': DateTime.now()
          .toLocal()
          .toString()
          .split(' ')[1]
          .substring(0, 5), // Simple time format
    };
  }

  Map<String, dynamic> _buildInvoice(
    List<Part> selectedParts,
    String dealerName,
  ) {
    double total = 0;
    for (var part in selectedParts) {
      // final qty = item['qty'] as int;
      final qty = part.receivedQty;
      final price = part.price;
      total += (qty * price);
    }

    return {
      'dealerName': dealerName,
      'parts': selectedParts,
      'total': total,
      'date':
          DateTime.now().toLocal().toString().split(
            ' ',
          )[0], // Simple date format
      'time': DateTime.now()
          .toLocal()
          .toString()
          .split(' ')[1]
          .substring(0, 5), // Simple time format
    };
  }

  // This method the ESC/POS commands, but does NOT print for now. //
  // Prepare this for each Prints  // Dont Remove.
  // It returns the bytes, which could be sent to a printer later.
  // Future<Uint8List> generateThermalReceiptCommands(List<Map<String, dynamic>> items, String customerName) async {
  //   final receiptData = _buildReceiptData(items, customerName);
  //   final Generator generator = Generator(PaperSize.mm80, _profile); // Adjust paper size if needed
  //   List<int> bytes = [];

  //   bytes += generator.text(receiptData['storeName'], styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
  //   bytes += generator.text('Date: ${receiptData['date']} ${receiptData['time']}', styles: const PosStyles(align: PosAlign.center,height: PosTextSize.size2, width : PosTextSize.size1));
  //   bytes += generator.text('Customer: ${receiptData['customerName']}', styles: const PosStyles(align: PosAlign.left));
  //   bytes += generator.hr(); // Horizontal Rule

  //   // Table header
  //   bytes += generator.row([
  //     PosColumn(text: 'Item', width: 6),
  //     PosColumn(text: 'Qty', width: 2, styles: const PosStyles(align: PosAlign.right)),
  //     PosColumn(text: 'Price', width: 4, styles: const PosStyles(align: PosAlign.right)),
  //   ]);
  //   bytes += generator.hr();

  //   // Item details
  //   for (var item in receiptData['items']) {
  //     final name = item['name'] as String;
  //     final qty = item['qty'] as int;
  //     final price = item['price'] as double;

  //     bytes += generator.row([
  //       PosColumn(text: name, width: 6),
  //       PosColumn(text: qty.toString(), width: 2, styles: const PosStyles(align: PosAlign.right)),
  //       PosColumn(text: price.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right)),
  //     ]);
  //   }

  //   bytes += generator.hr();
  //   bytes += generator.row([
  //     PosColumn(text: 'TOTAL', width: 8, styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2)),
  //     PosColumn(text: receiptData['total'].toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2, width: PosTextSize.size2)),
  //   ]);
  //   bytes += generator.feed(2); // Line feeds
  //   bytes += generator.cut(); // Cut paper

  //   print("ESC/POS Receipt commands generated (${bytes.length} bytes). Not sent to printer for now.");
  //   return Uint8List.fromList(bytes); // Return the generated bytes
  // }

  // Method to preview the thermal INVOICE as PDF
  Future<void> previewThermalInvoicePdf2(
    List<Part> selectedParts,
    String dealerName,
  ) async {
    final data = _buildInvoice(selectedParts, dealerName);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat.roll80, // Mimics a common thermal paper width (80mm)
        margin: const pw.EdgeInsets.all(10), // Reduced margins for receipt feel
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'DPMC Invoice System',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Date: ${data['date']} ${data['time']}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'Dealer : ${data['dealerName']}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.Table.fromTextArray(
                headers: ['Part No', 'Quantity', 'Price'],
                data:
                    (data['parts'] as List<Part>).map((item) {
                      final id = item.partNo;
                      final qty = item.receivedQty;
                      final price = item.price;
                      return [id, qty.toString(), price.toStringAsFixed(2)];
                    }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                //cellAlignment: pw.Alignment.centerLeft,
                // UPDATED: Use cellAlignments instead of cellAlignment
                cellAlignments: {
                  0: pw.Alignment.centerLeft, // Part column
                  1: pw.Alignment.centerRight, // Quantity column
                  2: pw.Alignment.centerRight, // Price column
                },
                //Optional: You can also align headers to match if desired
                headerAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: const pw.FlexColumnWidth(
                    2.2,
                  ), // Item name takes more space
                  1: const pw.FlexColumnWidth(1.5), // Quantity
                  2: const pw.FlexColumnWidth(1.8), // Price
                },
                border: null, // No border for a receipt feel
                headerDecoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                ), // Thin line below header
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  pw.Text(
                    data['total'].toStringAsFixed(2),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Thank you !', style: const pw.TextStyle(fontSize: 10)),
            ],
          );
        },
      ),
    );

    // Show the PDF preview dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // NEW: Method to preview the thermal receipt as PDF
  Future<void> previewThermalReceiptTestPdf(
    List<Map<String, dynamic>> items,
    String customerName,
  ) async {
    final receiptData = _buildReceiptData(items, customerName);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat.roll80, // Mimics a common thermal paper width (80mm)
        margin: const pw.EdgeInsets.all(10), // Reduced margins for receipt feel
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                receiptData['storeName'],
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Date: ${receiptData['date']} ${receiptData['time']}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'Customer: ${receiptData['customerName']}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Price'],
                data:
                    (receiptData['items'] as List<dynamic>).map((item) {
                      final name = item['name'] as String;
                      final qty = item['qty'] as int;
                      final price = item['price'] as double;
                      return [name, qty.toString(), price.toStringAsFixed(2)];
                    }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellAlignment: pw.Alignment.centerLeft,
                columnWidths: {
                  0: const pw.FlexColumnWidth(3), // Item name takes more space
                  1: const pw.FlexColumnWidth(1), // Quantity
                  2: const pw.FlexColumnWidth(1.5), // Price
                },
                border: null, // No border for a receipt feel
                headerDecoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                ), // Thin line below header
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  pw.Text(
                    receiptData['total'].toStringAsFixed(2),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Thank you for your purchase!',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );

    // Show the PDF preview dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // // --- PDF Printing related (e.g., invoices, reports) ---
  // // These are unchanged from previous examples.

  // Future<void> generateAndPrintInvoice(Map<String, dynamic> invoiceData) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               'Invoice',
  //               style: pw.TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Text(
  //                       'From:',
  //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text('Your Company Name'),
  //                     pw.Text('123 Business Rd'),
  //                     pw.Text('City, Country'),
  //                   ],
  //                 ),
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Text(
  //                       'To:',
  //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text(invoiceData['customerName'] as String),
  //                     pw.Text(invoiceData['customerAddress'] as String),
  //                     pw.Text(invoiceData['customerCity'] as String),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text(
  //               'Invoice #: ${invoiceData['invoiceNumber']}',
  //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text(
  //               'Date: ${invoiceData['date']}',
  //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Table.fromTextArray(
  //               headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
  //               data:
  //                   (invoiceData['items'] as List<dynamic>).map((item) {
  //                     final name = item['name'] as String;
  //                     final qty = item['qty'] as int;
  //                     final price = item['price'] as double;
  //                     return [
  //                       name,
  //                       qty.toString(),
  //                       price.toStringAsFixed(2),
  //                       (qty * price).toStringAsFixed(2),
  //                     ];
  //                   }).toList(),
  //               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //               cellAlignment: pw.Alignment.centerLeft,
  //               columnWidths: {
  //                 0: const pw.FlexColumnWidth(3),
  //                 1: const pw.FlexColumnWidth(1),
  //                 2: const pw.FlexColumnWidth(1.5),
  //                 3: const pw.FlexColumnWidth(1.5),
  //               },
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Align(
  //               alignment: pw.Alignment.bottomRight,
  //               child: pw.Text(
  //                 'Total Amount: \$${invoiceData['totalAmount']}',
  //                 style: pw.TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }

  // Future<void> generateAndPrintReport(String title, String content) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Center(
  //               child: pw.Text(
  //                 title,
  //                 style: pw.TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text(content),
  //             // Add more complex layout as needed
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }
}
