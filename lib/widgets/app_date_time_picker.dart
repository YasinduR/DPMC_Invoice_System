import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/theme/app_colors.dart';

class DateTimePickerField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool disabled;

  const DateTimePickerField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!disabled) {
          final pickedDateTime = await selectDate(context, selectedDate);
          if (pickedDateTime != null) {
            onDateSelected(pickedDateTime);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isEmpty: selectedDate == null,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? ''
                    : DateFormat('dd MMM yyyy HH:mm').format(selectedDate!),
                style: const TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> selectDate(BuildContext context, DateTime? initialDate) async {
  // 1. Show date picker
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          // colorScheme: ColorScheme.light(
          //   primary: AppColors.primary,
          //   onPrimary: AppColors.white,
          //   onSurface: Colors.black,
          // ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate == null) return null; // User cancelled date picker

  // 2. Show time picker
  final initialTime = TimeOfDay.fromDateTime(initialDate ?? DateTime.now());
  final pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          // colorScheme: ColorScheme.light(
          //   primary: AppColors.primary,
          //   onPrimary: AppColors.white,
          //   onSurface: Colors.black,
          // ),
        ),
        child: child!,
      );
    },
  );

  if (pickedTime == null) return null; // User cancelled time picker

  // Combine date and time
  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}