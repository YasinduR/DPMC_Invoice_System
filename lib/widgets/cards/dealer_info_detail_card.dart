// Added by Darshan R on 06/04/2026
import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DealerInfoDetailCard extends StatelessWidget {
  final Dealer dealer;
  final String firstLabel;
  final String? firstValue;
  final String secondLabel;
  final String? secondValue;
  final String? error;
  final ColorPalette? palette; // New: Optional palette for dynamic theming

  const DealerInfoDetailCard({
    super.key,
    required this.dealer,
    this.firstLabel = 'Approved',
    this.firstValue,
    this.secondLabel = 'Total Payment',
    this.secondValue,
    this.error,
    this.palette, // New: Optional palette
  });

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the effective palette (either passed in or from Theme)
    final effectivePalette = palette ?? Theme.of(context).extension<AppColorsExtension>()?.palette;

    final showStats = firstValue != null || secondValue != null || error != null;
    final displayFirstValue = firstValue ?? '0';
    final displaySecondValue = secondValue ?? '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectivePalette?.white ?? AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: effectivePalette?.dialogShadowColor ?? Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AutoSizeText(
              '${dealer.accountCode} - ${dealer.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: effectivePalette?.text,
              ),
              maxLines: 1,
            ),
          ),
          if (showStats) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  error!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 12),
                ),
              ),
            Row(
              children: [
                _statItem(firstLabel, displayFirstValue, effectivePalette?.primary ?? AppColors.primary),
                _statItem(secondLabel, displaySecondValue, effectivePalette?.warning ?? AppColors.warning),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
