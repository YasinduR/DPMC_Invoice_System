// Added by Darshan R on 25/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/models/tin_stat_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/helpers/common_functions.dart';

class TinStatsCard extends StatelessWidget {
  final TinStat stats;
  final String? title;
  final String firstLabel;
  final String secondLabel;

  const TinStatsCard({
    super.key,
    required this.stats,
    this.title,
    this.firstLabel = 'Approved',
    this.secondLabel = 'Total Payment',
  });

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      _statItem(firstLabel, stats.approved.toString(), AppColors.primary),
      _statItem(secondLabel, formatNumber(stats.totalPayment), AppColors.warning),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         if (stats.error != null)
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 8.0),
             child: Text(stats.error!, style: const TextStyle(color: Colors.red)),
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