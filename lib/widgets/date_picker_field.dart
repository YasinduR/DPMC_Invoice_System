import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/theme/app_theme.dart'; // Adjust path if needed
import 'date_picker_helper.dart'; // Import the helper

class DatePickerField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    // Text(
    //   labelText,
    //   style: const TextStyle(
    //     fontWeight: FontWeight.bold,
    //     color: AppColors.primary,
    //   ),
    // ),
    // const SizedBox(height: 8),
    // InkWell(
    //   onTap: () async {
    //     final pickedDate = await selectDate(context, selectedDate);
    //     if (pickedDate != null && pickedDate != selectedDate) {
    //       onDateSelected(pickedDate);
    //     }
    //   },
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    //     decoration: BoxDecoration(
    //       color: AppColors.white,
    //       borderRadius: BorderRadius.circular(12),
    //       border: Border.all(color: AppColors.borderDark),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           selectedDate == null
    //               ? labelText
    //               : DateFormat('dd MMM yyyy').format(selectedDate!),
    //           style: TextStyle(
    //             color:
    //                 selectedDate == null ? AppColors.borderDark : Colors.black,
    //             fontSize: 16,
    //           ),
    //         ),
    //         const Icon(Icons.calendar_today, color: AppColors.primary),
    //       ],
    //     ),
    //   ),
    // );

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
