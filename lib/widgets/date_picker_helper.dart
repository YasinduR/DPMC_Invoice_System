import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart'; // Adjust path to your theme file

Future<DateTime?> selectDate(BuildContext context, DateTime? initialDate) {
  DateTime? selectedDate = initialDate;
  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: AppColors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: initialDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColors.primary, // Use your primary color for OK
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColors.primary, // Use your primary color for OK
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(selectedDate);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
