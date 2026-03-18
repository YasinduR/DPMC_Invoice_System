// Added by Darshan R on 18/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';

/// Card widget that displays a single TIN in a responsive card layout.
class TinSelectionCard extends StatelessWidget {
  final TinData tin;
  final VoidCallback onTap;

  const TinSelectionCard({
    super.key,
    required this.tin,
    required this.onTap,
  });

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'P':
        return 'Pending';
      case 'C':
        return 'Completed';
      case 'A':
        return 'Approved';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top row: TIN Number | Status in full text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        tin.tinNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '|',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _getPaymentStatusText(tin.paymentStatus),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: tin.paymentStatusColor,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Amount (centered)
              Text(
                tin.totalValue.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}