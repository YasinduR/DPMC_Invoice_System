import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_date_picker.dart';

// View of Attendance Screen
class AttendanceView extends StatefulWidget {
  final void Function() onStart;
  final void Function() onEnd;
  const AttendanceView({super.key, required this.onStart, required this.onEnd});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  String? _selectedAttendance;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void onDateSelected(date) {
    setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DatePickerField(
                labelText: 'Select Date',
                selectedDate: _selectedDate,
                onDateSelected: onDateSelected,
                disabled: true,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Start',
            disabled: _selectedDate == null,
            onPressed: () {
              widget.onStart();
            },
          ),
          const SizedBox(height: 20),
            ActionButton(
            icon: Icons.close,
            type: ActionButtonType.secondary,
            label: 'End',
            disabled: _selectedDate == null,
            onPressed: () {
              widget.onEnd();
            },
          )
          
          ],)

        ),
      ],
    );
  }
}
