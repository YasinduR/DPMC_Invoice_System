import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_stat_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/cards/dealerwise_tin_detail_card.dart';

class DealerTinView extends StatelessWidget {
  final DealerStat dealer;
  final List<TinData> tins;
  const DealerTinView({super.key, required this.dealer, required this.tins});

  @override
  Widget build(BuildContext context) {
    final dealerTins =
        tins.where((t) => t.dealercode == dealer.accountCode).toList();

    // Added by Darshan R on 2026-04-03
    // Categorize tins
    final pendingTins = dealerTins.where((t) => t.paymentStatus == 'P').toList();
    final approvedTins =
        dealerTins.where((t) => t.paymentStatus == 'A').toList();
    final completedTins =
        dealerTins.where((t) => t.paymentStatus == 'C').toList();
    final invoicedTins =
        dealerTins.where((t) => t.paymentStatus == 'I').toList();

    if (dealerTins.isEmpty) {
      return const Center(child: Text('No TINs found'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pendingTins.isNotEmpty) ...[
          _buildSectionHeader('Pending', pendingTins.length, AppColors.warning),
          ...pendingTins.map((tin) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DealerTinCard(tin: tin),
              )),
          const SizedBox(height: 16),
        ],
        if (approvedTins.isNotEmpty) ...[
          _buildSectionHeader('Approved', approvedTins.length, AppColors.primary),
          ...approvedTins.map((tin) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DealerTinCard(tin: tin),
              )),
          const SizedBox(height: 16),
        ],
        if (completedTins.isNotEmpty) ...[
          _buildSectionHeader('Completed', completedTins.length, AppColors.success),
          ...completedTins.map((tin) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DealerTinCard(tin: tin),
              )),
          const SizedBox(height: 16),
        ],
        if (invoicedTins.isNotEmpty) ...[
          _buildSectionHeader('Invoiced', invoicedTins.length, AppColors.disabled),
          ...invoicedTins.map((tin) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DealerTinCard(tin: tin),
              )),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  // Added by Darshan R on 2026-04-03
  Widget _buildSectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const Expanded(child: Divider(indent: 12)),
        ],
      ),
    );
  }
}
