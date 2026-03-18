import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/theme/app_colors.dart';

class ActivityDetailCard extends StatelessWidget {
  final Activity activity;

  const ActivityDetailCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final data = _extractData(activity);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(), // Optional: adds iOS-like bounce effect
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const Divider(),

              _buildCommonDetails(),

              if (data != null) ...[
                const SizedBox(height: 10),
                _buildTypeSpecificDetails(data),
              ],

              // Add some bottom padding for better scrolling experience
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    // return Card(
    //   elevation: 3,
    //   margin: const EdgeInsets.all(12),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         _buildHeader(),

    //         const Divider(),

    //         _buildCommonDetails(),

    //         if (data != null) ...[
    //           const SizedBox(height: 10),
    //           _buildTypeSpecificDetails(data),
    //         ],
    //       ],
    //     ),
    //   ),
    // );
  }

  // ✅ HEADER
  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          _getActivityIcon(activity.type),
          color: _getStatusColor(activity.status),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            activity.getActivityName(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          activity.status.name.toUpperCase(),
          style: TextStyle(
            color: _getStatusColor(activity.status),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ✅ COMMON DETAILS
  Widget _buildCommonDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row("Timestamp", formatDateTime(activity.timestamp)),
        _row("User ID", activity.user),
      ],
    );
  }

  // ✅ TYPE-SPECIFIC UI
  Widget _buildTypeSpecificDetails(Map<String, dynamic> data) {
    switch (activity.type) {
      case ActivityType.invoiceSave:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Dealer Name", data["dealerName"]),
            _row("TIN No", data["tinNo"]),
            _row("Invoice Amount", data["invoiceAmount"]),
            if (data["parts"] != null) _buildReturnItemsList(data["parts"]),
          ],
        );

      case ActivityType.receiptSave:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Dealer Name", data["dealerName"]),
            _row("Cheque No", data["chequeNumber"]),
            _row("Amount", data["chequeAmount"]),
            _row("Branch", data["branchName"]),
          ],
        );

      case ActivityType.returnSave:
      case ActivityType.returnRequestAdjustment:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Dealer Name", data["dealerName"]),
            _row("Return Type", data["returnType"]),
            _row("Reason", data["returnReason"]),
            if (data["returnItems"] != null) _buildReturnItemsList(data["returnItems"]),
          ],
        );

      case ActivityType.adviceOfDispatchNote:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Dealer Name", data["dealerName"]),
            if (data["tins"] != null) _buildTinNumberList(data["tins"]),
          ],
        );
      // New mappings for your parameters

      case ActivityType.attendanceOn:
      case ActivityType.attendanceOff:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data["workMode"] != null) _row("Work Mode", data["workMode"]),
            if (data["remark"] != null) _row("Remark", data["remark"]),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  // ✅ HELPER ROW
  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text("${value ?? '-'}")),
        ],
      ),
    );
  }


Widget _buildTinNumberList(dynamic tinsData) {
  // If there's no data or it's not a list, show nothing.
  if (tinsData == null || tinsData is! List) return const SizedBox.shrink();

  final tinNumbers = <String>[];
  for (final item in tinsData) {
    if (item is Map && item.containsKey('tinNumber')) {
      tinNumbers.add(item['tinNumber'].toString());
    }
  }

  if (tinNumbers.isEmpty) return const SizedBox.shrink();

  // Build the bullet list.
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      const Text(
        "Tin Numbers:",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      const SizedBox(height: 4),
      ...tinNumbers.map(
        (tin) => Padding(
          padding: const EdgeInsets.only(left: 8, top: 2),
          child: Text("• $tin"),
        ),
      ),
    ],
  );
}


Widget _buildReturnItemsList(dynamic returnItemsData) {
  if (returnItemsData == null || returnItemsData is! List) {
    return const SizedBox.shrink();
  }

  // Ensure we have a list of maps
  final items = returnItemsData.whereType<Map<String, dynamic>>().toList();
  if (items.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      const Text(
        "Return Items:",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      const SizedBox(height: 4),
      ...items.map((item) {
        // Extract the fields we care about (use safe fallbacks)
        final partNo = item['partNo']?.toString() ?? '-';
        final requestQty = item['requestQty']?.toString() ?? '-';
        final returnQty = item['returnQty']?.toString() ?? '-';

        return Container(
          margin: const EdgeInsets.only(bottom: 8, left: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Part Number
              _row("Part Number", partNo),
              // Request Quantity
              _row("Request Qty", requestQty),
              // Return Quantity
              _row("Return Qty", returnQty),
            ],
          ),
        );
      }).toList(),
    ],
  );
}


  // Widget _listSection(
  //   String title,
  //   List<Map<String, dynamic>> list, {
  //   required List<String> displayParams, // Parameters to display
  // }) {
  //   if (list.isEmpty) return const SizedBox.shrink();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 6),
  //       Text(
  //         "$title:",
  //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //       ),
  //       const SizedBox(height: 4),
  //       ...list.asMap().entries.map((entry) {
  //         //int index = entry.key;
  //         Map<String, dynamic> item = entry.value;

  //         // Filter only the specified parameters that exist in the item
  //         // final displayItems =
  //         //     item.entries
  //         //         .where((property) => displayParams.contains(property.key))
  //         //         .toList();

  //         final displayItems = item.entries.toList();

  //         // Skip if nothing to show
  //         if (displayItems.isEmpty) return const SizedBox.shrink();


  //         return Container(
  //           margin: const EdgeInsets.only(bottom: 12),
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey.shade300),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Item header with index number
  //               // Text(
  //               //   "Item ${index + 1}:",
  //               //   style: const TextStyle(
  //               //     fontWeight: FontWeight.w600,
  //               //     color: Colors.blue,
  //               //   ),
  //               // ),
  //               const SizedBox(height: 6),
  //               // Display only specified properties line by line
  //               ...displayItems.map((property) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(left: 8, top: 4),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         flex: 2,
  //                         child: Text(
  //                           "${_getPropertyDisplayName(property.key)}:",
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.grey,
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(
  //                           _formatValue(property.value),
  //                           style: const TextStyle(fontWeight: FontWeight.w400),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     ],
  //   );
  // }

  // Widget _listSection(String title, List<Map<String, dynamic>> list) {
  //   if (list.isEmpty) return const SizedBox.shrink();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 6),
  //       Text(
  //         "$title:",
  //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //       ),
  //       const SizedBox(height: 4),
  //       ...list.asMap().entries.map((entry) {
  //         int index = entry.key;
  //         Map<String, dynamic> item = entry.value;

  //         return Container(
  //           margin: const EdgeInsets.only(bottom: 12),
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey.shade300),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Item header with index number
  //               Text(
  //                 "Item ${index + 1}:",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               const SizedBox(height: 6),
  //               // Display each property line by line
  //               ...item.entries.map((property) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(left: 8, top: 4),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         flex: 2,
  //                         child: Text(
  //                           "${_getPropertyDisplayName(property.key)}:",
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.grey,
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(
  //                           _formatValue(property.value),
  //                           style: const TextStyle(fontWeight: FontWeight.w400),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     ],
  //   );
  // }

  // String _getPropertyDisplayName(String propertyName) {
  //   // Dictionary for special property name mappings
  //   const Map<String, String> specialMappings = {
  //   'partno': 'Part Number',
  //   'requestqty': 'Request Quantity',
  //   'returnqty': 'Return Quantity',
  //   'tinNumber': 'Tin Number'
  //   };
  //   return specialMappings[propertyName]!;
  // }

  // String _getPropertyDisplayName(String propertyName) {
  //   const Map<String, String> specialMappings = {
  //     'partNo': 'Part Number',
  //     'requestQty': 'Request Quantity',
  //     'returnQty': 'Return Quantity',
  //     'tinNumber': 'Tin Number',
  //   };
  //   // Use lowercase for lookup
  //   String key = propertyName;
  //   if (specialMappings.containsKey(key)) {
  //     return specialMappings[key]!;
  //   }
  //   // Return original propertyName if not found
  //   return propertyName;
  // }

  // String _formatValue(dynamic value) {
  //   if (value == null) return '-';
  //   if (value is bool) return value ? 'Yes' : 'No';
  //   if (value is DateTime) return DateFormat('yyyy-MM-dd HH:mm').format(value);
  //   if (value is num) {
  //     // Check if it might be a decimal/currency value
  //     if (value is double && value % 1 != 0) {
  //       return value.toStringAsFixed(2);
  //     }
  //     return value.toString();
  //   }
  //   return value.toString();
  // }

  Map<String, dynamic>? _extractData(Activity activity) {
    if (activity.metadata != null &&
        activity.metadata!["data"] is Map<String, dynamic>) {
      return activity.metadata!["data"];
    }
    return null;
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.invoiceSave:
        return Icons.receipt;
      case ActivityType.invoiceReprint:
        return Icons.print;
      case ActivityType.receiptSave:
        return Icons.payments;
      case ActivityType.receiptReprint:
        return Icons.print;
      case ActivityType.returnSave:
        return Icons.assignment_return;
      case ActivityType.adviceOfDispatchNote:
        return Icons.local_shipping;
      case ActivityType.returnRequestAdjustment:
        return Icons.edit_note;
      case ActivityType.attendanceOn:
        return Icons.login;
      case ActivityType.attendanceOff:
        return Icons.logout;
    }
  }

  // ✅ STATUS COLOR
  Color _getStatusColor(StatusType? status) {
    switch (status) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.failed:
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }
}
