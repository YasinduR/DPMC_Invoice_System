import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/theme/app_colors.dart'; 


// --- App DATE PICKER FIELD ---

class DatePickerField extends StatelessWidget {
  final String labelText; // Label on the field
  final DateTime? selectedDate; 
  final ValueChanged<DateTime> onDateSelected; // Call back fn when date selected

  const DatePickerField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
      onTap: () async {
        final pickedDate = await selectDate(context, selectedDate);
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isEmpty: selectedDate == null,
        decoration: InputDecoration(
          filled: true,                 // This enables the background color.
          fillColor: AppColors.white,   // This sets the color to white.
          labelText: labelText,
          labelStyle: const TextStyle(color: AppColors.borderDark), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
        ),
        
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? '' 
                    : DateFormat('dd MMM yyyy').format(selectedDate!),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.calendar_today, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
    //  ],
    // );
  }
}


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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
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
