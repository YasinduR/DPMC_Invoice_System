import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/attendence_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/views/attendence_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

// --- Attendece Screen: Attendence For Admin ROLES----//
class AttendenceScreen extends ConsumerStatefulWidget {
  const AttendenceScreen({super.key});

  @override
  ConsumerState<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends ConsumerState<AttendenceScreen> {

    final Map<String, String> _attendance = {  // Attendence Types with Desc
    'P': 'Present',
    'E': 'Exam',
    'A': 'Absent',
    'A1': 'Absent on 1st Half',
    'A2': 'Absent on 2nd Half',
    'L': 'Leave',
    'L1': 'Leave on 1st Half',
    'L2': 'Leave on 2nd Half',
  };


  void _onSubmit(String attendenceCode, DateTime date) async {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    if (currentUser != null) {
      final attendeceData = Attendence(
        userID: currentUser.id,
        date: date,
        attendance: attendenceCode,
      );      
    
    final String attendanceDescription = _attendance[attendenceCode] ?? attendenceCode;
    final formattedDate = DateFormat('dd MMM yyyy').format(date); 

      await save(
        context: context,
        dataUrl: 'api/attendence/save',
        dataToSave: attendeceData,
        onSuccess: () {
          showSnackBar(
            context: context,
            message: 'Attendance on $formattedDate saved as "$attendanceDescription" successfully!',
            type: MessageType.success,
          );
           Navigator.of(context).pop();
        },
        onError: (e) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          showSnackBar(
            context: context,
            message: errorMessage,
            type: MessageType.error,
          );
        },
      );
    } else {
      showSnackBar(
        context: context,
        message: 'No user has logged in.',
        type: MessageType.error,
      );
    }
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
    return AppPage(
      title: 'Attendence',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: AttendenceView(onSubmit: _onSubmit,    attendenceOptions: _attendance.keys.toList(),
      ),
    );
  }
}
