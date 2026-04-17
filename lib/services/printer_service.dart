import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List

// For thermal printers (ESC/POS) - keeping for future implementation
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // For future Bluetooth connection
import 'package:intl/intl.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/return_save_model.dart';

// For PDF printing and preview
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrinterService {
  // --- Thermal Printer (ESC/POS) related - for future use ---
  // FlutterBluePlus _flutterBlue = FlutterBluePlus.instance; // For future Bluetooth scanning/connection
  // BluetoothDevice _connectedDevice; // To store a connected printer device

  //late CapabilityProfile _profile; // Loaded once for ESC/POS command generation
  static final String CompanyName = 'David Pieris Motor Company (Pvt) Ltd';
  static final String CompanyAddress =
      '120, 120A,Pannipitya Road, Battaramulla.';
  static final String CompanyContact = 'Tel: 014419300, Fax: 0114700101';
  static late dynamic printRegular;
  static late dynamic printBold;

  static Future<void> initialize() async {
    //_profile = await CapabilityProfile.load(); //
    // printRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Courier-Regular.ttf'));
    // printBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Courier-Bold.ttf'),);

    printRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Courier/CourierPrime-Regular.ttf'),
    );
    printBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Courier/CourierPrime-Regular.ttf'),
    );
    // No actual thermal printer connection logic here for now.
    // This method is kept for future expansion of thermal printing.
  }

  // Helpers For PDF previews
  // Company Header Along with Print Title
  static pw.Column _companyHeaderPdf(String topic) {
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

  //   pw.Column _formFooterPdf(PrintFooterDetail details) {
  //   return pw.Column(
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     children: [
  //       pw.SizedBox(height: 20),
  //       pw.Text(
  //         'Form No: ' + details.formNo,
  //         style: const pw.TextStyle(fontSize: 10), // Standard font size
  //         textAlign: pw.TextAlign.center,
  //       ),
  //       pw.Text(
  //         'Rev No: ' + details.revNo,
  //         style: const pw.TextStyle(fontSize: 10), // Standard font size
  //         textAlign: pw.TextAlign.center,
  //       ),
  //       pw.Text(
  //         'Doc. Classific. Code: '+ details.docNo,
  //         style: const pw.TextStyle(fontSize: 10), // Standard font size
  //         textAlign: pw.TextAlign.center,
  //       ),
  //       pw.SizedBox(height: 20), // Space after the topic
  //     ],
  //   );
  // }

  static pw.Column _formFooterPdf(PrintFooterDetail details) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),

        pw.Text(
          'Form No: ${details.formNo}',
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),

        pw.Text(
          'Rev No: ${details.revNo}',
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),

        if (details.docNo.trim().isNotEmpty)
          pw.Text(
            'Doc. Classific. Code: ${details.docNo}',
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),

        pw.SizedBox(height: 20),
      ],
    );
  }

  // Helper for label : Value Table Rows
  static pw.TableRow _buildDetailTableRow(String label, String value) {
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
  static Future<void> previewThermalReturnPdf(
    Return returnObj,
    PrintFooterDetail details,
  ) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );
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
              _companyHeaderPdf("DELIVERY RETURNS"),

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
                  'Return Type : ${returnObj.returnType}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
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
              //pw.Divider(thickness: 0.5),

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
              //pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 20),

              // Signature Section
              pw.SizedBox(height: 15),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        '-----------------',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Dealer Signature',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        '-----------------',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Driver Signature',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Dealer Stamp',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 20),
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
                  _formFooterPdf(details),
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
  static Future<void> previewThermalInvoicePdf(
    InvoiceSave invoiceObj,
    PrintFooterDetail details, {
    bool isReprint = false,
  }) async {
    //final courierRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Courier/CourierPrime-Regular.ttf'));
    //final courierBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Courier/CourierPrime-Regular.ttf'));

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );
    final formattedInvoiceDate = DateFormat(
      'yyyy/MM/dd',
    ).format(invoiceObj.invoiceTime);
    //_formFooterPdf(PrintFooterDetail details)
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
                      formatNumber(invoiceObj.invoiceAmount),
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
              _formFooterPdf(details),
            ],
          );
        },
      );
    }

    String titlePrefix = isReprint ? 'REPRINT ' : '';
    // Customer Copy
    pdf.addPage(
      _buildInvoicePageContent('${titlePrefix}CREDIT INVOICE - CUSTOMER COPY'),
    );

    // Office Copy
    pdf.addPage(
      _buildInvoicePageContent('${titlePrefix}CREDIT INVOICE - OFFICE COPY'),
    );

    // // Add the Customer Copy page using the common method
    // pdf.addPage(_buildInvoicePageContent('CREDIT INVOICE - CUSTOMER COPY'));

    // // Add the Office Copy page using the common method
    // pdf.addPage(_buildInvoicePageContent('CREDIT INVOICE - OFFICE COPY'));

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- Receipt PDF method ---
  static Future<void> previewThermalReceiptPdf(
    Receipt recObj,
    PrintFooterDetail details, {
    bool isReprint = false,
  }) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );
    final formattedDate = DateFormat('yyyy/MM/dd').format(recObj.receiptTime);
    final formattedDepDate = DateFormat('yyyy/MM/dd').format(recObj.chequeDate);
    final double fontSize = 10;
    final double chequeAmount = recObj.chequeAmount;
    final double totalCreditNoteAmount = recObj.creditNotes.fold(
      0.0,
      (sum, note) => sum + note.amount,
    );

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
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: pw.FontWeight.bold,
              ), // Value text
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              ' ',
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: pw.FontWeight.bold,
              ), // Value text
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: pw.FontWeight.bold,
              ), // Value text
            ),
          ),
        ],
      );
    }

    pw.TableRow _buildSingleRow(String label) {
      return pw.TableRow(
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: fontSize), // Label text
            ),
          ),
        ],
      );
    }

    final totalPayment = Decimal.parse(
      (totalCreditNoteAmount + chequeAmount).toString(),
    );

    String titlePrefix = isReprint ? 'REPRINT ' : '';
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
                  '${titlePrefix}PROVISIONAL RECEIPT',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
              _companyHeaderPdf('CUSTOMER'),

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
                    recObj.receiptNo.toUpperCase(),
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
                  _buildBoldTableRow('Invoice Numbers', 'Amount (Rs.)'),

                  ...recObj.tins.map(
                    (item) => _buildTableRow(
                      item.mobileInvNo
                          .toString(), // Assuming mobileInvNo can be directly converted to string
                      formatNumber(
                        item.invAmount,
                      ), // Assuming invAmount is a double and needs formatting
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
                columnWidths: {0: const pw.FlexColumnWidth(1)},
                children: [
                  _buildSingleRow('Payment Method: Cheque'),
                  _buildSingleRow('Bank and Branch:'),
                  _buildSingleRow('  ${recObj.branchName.toUpperCase()}'),
                  _buildSingleRow(
                    'Check No / Card No: ${recObj.chequeNumber.toUpperCase()}',
                  ),
                  _buildSingleRow('To be Deposited Date: $formattedDepDate'),
                ],
              ),

              _formFooterPdf(details),
              // SPACING
              pw.SizedBox(height: 30), // END OF CUSTOMER PRINT
              // START
              // Company Header
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '${titlePrefix}PROVISIONAL RECEIPT',
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
                    recObj.receiptNo.toUpperCase(),
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
                  _buildBoldTableRow('Invoice Numbers', 'Amount (Rs.)'),

                  ...recObj.tins.map(
                    (item) => _buildTableRow(
                      item.mobileInvNo
                          .toString(), // Assuming mobileInvNo can be directly converted to string
                      formatNumber(
                        item.invAmount,
                      ), // Assuming invAmount is a double and needs formatting
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
                columnWidths: {0: const pw.FlexColumnWidth(1)},
                children: [
                  _buildSingleRow('Payment Method: Cheque'),
                  _buildSingleRow('Bank and Branch:'),
                  _buildSingleRow('  ${recObj.branchName.toUpperCase()}'),
                  _buildSingleRow(
                    'Check No / Card No: ${recObj.chequeNumber.toUpperCase()}',
                  ),
                  _buildSingleRow('To be Deposited Date: $formattedDepDate'),
                ],
              ),
              _formFooterPdf(details),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  ////  Dispatch Note PDF
  static Future<void> previewDispatchNotePdf(
    DispatchNoteSave note,
    PrintFooterDetail details,
  ) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );
    const double fontSize = 9;

    final formattedDate = DateFormat('yyyy/MM/dd').format(note.dispatchTime);

    pw.TableRow _row(String label, String value) {
      return pw.TableRow(
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: fontSize),
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: fontSize),
            ),
          ),
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

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(8),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children:
                note.tins
                    .expand(
                      (tin) => [
                        /// HEADER
                        _companyHeaderPdf('ADVICE OF DISPATCH NOTE'),
                        pw.Divider(thickness: 0.5),

                        /// CUSTOMER SECTION
                        pw.Text(
                          "To:",
                          style: pw.TextStyle(
                            fontSize: fontSize,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          note.dealerName.toUpperCase(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                        pw.Text(
                          note.dealerAddress.toUpperCase(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                        pw.SizedBox(height: 6),

                        /// DETAILS TABLE
                        pw.Table(
                          columnWidths: {
                            0: const pw.FlexColumnWidth(3),
                            1: const pw.FlexColumnWidth(2),
                          },
                          children: [
                            _buildDetailTableRow("A/C No", note.dealerId),
                            _buildDetailTableRow("Order No", tin.orderNumber),
                            _buildDetailTableRow("TIN No", tin.tinNumber),
                            _buildDetailTableRow("Pay on Del", tin.payOnDel),
                            _buildDetailTableRow("Route", note.route),
                            _buildDetailTableRow("Date", formattedDate),
                            _buildDetailTableRow(
                              "Dispatch No",
                              note.dispatchNumber,
                            ),
                          ],
                        ),
                        pw.Divider(thickness: 0.5),

                        /// ITEM HEADER
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              "Description",
                              style: pw.TextStyle(
                                fontSize: fontSize,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Qty",
                              style: pw.TextStyle(
                                fontSize: fontSize,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),

                        /// ITEMS LIST
                        ...tin.parts.expand(
                          (item) => [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    item.description,
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                pw.Text(
                                  item.requestQty.toString(),
                                  style: pw.TextStyle(fontSize: fontSize),
                                ),
                              ],
                            ),
                            pw.Text(
                              item.partNo,
                              style: pw.TextStyle(fontSize: fontSize - 1),
                            ),
                            pw.SizedBox(height: 4),
                          ],
                        ),

                        pw.Divider(thickness: 0.5),

                        /// FOOTER COUNTS
                        pw.Table(
                          columnWidths: {
                            0: const pw.FlexColumnWidth(3),
                            1: const pw.FlexColumnWidth(2),
                          },
                          children: [
                            _row("No. of Boxes", tin.bagCount.toString()),
                            _row("No. of Tags", tin.tagCount.toString()),
                            _row(
                              "No. of Plastic Boxes",
                              tin.plasticBCount.toString(),
                            ),
                            _row(
                              "Remarks",
                              tin.remark.isEmpty ? "-" : tin.remark,
                            ),
                          ],
                        ),
                        _formFooterPdf(details),

                        /// SEPARATOR BETWEEN TINS
                        if (tin != note.tins.last) ...[
                          pw.Divider(
                            thickness: 2,
                            color: PdfColors.grey700,
                          ),
                        ],
                      ],
                    )
                    .toList(),
          );
          // return pw.Column(
          //   crossAxisAlignment: pw.CrossAxisAlignment.start,
          //   children: [
          //     /// HEADER
          //     _companyHeaderPdf('ADVICE OF DISPATCH NOTE'),
          //     pw.Divider(thickness: 0.5),
          //     /// CUSTOMER SECTION
          //     pw.Text("To:",
          //         style: pw.TextStyle(
          //         fontSize: fontSize,
          //         fontWeight: pw.FontWeight.bold)
          //         ),
          //     pw.Text(note.dealerName.toUpperCase(),
          //         style: const pw.TextStyle(fontSize: fontSize)),
          //     pw.Text(note.dealerAddress.toUpperCase(),
          //         style: const pw.TextStyle(fontSize: fontSize)),
          //     pw.SizedBox(height: 6),
          //     pw.Table(
          //       columnWidths: {
          //         0: const pw.FlexColumnWidth(3),
          //         1: const pw.FlexColumnWidth(2),
          //       },
          //       children: [
          //         _buildDetailTableRow("A/C No", note.dealerId),
          //         _buildDetailTableRow("Order No", note.tins[0].orderNumber),
          //         _buildDetailTableRow("TIN No", note.tins[0].tinNumber),
          //         _buildDetailTableRow("Pay on Del", note.tins[0].payOnDel),
          //         _buildDetailTableRow("Route", note.route),
          //         _buildDetailTableRow("Date", formattedDate),
          //         _buildDetailTableRow("Dispatch No", note.dispatchNumber),
          //       ],
          //     ),
          //     pw.Divider(thickness: 0.5),
          //     /// ITEM HEADER
          //     pw.Row(
          //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          //       children: [
          //         pw.Text("Description",
          //             style: pw.TextStyle(
          //                 fontSize: fontSize,
          //                 fontWeight: pw.FontWeight.bold)),
          //         pw.Text("Qty",
          //             style: pw.TextStyle(
          //                 fontSize: fontSize,
          //                 fontWeight: pw.FontWeight.bold)),
          //       ],
          //     ),
          //     pw.SizedBox(height: 5),
          //     /// ITEM LIST
          //     ...note.tins[0].parts.map(
          //       (item) => pw.Column(
          //         crossAxisAlignment: pw.CrossAxisAlignment.start,
          //         children: [
          //           pw.Row(
          //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          //             children: [
          //               pw.Expanded(
          //                   child: pw.Text(
          //                   item.description,
          //                   style: const pw.TextStyle(fontSize: fontSize),
          //                   ),),
          //               pw.Text(
          //                 item.requestQty.toString(),
          //                 style: const pw.TextStyle(
          //                     fontSize: fontSize),
          //               ),
          //             ],
          //           ),
          //           pw.Text(
          //             item.partNo,
          //             style: const pw.TextStyle(
          //                 fontSize: fontSize - 1),
          //           ),
          //           pw.SizedBox(height: 4),
          //         ],
          //       ),
          //     ),
          //     pw.Divider(thickness: 0.5),
          //     /// FOOTER COUNTS
          //     pw.Table(
          //       columnWidths: {
          //         0: const pw.FlexColumnWidth(3),
          //         1: const pw.FlexColumnWidth(2),
          //       },
          //       children: [
          //         _row("No. of Boxes", note.tins[0].bagCount.toString()),
          //         _row("No. of Tags", note.tins[0].tagCount.toString()),
          //         _row("No. of Plastic Boxes", note.tins[0].plasticBCount.toString()),
          //         _row("Remarks", note.tins[0].remark ?? "-"),
          //       ],
          //     ),
          //     _formFooterPdf(details)
          //   ],
          // );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// End of the Section
  ///
  ///
  PdfPageFormat buildThermalFormat({double widthMM = 80, double marginMM = 5}) {
    final width = widthMM * PdfPageFormat.mm;
    final margin = marginMM * PdfPageFormat.mm;

    return PdfPageFormat(
      width,
      double.infinity, // auto height
      marginAll: margin,
    );
  }

  /// ONLY FOR TESTING
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

  // Method to preview the thermal INVOICE as PDF
  Future<void> previewThermalInvoicePdf2(
    List<Part> selectedParts,
    String dealerName,
  ) async {
    final data = _buildInvoice(selectedParts, dealerName);
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );

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
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );

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

  static Future<void> previewChequeSummaryPdf(
    DateTime startDateTime,
    DateTime endDateTime,
    List<Receipt> cheques,
    PrintFooterDetail details,
  ) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: printRegular, bold: printBold),
    );
    final formattedStart = DateFormat('yyyy/MM/dd HH:mm').format(startDateTime);
    final formattedEnd = DateFormat('yyyy/MM/dd HH:mm').format(endDateTime);
    final totalAmount = cheques.fold<double>(
      0,
      (sum, rec) => sum + rec.chequeAmount,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              _companyHeaderPdf('CHEQUE SUMMARY'),
              pw.Text(
                'From: $formattedStart',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.Text('To: $formattedEnd', style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),

              pw.Table(
                border: null,
                columnWidths: {
                  0: const pw.FlexColumnWidth(1), // Dealer (code + name)
                  1: const pw.FlexColumnWidth(1), // Amount
                  2: const pw.FlexColumnWidth(1), // Amount
                  3: const pw.FlexColumnWidth(1), // Timestamp (date + time)
                },
                children: [
                  // Header row
                  pw.TableRow(
                    children: [
                      pw.Text('Dealer ', style: pw.TextStyle(fontSize: 9)),
                      pw.Text('Cheque No ', style: pw.TextStyle(fontSize: 9)),
                      pw.Text('  Time', style: pw.TextStyle(fontSize: 9)),
                      pw.Text('  Amount ', style: pw.TextStyle(fontSize: 9)),
                      // pw.Align(
                      //   alignment: pw.Alignment.centerRight,
                      //   child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      // ),
                      // pw.Align(
                      //   alignment: pw.Alignment.centerRight,
                      //   child: pw.Text('Time', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      // ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(' ', style: pw.TextStyle(fontSize: 8)),
                      pw.Text(' ', style: pw.TextStyle(fontSize: 8)),
                      pw.Text(' ', style: pw.TextStyle(fontSize: 8)),
                      pw.Text(' ', style: pw.TextStyle(fontSize: 8)),
                      // pw.Align(
                      //   alignment: pw.Alignment.centerRight,
                      //   child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      // ),
                      // pw.Align(
                      //   alignment: pw.Alignment.centerRight,
                      //   child: pw.Text('Time', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      // ),
                    ],
                  ),
                  // Data rows
                  ...cheques.map((rec) {
                    final formattedDate = DateFormat(
                      'dd/MM/yy',
                    ).format(rec.receiptTime);
                    final formattedTime = DateFormat(
                      'HH:mm',
                    ).format(rec.receiptTime);
                    return pw.TableRow(
                      children: [
                        // Dealer column: code + name stacked
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              rec.dealerCode ?? '',
                              style: pw.TextStyle(fontSize: 8),
                            ),
                            pw.Text(
                              rec.dealerName ?? '',
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        // Cheque Number column
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            rec.chequeNumber,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ),
                        // Timestamp column: date + time stacked
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              formattedDate,
                              style: pw.TextStyle(fontSize: 8),
                            ),
                            pw.Text(
                              formattedTime,
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        // Amount column
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            formatNumber(rec.chequeAmount),
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),

              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: ${formatNumber(totalAmount)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              _formFooterPdf(details),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  //  static Future<void> previewChequeSummaryPdf(
  //   DateTime startDateTime,
  //   DateTime endDateTime,
  //   List<Receipt> cheques,
  //   PrintFooterDetail details,
  // ) async {
  //   final pdf = pw.Document();
  //   // format start and end for display
  //   final formattedStart = DateFormat('yyyy/MM/dd HH:mm').format(startDateTime);
  //   final formattedEnd = DateFormat('yyyy/MM/dd HH:mm').format(endDateTime);
  //   // maybe total sum
  //   final totalAmount = cheques.fold<double>(0, (sum, rec) => sum + rec.chequeAmount);
  //   // Build page
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.roll80,
  //       margin: const pw.EdgeInsets.all(10),
  //       build: (context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             _companyHeaderPdf('CHEQUE SUMMARY'), // or maybe a custom header
  //             // Start and end date range
  //             pw.Text('From: $formattedStart', style: pw.TextStyle(fontSize: 10)),
  //             pw.Text('To: $formattedEnd', style: pw.TextStyle(fontSize: 10)),
  //             pw.SizedBox(height: 10),
  //             // Table header
  //             pw.Table(
  //               border: null,
  //               columnWidths: {
  //                 0: const pw.FlexColumnWidth(2), // Dealer Code
  //                 1: const pw.FlexColumnWidth(3), // Dealer Name
  //                 2: const pw.FixedColumnWidth(50), // Amount
  //                 3: const pw.FixedColumnWidth(80), // Receipt Time
  //               },
  //               children: [
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Text('Dealer Code', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                     pw.Text('Dealer Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                     pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
  //                     pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('Receipt Time', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
  //                   ],
  //                 ),
  //                 // Data rows
  //                 ...cheques.map((rec) {
  //                   final formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(rec.receiptTime);
  //                   return pw.TableRow(
  //                     children: [
  //                       pw.Text(rec.dealerCode ?? '', style: pw.TextStyle(fontSize: 8)),
  //                       pw.Text(rec.dealerName ?? '', style: pw.TextStyle(fontSize: 8)),
  //                       pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text(formatNumber(rec.chequeAmount), style: pw.TextStyle(fontSize: 8))),
  //                       pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text(formattedTime, style: pw.TextStyle(fontSize: 8))),
  //                     ],
  //                   );
  //                 }),
  //               ],
  //             ),
  //             pw.Divider(),
  //             pw.SizedBox(height: 5),
  //             pw.Align(
  //               alignment: pw.Alignment.centerRight,
  //               child: pw.Text('Total: ${formatNumber(totalAmount)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             ),
  //             pw.SizedBox(height: 10),
  //             _formFooterPdf(details),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   await Printing.layoutPdf(onLayout: (format) => pdf.save());
  // }
}
