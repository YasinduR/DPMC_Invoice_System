import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_date_picker.dart';
import 'package:myapp/widgets/app_option_picker.dart';

class AttendenceView extends StatefulWidget {
  final List<String> attendenceOptions;
  final void Function(String attendence, DateTime date) onSubmit;

  const AttendenceView({
    super.key,
    required this.onSubmit,
    required this.attendenceOptions,
  });

  @override
  State<AttendenceView> createState() => _AttendenceViewState();
}

class _AttendenceViewState extends State<AttendenceView> {
  String? _selectedAttendence;
  DateTime? _selectedDate;
  late List<String> _AttendenceOptions;

  @override
  void initState() {
    super.initState();
    _AttendenceOptions = widget.attendenceOptions;
  }

  void onDateSelected(date) {
    setState(() => _selectedDate = date);
  }

  Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SelectionModal(
            title: 'Attendence',
            options: _AttendenceOptions,
            initialValue: _selectedAttendence,
          ),
    );
    if (result != null) {
      setState(() {
        _selectedAttendence = result;
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
                inputFieldLabelText: 'Select Attendence',
                selectedOption: _selectedAttendence,
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
            disabled: _selectedAttendence == null || _selectedDate == null,
            onPressed: () {
              if (_selectedAttendence != null && _selectedDate != null) {
                widget.onSubmit(_selectedAttendence!, _selectedDate!);
              }
            },
          ),
        ),
      ],
    );
  }
}
