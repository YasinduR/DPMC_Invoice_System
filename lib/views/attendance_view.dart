import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/employee_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_data_grid.dart';
import 'package:myapp/widgets/app_fixed_text_field.dart';
import 'package:myapp/widgets/app_radio_group.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/date_display_card.dart';
import 'package:myapp/widgets/cards/employee_info_card.dart';

class AttendanceView extends StatefulWidget {
  final User currentUser; // Now takes the currentUser directly
  const AttendanceView({super.key, required this.currentUser});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  String? _selectedWorkOption;

  // Today Attendence Status
  Attendance? _currentAttendance;
  bool _isLoadingAttendance = true;
  String? _attendanceErrorMessage;

  // Employee Data
  Employee? _employeeInfo;
  bool _isLoadingEmployee = true;
  String? _employeeErrorMessage;

  // Attendance of past days
  List<Attendance>? _attendanceRecords;
  bool _isLoadingAttendanceRecords = true;
  String? _attendanceRecordsErrorMessage;

  DateTime? _selectedDate;
  final List<String> _workOptions = ['Home', 'Office', 'Field'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedWorkOption = _workOptions[0];
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchTodayAttendance());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchEmployeeInfo());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchAttendanceRecords());
  }


  Future<void> _fetchTodayAttendance() async {
    setState(() {
      _isLoadingAttendance = true;
      _attendanceErrorMessage = null; // Clear previous errors
    });

    final today = DateTime.now();
    final filters = {
      'userID': widget.currentUser.id, // Use widget.currentUser.id
      'date': DateTime(today.year, today.month, today.day).toIso8601String(),
    };

    if (!context.mounted) return;
    await inquire<Attendance>(
      context: context,
      dataUrl: 'api/attendance/list',
      filters: filters,
      onSuccess: (data) {
        if (mounted) {
          setState(() {
            if (data.isNotEmpty) {
              _currentAttendance = data.first;
              _selectedWorkOption = _currentAttendance!.workMode;
            } else {
              _currentAttendance = null;
              _selectedWorkOption = _workOptions[0];
            }
            _isLoadingAttendance = false;
          });
        }
      },
      onError: (e) {
        if (mounted) {
          String? localErrorMessage;
          setState(() {
            _isLoadingAttendance = false;
            if (e.contains('No data found')) {
              _currentAttendance = null;
              _selectedWorkOption = _workOptions[0];
            } else {
              String errorMessage = e.toString().replaceFirst(
                'Exception: ',
                '',
              );
              localErrorMessage =
                  'Failed to fetch attendance data: $errorMessage';
              _attendanceErrorMessage = localErrorMessage;
            }
          });
          if (localErrorMessage != null &&
              context.mounted &&
              !e.contains('No data found')) {
            showSnackBar(
              context: context,
              message: localErrorMessage!,
              type: MessageType.error,
            );
          }
        }
      },
    );
  }

  Future<void> _fetchAttendanceRecords() async {
    setState(() {
      _isLoadingAttendanceRecords = true;
      _attendanceRecordsErrorMessage = null; // Clear previous errors
    });

    final today = DateTime.now();
    final endOfRange = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));
    final startOfRange = endOfRange.subtract(const Duration(days: 20));

    final filters = {
      'userID': widget.currentUser.id, // Use widget.currentUser.id
      'date_start': startOfRange.toIso8601String().split('T')[0], // YYYY-MM-DD
      'date_end': endOfRange.toIso8601String().split('T')[0], // YYYY-MM-DD
    };

    if (!context.mounted) return;
    await inquire<Attendance>(
      context: context,
      dataUrl: 'api/attendance/list',
      filters: filters,
      onSuccess: (data) {
        if (mounted) {

      setState(() {
        if (data.isNotEmpty) {
          _attendanceRecords = data;
        } else {
          _attendanceRecords = null;
        }
        _isLoadingAttendanceRecords = false;
        if (_attendanceRecords != null && _currentAttendance != null) {
        if(_currentAttendance?.end != null){
      //_attendanceRecords = _currentAttendance! + _attendanceRecords;
      _attendanceRecords!.insert(0, _currentAttendance!);
      }
    }
          });
        }
      },
      onError: (e) {
        if (mounted) {
          String? localErrorMessage;
          setState(() {
            _isLoadingAttendanceRecords = false;
            if (e.contains('No data found')) {
              _attendanceRecords = null;
            } else {
              String errorMessage = e.toString().replaceFirst(
                'Exception: ',
                '',
              );
              localErrorMessage =
                  'Failed to fetch attendance data: $errorMessage';
              _attendanceRecordsErrorMessage = localErrorMessage;
            }
          });
          if (localErrorMessage != null &&
              context.mounted &&
              !e.contains('No data found')) {
            showSnackBar(
              context: context,
              message: localErrorMessage!,
              type: MessageType.error,
            );
          }
        }
      },
    );
  }

  Future<void> _fetchEmployeeInfo() async {
    setState(() {
      _isLoadingEmployee = true;
      _employeeErrorMessage = null;
    });
    final filters = {'id': widget.currentUser.id}; // Use widget.currentUser.id
    if (!context.mounted) return;
    await inquire<Employee>(
      context: context,
      dataUrl: 'api/employee/list',
      filters: filters,
      onSuccess: (data) {
        if (!context.mounted) return;
        setState(() {
          if (data.isNotEmpty) {
            _employeeInfo = data.first;
          } else {
            _employeeInfo = null;
            _employeeErrorMessage = 'Employee data not found.';
          }
          _isLoadingEmployee = false;
        });
      },
      onError: (e) {
        if (!context.mounted) return;
        String? localErrorMessage;
        setState(() {
          _isLoadingEmployee = false;
          if (e.contains('No data found') ||
              e.contains('Exception: No data found')) {
            _employeeInfo = null;
            localErrorMessage = 'Employee data not found.';
            _employeeErrorMessage = localErrorMessage;
          } else {
            String errorMessage = e.toString().replaceFirst('Exception: ', '');
            localErrorMessage = 'Failed to fetch employee data: $errorMessage';
            _employeeErrorMessage = localErrorMessage;
          }
          //});
          if (localErrorMessage != null &&
              context.mounted &&
              !e.contains('No data found') &&
              !e.contains('Exception: No data found')) {
            showSnackBar(
              context: context,
              message: localErrorMessage!,
              type: MessageType.error,
            );
          }
        });
      },
    );
  }

  void _onStart() async {
    if (_selectedWorkOption == null) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: 'Please select a work mode.',
          type: MessageType.error,
        );
      }
      return;
    }

    final now = DateTime.now();
    final newAttendance = Attendance(
      userID: widget.currentUser.id, // Use widget.currentUser.id
      date: DateTime(now.year, now.month, now.day),
      attendanceType: 'ATTENDANCE',
      workMode: _selectedWorkOption!,
      start: now,
      end: null,
      remark: null,
    );

    if (!context.mounted) return;
    await save<Attendance>(
      context: context,
      dataUrl: 'api/attendance/save',
      dataToSave: newAttendance,
      onSuccess: () {
        if (context.mounted) {
          showSnackBar(
            context: context,
            message: 'Attendance started successfully!',
            type: MessageType.success,
          );
        }
        _fetchTodayAttendance(); // Refresh UI
      },
      onError: (e) {
        if (context.mounted) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          showSnackBar(
            context: context,
            message: 'Failed to start attendance: $errorMessage',
            type: MessageType.error,
          );
        }
      },
    );
  }

  void _onEnd() async {
    if (_currentAttendance == null || _currentAttendance!.start == null) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message:
              'Cannot end attendance. Attendance was not started or not found.',
          type: MessageType.error,
        );
      }
      return;
    }

    final now = DateTime.now();
    final updatedAttendance = _currentAttendance!.copyWith(end: now);

    if (!context.mounted) return;
    await save<Attendance>(
      context: context,
      dataUrl: 'api/attendance/save',
      dataToSave: updatedAttendance,
      onSuccess: () {
        if (context.mounted) {
          showSnackBar(
            context: context,
            message: 'Attendance ended successfully!',
            type: MessageType.success,
          );
        }
        _fetchTodayAttendance(); // Refresh UI
        setState(() {
          if (_attendanceRecords != null) {
            _attendanceRecords!.insert(0, updatedAttendance);
            }
        });
      },
      onError: (e) {
        if (context.mounted) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          showSnackBar(
            context: context,
            message: 'Failed to end attendance: $errorMessage',
            type: MessageType.error,
          );
        }
      },
    );
  }

  Widget _buildAttendanceRecordArea() {
    if (_isLoadingAttendanceRecords) {
      return const Center(child: Text('Loading Attendance Records ...'));
    } else if (_attendanceRecords == null) {
      return const Center(
        child: Text('No Attendance Records found for you !.'),
      );
    } else if (_attendanceRecords!.isEmpty) {
      return const Center(
        child: Text('No Attendance Records found for you !.'),
      );
    } else {
      return AppDataGrid<Attendance>(
        hasFilter: false, // <-- Hides the filter/search bar
        items: _attendanceRecords!,
        filterableFields: const [],
        mergeRules: [
          // Merge Cells When Holiday OR Leave
          DataGridMergeRule<Attendance>(
            shouldMerge: (att) => att.start == null && att.end == null,
            startColumnIndex: 1,
            endColumnIndex: 3,
            mergedCellBuilder:
                (context, att) => Center(
                  child: Text(
                    att.attendanceType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          att.attendanceType == 'HOLIDAY'
                              ? AppColors.success
                              : AppColors.danger,
                    ),
                  ),
                ),
            decorationBuilder:
                (context, att) => BoxDecoration(
                  color:
                      att.attendanceType == 'HOLIDAY'
                          ? AppColors.successLight
                          : AppColors.dangerLight, // Distinct background color for leave rows
                ),
          ),
        ],
        columns: [
          DynamicColumn<Attendance>(
            label: 'Date',
            flex: 1,
            cellBuilder:
                (context, att) => AutoSizeText(
                  att.date.toIso8601String().split('T')[0],
                  maxLines: 1,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
          ),
          DynamicColumn<Attendance>(
            label: 'Worked From',
            flex: 1,
            cellBuilder:
                (context, att) => AutoSizeText(
                  att.workMode, // Assuming attendanceType covers "Worked From"
                  maxLines: 1,
                   minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
          ),
          DynamicColumn<Attendance>(
            label: 'Started',
            flex: 1,
            cellBuilder:
                (context, att) => AutoSizeText(
                  // Assuming `att.date` is already a String in 'YYYY-MM-DD' format
                  // att.start != null? att.start!.toIso8601String().split('T')[1]  : 'N/A',
                  att.start != null ? DateFormat('HH:mm').format(att.start!) : 'N/A',
                  maxLines: 1,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
          ),
          DynamicColumn<Attendance>(
            label: 'Ended',
            flex: 1,
            cellBuilder:
                (context, att) => AutoSizeText(
                  att.end != null ? DateFormat('HH:mm').format(att.end!) : 'N/A',
                  maxLines: 1,
                   minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
          ),
        ],
      );
    }
  }
  
  // void _onWorkOptionSelected(String? option) {
  //   setState(() {
  //     _selectedWorkOption = option;
  //   });
  // }

  // Future<void> _showWorkOptionPicker() async {
  //   final result = await showDialog<String>(
  //     context: context,
  //     builder:
  //         (context) => SelectionModal(
  //           title: 'Work From',
  //           options: _workOptions,
  //           initialValue: _selectedWorkOption, // Use internal state
  //         ),
  //   );
  //   if (result != null) {
  //     _onWorkOptionSelected(result); // Call internal method
  //   }
  // }

  void onDateSelected(date) {
    setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingAttendance || _isLoadingEmployee) {
      return const Center(child: Text('Loading..'));
    }

    if (_attendanceErrorMessage != null) {
      return Center(child: Text(_attendanceErrorMessage!));
    }

    if (_employeeErrorMessage != null) {
      return Center(child: Text(_employeeErrorMessage!));
    }

    // Ensure _employeeInfo is not null before using it
    if (_employeeInfo == null) {
      return const Center(child: Text('Employee information not available.'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              EmployeeInfoCard(employee: _employeeInfo!), // Use internal state
              const SizedBox(height: 25),
              DateDisplayCard(
              selectedDate: _selectedDate!),
              // DatePickerField(
              //   labelText: 'Select Date',
              //   selectedDate: _selectedDate,
              //   onDateSelected: onDateSelected,
              //   disabled: true, // Attendance is usually for current day
              // ),
              const SizedBox(height: 20),
              TitledRadioGroup(
                title: 'Work From',
                options: _workOptions,
                selectedValue: _selectedWorkOption!,
                enabled: _currentAttendance?.start == null,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedWorkOption = value);
                  }
                },
              ),

              const SizedBox(height: 24),
              Row(
                // Use MainAxisAlignment.spaceEvenly or .start if you only have one field sometimes
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_currentAttendance?.start != null)
                    Flexible(
                    fit: FlexFit.loose,
                      child: FixedTextField(
                        headerLabelText: 'Start Time', // Added header label for clarity
                        //inputFieldLabelText: 'Start Time', // Fallback label
                        selectedOption: DateFormat(
                          'hh:mm a',
                        ).format(_currentAttendance!.start!),
                        //isDisabled: true, // Make it explicitly disabled
                      ),
                    ),
                  // Add horizontal space ONLY if both start and end times exist
                  if (_currentAttendance?.start != null &&
                      _currentAttendance?.end != null)
                    const SizedBox(width: 6), // <-- Use width for horizontal spacing

                  if (_currentAttendance?.end != null)
                    Flexible( 
                    fit: FlexFit.loose,
                      child: FixedTextField(
                        headerLabelText: 'End Time', // Added header label for clarity
                        selectedOption: DateFormat(
                          'hh:mm a',
                        ).format(_currentAttendance!.end!),
                      ),
                    ),
                ],
              ),
              // Row(children: [
              // if (_currentAttendance?.start != null)
              //   FixedTextField(
              //     inputFieldLabelText: 'Start Time',
              //     selectedOption: DateFormat(
              //       'hh:mm a',
              //     ).format(_currentAttendance!.start!),
              //   ),
              // if (_currentAttendance?.start != null &&
              //     _currentAttendance?.end != null)
              //   const SizedBox(height: 12),
              // if (_currentAttendance?.end != null)
              //   FixedTextField(
              //     inputFieldLabelText: 'End Time',
              //     selectedOption: DateFormat(
              //       'hh:mm a',
              //     ).format(_currentAttendance!.end!),
              //   ),
              // ],),
              const SizedBox(height: 24),
              SizedBox(height: 250.0, child: _buildAttendanceRecordArea()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              if (_currentAttendance?.start == null)
                ActionButton(
                  icon: Icons.check_circle_outline,
                  label: 'Start Attendance',
                  disabled: _selectedWorkOption == null,
                  onPressed: _onStart, // Call internal method
                ),
              if (_currentAttendance?.start != null &&
                  _currentAttendance?.end == null)
                ActionButton(
                  icon: Icons.close,

                  type: ActionButtonType.secondary,
                  label: 'End Attendance',
                  disabled: false,
                  onPressed: _onEnd, // Call internal method
                ),
            ],
          ),
        ),
      ],
    );
  }
}
