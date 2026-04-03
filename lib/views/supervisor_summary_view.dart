import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/dealer_stat_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_date_time_picker.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/assignee_card.dart';

class SupervisorSummaryView extends ConsumerStatefulWidget {
  final Assignee assignee;
  final void Function(DealerStat,List<TinData>) onSubmit;
  const SupervisorSummaryView({super.key, required this.assignee, required this.onSubmit});

  @override
  ConsumerState<SupervisorSummaryView> createState() =>
      _SupervisorSummaryViewState();
}

class _SupervisorSummaryViewState extends ConsumerState<SupervisorSummaryView> {
  List<TinData> _tins = [];
  List<Dealer> _dealers = [];
  bool _isLoading = false;
  String? _errorMessage = null;

  Future<void> _loadTins() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final filters = {'dealerCode_in': widget.assignee.dealerListAssigned};

    await inquire<TinData>(
      context: context,
      dataUrl:
          'tins/list', // Note: your endpoint seems to be 'api/tins/list' from earlier code
      filters: filters, // ← pass the filters here
      onSuccess: (List<TinData> data) {
        if (mounted) {
          setState(() {
            _tins = data;
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

  Future<void> _loadDealers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final filters = {'accountCode_in': widget.assignee.dealerListAssigned};

    await inquire<Dealer>(
      context: context,
      dataUrl:
          'dealers/list', // Note: your endpoint seems to be 'api/tins/list' from earlier code
      filters: filters, // ← pass the filters here
      onSuccess: (List<Dealer> data) {
        if (mounted) {
          setState(() {
            _dealers = data;
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


List<DealerStat> _buildDealerStats() {
  return _dealers.map((dealer) {
    final dealerTins = _tins
        .where((tin) => tin.dealercode == dealer.accountCode)
        .toList();

    final approvedCount =
        dealerTins.where((tin) => tin.paymentStatus == 'A').length;

    final proceedCount =
        dealerTins.where((tin) => tin.paymentStatus == 'C').length;

    return DealerStat(
      dealerName: dealer.name,
      accountCode: dealer.accountCode,
      approvedTinCount: approvedCount,
      proceedTinCount: proceedCount,
      // partiallyProceedTinCount defaults to 0
    );
  }).toList();
}


  @override
  void initState() {
    super.initState();
    setState(() {
          _loadDealers();
    _loadTins();
    });

  }

  /// Builds the TIN invoice list area.
  Widget _buildTinInvoiceArea() {
    if (_isLoading) {
      return const Center(child: Text('Loading Dealer Information...'));
    }
    if (_tins.isEmpty || _errorMessage != null) {
      return const Center(
        child: Text('No Dealers found under the Assignee.'),
      );
    }

    final stats = _buildDealerStats();

    return AppDataGrid<DealerStat>(
      
      hasFilter: false, // <-- Hides the filter/search bar
      items: stats,
      filterableFields: [],
      columns: [
        // Column 1: Invoice Number (using tinNo)
        DynamicColumn<DealerStat>(
          label: 'Dealer',
          flex: 1,
cellBuilder: (context, rec) => Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () {
      final dealerTins = _tins
          .where((tin) => tin.dealercode == rec.accountCode)
          .toList();

      widget.onSubmit(rec, dealerTins);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(rec.accountCode, maxLines: 1),
        AutoSizeText(rec.dealerName, maxLines: 2),
      ],
    ),
  ),
)
        ),
        DynamicColumn<DealerStat>(
          label: 'Pending TIN count',
          flex: 1,
          cellBuilder:
              (context, rec) => AutoSizeText(
                rec.approvedTinCount.toString(),
                //invoice.invAmount.toStringAsFixed(2),
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
        ),
        DynamicColumn<DealerStat>(
          label: 'Completed TIN count',
          flex: 1,
          cellBuilder:
              (context, rec) => AutoSizeText(
                rec.proceedTinCount.toString(),
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
          AssigneeInfoCard(assignee: widget.assignee),
          const SizedBox(height: 16),
          Expanded(child: _buildTinInvoiceArea()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


  /// Builds the TIN invoice list area.
  