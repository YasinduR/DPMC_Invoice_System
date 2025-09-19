import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/app_option_picker.dart';

// View of Attendance Screen
class AttendanceView extends StatefulWidget {
  final List<String> attendanceOptions;
  final void Function(String attendance, DateTime date) onSubmit;

  const AttendanceView({
    super.key,
    required this.onSubmit,
    required this.attendanceOptions,
  });

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  String? _selectedAttendance;
  DateTime? _selectedDate;
  late List<String> _AttendanceOptions;

  @override
  void initState() {
    super.initState();
    _AttendanceOptions = widget.attendanceOptions;
  }

  void onDateSelected(date) {
    setState(() => _selectedDate = date);
  }

  Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SelectionModal(
            title: 'Attendance',
            options: _AttendanceOptions,
            initialValue: _selectedAttendance,
          ),
    );
    if (result != null) {
      setState(() {
        _selectedAttendance = result;
      });
    }
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
                labelText: 'Select Cheque Date',
                selectedDate: _selectedDate,
                onDateSelected: onDateSelected,
              ),
              const SizedBox(height: 24),
              PickerFormField(
                inputFieldLabelText: 'Select Attendance',
                selectedOption: _selectedAttendance,
                onTap: _showReasonPicker,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Save',
            disabled: _selectedAttendance == null || _selectedDate == null,
            onPressed: () {
              if (_selectedAttendance != null && _selectedDate != null) {
                widget.onSubmit(_selectedAttendance!, _selectedDate!);
              }
            },
          ),
        ),
      ],
    );
  }
}
