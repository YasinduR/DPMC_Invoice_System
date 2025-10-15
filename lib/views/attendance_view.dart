import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/app_option_picker.dart';
import 'package:myapp/widgets/app_fixed_text_field.dart';

class AttendanceView extends StatefulWidget {
  final DateTime? start;
  final DateTime? end;
  final String? selectedWorkOption; // Renamed from workOption
  final void Function(String?) onWorkOptionSelected; // New callback
  final void Function() onStart;
  final void Function() onEnd;

  const AttendanceView({
    super.key,
    this.start,
    this.end,
    this.selectedWorkOption, // Renamed
    required this.onWorkOptionSelected, // New
    required this.onStart,
    required this.onEnd,
  });

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  DateTime? _selectedDate;
  final List<String> _workOptions = ['Home', 'Office', 'Field'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); 
  }

  Future<void> _showWorkOptionPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SelectionModal(
        title: 'Work From',
        options: _workOptions,
        initialValue: widget.selectedWorkOption,
      ),
    );
    if (result != null) {
      widget.onWorkOptionSelected(result);
    }
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
                disabled: true, // Attendance is usually for current day
              ),
              const SizedBox(height: 20),
                PickerFormField(
                inputFieldLabelText: 'Select Attendance',
                selectedOption: widget.selectedWorkOption,
                onTap: _showWorkOptionPicker,
                isDisabled: widget.start != null ,
              ),
              const SizedBox(height: 24),
              if (widget.start != null)
                  FixedTextField( inputFieldLabelText: 'Start Time',selectedOption: DateFormat('hh:mm a').format(widget.start!),),
              if (widget.start != null && widget.end != null)
                const SizedBox(height: 12),
              if (widget.end != null)
                  FixedTextField( inputFieldLabelText: 'End Time',selectedOption: DateFormat('hh:mm a').format(widget.end!),),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              if (widget.start == null)
                ActionButton(
                  icon: Icons.check_circle_outline,
                  label: 'Start Attendance',
                  disabled: widget.selectedWorkOption == null,
                  onPressed: () {  widget.onStart(); },
                ),
              if (widget.start != null && widget.end == null) 
                ActionButton(
                  icon: Icons.close,
                  type: ActionButtonType.secondary,
                  label: 'End Attendance',
                  disabled: false,
                  onPressed: () {  widget.onEnd(); },
                ),
            ],
          ),
        ),
      ],
    );
  }
}