import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Dealer Information Card Element 

class DealerInfoCard extends StatelessWidget {
  final Dealer dealer;
  const DealerInfoCard({super.key, required this.dealer});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
      // Text(
      //   '${dealer.name} - ${dealer.accountCode}',
      //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      // ),
      AutoSizeText(
        '${dealer.name} - ${dealer.accountCode}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        maxLines: 1,
      ),
    );
  }
}
