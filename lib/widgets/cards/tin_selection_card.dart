// Added by Darshan R on 18/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme_helper.dart';

/// Card widget that displays a single TIN in a responsive card layout.
class TinSelectionCard extends StatelessWidget {
  final TinData tin;
  final VoidCallback onTap;

  const TinSelectionCard({
    super.key,
    required this.tin,
    required this.onTap,
  });

  // String _getPaymentStatusText(String status) {
  //   switch (status) {
  //     case 'P':
  //       return 'Pending';
  //     case 'C':
  //       return 'Completed';
  //     case 'A':
  //       return 'Approved';
  //     default:
  //       return status;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      
      child:Container(
        decoration: AppThemeHelpers.getSelectionCardDecoration(),
        child: Card(
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
       // elevation: 6,
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
                  style: TextStyle(
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
                    formatNumber(tin.totalValue),
                    style: TextStyle(
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
                      tin.paymentStatusText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
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
      )),
    );
  }
}