import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/theme/app_colors.dart';

class DateDisplayCard extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback? onTap;

  const DateDisplayCard({Key? key, required this.selectedDate, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
    ).format(selectedDate);

    return Card(
      color: AppColors.gridBackgroundColor,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // Adjust margins as needed
      elevation: 2, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: InkWell(
        onTap: onTap, // Handled by the parent widget
        borderRadius: BorderRadius.circular(
          12.0,
        ), // Match card border for InkWell splash
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.primary, // Dark grey icon color
                size: 20,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                // Use Expanded to ensure the text takes available space
                child: AutoSizeText(
                  formattedDate,
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text, // Darker grey text color
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
