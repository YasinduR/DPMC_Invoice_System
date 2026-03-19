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
          child: Row(
            children: [
              // TIN Number (Bold) - Left
              Expanded(
                flex: 1,
                child: Text(
                  tin.tinNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                ),
              ),
              // Amount (Semi-bold) - Middle, Right Aligned
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    tin.totalValue.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              // Status (Semi-bold) with background - Right, Center Aligned
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: tin.paymentStatusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getPaymentStatusText(tin.paymentStatus),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}