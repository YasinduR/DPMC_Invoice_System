// Added by Darshan R on 16/03/2026
import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme_helper.dart';

/// Card widget that displays a single dealer in a responsive card layout.
class DealerSelectionCard extends StatelessWidget {
  final Dealer dealer;
  final VoidCallback onTap;

  const DealerSelectionCard({
    super.key,
    required this.dealer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final map = dealer.toMap();

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Account Code | Name
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        map['accountCode']?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
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
                        map['name']?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Remaining fields: Address & City
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address (centered)
                  Center(
                    child: Text(
                      map['address']?.toString() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 2),
                  
                  // City (centered)
                  Center(
                    child: Text(
                      map['city']?.toString() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}