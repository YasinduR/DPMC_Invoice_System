import 'package:flutter/material.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/views/attendance_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  Attendance? _currentAttendance;
  String? _selectedWorkOption;
  bool _isLoadingAttendance = true;
  String? _attendanceErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTodayAttendance();
  }

  Future<void> _fetchTodayAttendance() async {
    setState(() {
      _isLoadingAttendance = true;
      _attendanceErrorMessage = null; // Clear previous errors
    });

    final authState = ref.read(authProvider);
    final User? currentUser = authState.currentUser;

    if (currentUser == null) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: 'No user is logged in. Please log in again.',
          type: MessageType.error,
        );
      }
      setState(() {
        _isLoadingAttendance = false;
        _attendanceErrorMessage = 'User not logged in.';
      });
      return;
    }

    final today = DateTime.now();
    final filters = {
      'userID': currentUser.id,
      'date': DateTime(today.year, today.month, today.day).toIso8601String(),
    };

    if (!context.mounted) return;
    await inquire<Attendance>(
      context: context,
      dataUrl: 'api/attendance/list',
      filters: filters,
      onSuccess: (data) {
        setState(() {
          if (data.isNotEmpty) {
            _currentAttendance = data.first;
            _selectedWorkOption = _currentAttendance!.workMode;
          } else {
            _currentAttendance = null;
            _selectedWorkOption = null; // Or set a default like 'Office'
          }
          _isLoadingAttendance = false;
        });
      },
      onError: (e) {
        setState(() {
          _isLoadingAttendance = false;
          // Handle 'No data found' as a non-error state for initial display
          if (e.contains('No data found')) {
            _currentAttendance = null;
            _selectedWorkOption = null;
          } else {
            String errorMessage = e.toString().replaceFirst('Exception: ', '');
            _attendanceErrorMessage =
                'Failed to fetch attendance data: $errorMessage';
            if (context.mounted) {
              showSnackBar(
                context: context,
                message: _attendanceErrorMessage!,
                type: MessageType.error,
              );
            }
          }
        });
      },
    );
  }

  void _onStart() async {
    final authState = ref.read(authProvider);
    final User? currentUser = authState.currentUser;

    if (currentUser == null || _selectedWorkOption == null) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: 'Please select a work mode and ensure user is logged in.',
          type: MessageType.error,
        );
      }
      return;
    }

    final now = DateTime.now();
    final newAttendance = Attendance(
      userID: currentUser.id,
      date: DateTime(now.year, now.month, now.day),
      attendanceType: 'ATTENDANCE', // Default status
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
        //Locally Update Attendance Status to manage Bckground notifications remove later if not nessary

        if (context.mounted) {
          showSnackBar(
            context: context,
            message: 'Attendance started successfully! ',
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
        return;
      },
    );
  final LocalStorageService localStorageService = LocalStorageService(); // Instantiate here

    final String today = localStorageService.getCurrentDateFormatted();
    final String? currentStatus = await localStorageService.getAttendanceStatusForDate(today);
    if (currentStatus == null || currentStatus == 'Pending') {
      if (currentStatus == null) {
        await localStorageService.updateAttendanceStatus(today, 'Started');
        print('Attendance status changed from null to Pending.');
        // Notify UI about the change if needed
      }
    }
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
      onSuccess: () async {
        if (context.mounted) {
          showSnackBar(
            context: context,
            message: 'Attendance ended successfully!',
            type: MessageType.success,
          );
        }
        //Locally Update Attendance Status to manage Bckground notifications remove later if not nessary
        final LocalStorageService localStorageService = LocalStorageService();
        final String today =
            localStorageService.getCurrentDateFormatted(); // e.g., "2025-10-26"
        await localStorageService.updateAttendanceStatus(today, 'Marked');
        _fetchTodayAttendance(); // Refresh UI
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

  void _onWorkOptionSelected(String? option) {
    setState(() {
      _selectedWorkOption = option;
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;

    if (currentUser == null) {
      return const AppPage(
        title: '',
        child: Center(
          child: Text('No user is logged in. Please log in again.'),
        ),
      );
    }
    if (_isLoadingAttendance) {
      return const AppPage(
        title: 'Attendance',
        onBack: null,
        canPop: false,
        child: Center(child: Text('Loading..')),
      );
    }
    if (_attendanceErrorMessage != null) {
      return AppPage(
        title: 'Attendance',
        onBack: _goBack,
        child: Center(child: Text(_attendanceErrorMessage!)),
      );
    }
    return AppPage(
      title: 'Attendance',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: AttendanceView(
        start: _currentAttendance?.start,
        end: _currentAttendance?.end,
        selectedWorkOption: _selectedWorkOption,
        onWorkOptionSelected: _onWorkOptionSelected,
        onStart: _onStart,
        onEnd: _onEnd,
      ),
    );
  }
}
