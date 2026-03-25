// Added by Darshan R on 25/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/helpers/common_functions.dart';

class TinStatsCard extends StatelessWidget {
  final int approved;
  final double totalPayment;
  final String? error;

  const TinStatsCard({
    super.key,
    required this.approved,
    required this.totalPayment,
    this.error,
  });

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _statItem('Pending', approved.toString(), AppColors.primary),
      _statItem('Total Payment', formatNumber(totalPayment), AppColors.warning),
    ];

    return Column(
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: items),
          ),
        ),
      ],
    );
  }
}