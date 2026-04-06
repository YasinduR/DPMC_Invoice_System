import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_date_time_picker.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class ChequeSummaryView extends ConsumerStatefulWidget {
  final VoidCallback onPrint;
  const ChequeSummaryView({super.key, required this.onPrint});

  @override
  ConsumerState<ChequeSummaryView> createState() => _ChequeSummaryViewState();
}

class _ChequeSummaryViewState extends ConsumerState<ChequeSummaryView> {
  List<Receipt> _cheques = [];
  bool _isLoading = false;
  String? _errorMessage = null;

  // Start and end date‑time for filtering
  DateTime _startDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    8,
    0,
  ); // today at 08:00
  DateTime _endDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    17,
    0,
  ); // today at 17:00

  Future<void> _validateAndLoad() async {
    if (_startDateTime.isAfter(_endDateTime)) {
      // Show an error message (optional)
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Start date‑time must be before end date‑time',
          type: MessageType.warning,
        );
      }
      return;
    }
    await _loadCheques();
  }

  Future<void> _loadCheques() async {
    final user = ref.watch(authProvider).currentUser;

    if (user == null) {
      setState(() {
        _errorMessage = 'User not logged in';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

await inquire<Receipt>(
  context: context,
  dataUrl: 'receipts/list',
  filters: {
    'userId': user.id,
    'receiptTime_start': _startDateTime.toIso8601String(),
    'receiptTime_end': _endDateTime.toIso8601String(),
  },
  onSuccess: (List<Receipt> data) {
    if (mounted) {
      setState(() {
        _cheques = data;
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

      // showSnackBar(
      //   context: context,
      //   message: message,
      //   type: MessageType.error,
      // );
    }
  },
);

    // await inquire<Receipt>(
    //   context: context,
    //   dataUrl: dataUrl,
    //   onSuccess: (List<Receipt> data) {
    //     if (mounted) {
    //       setState(() {
    //         _cheques = data;
    //         _isLoading = false;
    //       });
    //     }
    //   },
    //   onError: (String message) {
    //     if (mounted) {
    //       setState(() {
    //         _errorMessage = message;
    //         _isLoading = false;
    //       });

    //       showSnackBar(
    //         context: context,
    //         message: message,
    //         type: MessageType.error,
    //       );
    //     }
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
    _loadCheques();
  }

  /// Builds the TIN invoice list area.
  Widget _buildTinInvoiceArea() {
    if (_isLoading) {
      return const Center(child: Text('Loading Receipts by you...'));
    }
    if (_cheques.isEmpty || _errorMessage != null) {
      return const Center(child: Text('No Receipts found under you for the selected time.'));
    }
    return AppDataGrid<Receipt>(
      hasFilter: false, // <-- Hides the filter/search bar
      items: _cheques,
      filterableFields: [],
      columns: [
        // Column 1: Invoice Number (using tinNo)
        DynamicColumn<Receipt>(
          label: 'Dealer',
          flex: 1,
          cellBuilder: (context, rec) => Column(
          mainAxisAlignment: MainAxisAlignment.center,  // vertically centered in the row
          crossAxisAlignment: CrossAxisAlignment.start, // left-aligned text
          children: [
            AutoSizeText(
              rec.dealerCode,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w500), // optional
            ),
            AutoSizeText(
              rec.dealerName,
              maxLines: 2, // allow wrapping if name is long
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12), // smaller font for name
            ),
            ],
          ),
        ),
        DynamicColumn<Receipt>(
          label: 'Cheque Number',
          flex: 1,
          cellBuilder:
              (context, rec) => AutoSizeText(
                rec.chequeNumber,
                //invoice.invAmount.toStringAsFixed(2),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
        ),
        DynamicColumn<Receipt>(
          label: 'Time',
          flex: 1,
          cellBuilder: (context, rec) {
            final formattedDate = DateFormat('dd/MM/yy').format(rec.receiptTime);
            final formattedTime = DateFormat('HH:mm').format(rec.receiptTime);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  formattedDate,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
                AutoSizeText(
                  formattedTime,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
        // Column 2: Invoice Amount
        DynamicColumn<Receipt>(
          label: 'Amount',
          flex: 1,
          cellBuilder:
              (context, rec) => AutoSizeText(
                formatNumber(rec.chequeAmount),
                //invoice.invAmount.toStringAsFixed(2),
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateTimePickerField(
                  labelText: 'Start Date & Time',
                  selectedDate: _startDateTime,
                  onDateSelected: (newStart) {
                    setState(() {
                      _startDateTime = newStart;
                    });
                    _validateAndLoad();
                  },
                  disabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DateTimePickerField(
                  labelText: 'End Date & Time',
                  selectedDate: _endDateTime,
                  onDateSelected: (newEnd) {
                    setState(() {
                      _endDateTime = newEnd;
                    });
                    _validateAndLoad();
                  },
                  disabled: false,
                ),
              ),
            ],
          ),
          Expanded(child: _buildTinInvoiceArea()),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Print',
            onPressed: () async {
              if (_cheques.isEmpty) {
                showSnackBar(
                  context: context,
                  message:
                      "No Cheques summary to print on selected time duration",
                  type: MessageType.warning,
                );
                return;
              }
              final details = PrintFooterDetail(
                formNo: 'PA-FO-59',
                revNo: '01',
              );
              PrinterService.previewChequeSummaryPdf(
                _startDateTime,
                _endDateTime,
                _cheques,
                details,
              );
            },
          ),
        ],
      ),
    );
  }
}


  /// Builds the TIN invoice list area.
  