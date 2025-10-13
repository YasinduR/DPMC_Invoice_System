import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/views/attendance_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

// --- Attendece Screen: Attendance For Admin ROLES----//
class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  // void _onSubmit(String attendanceCode, DateTime date) async {
  //   final authState = ref.watch(authProvider);
  //   final User? currentUser = authState.currentUser;
  //   if (currentUser != null) {
  //     final attendeceData = Attendance(
  //       userID: currentUser.id,
  //       date: date,
  //       attendance: attendanceCode,
  //     );

  //     final String attendanceDescription =
  //         _attendance[attendanceCode] ?? attendanceCode;
  //     final formattedDate = DateFormat('dd MMM yyyy').format(date);

  //     await save(
  //       context: context,
  //       dataUrl: 'api/attendance/save',
  //       dataToSave: attendeceData,
  //       onSuccess: () {
  //         showSnackBar(
  //           context: context,
  //           message:
  //               'Attendance on $formattedDate saved as "$attendanceDescription" successfully!',
  //           type: MessageType.success,
  //         );
  //         Navigator.of(context).pop();
  //       },
  //       onError: (e) {
  //         String errorMessage = e.toString().replaceFirst('Exception: ', '');
  //         showSnackBar(
  //           context: context,
  //           message: errorMessage,
  //           type: MessageType.error,
  //         );
  //       },
  //     );
  //   } else {
  //     showSnackBar(
  //       context: context,
  //       message: 'No user has logged in.',
  //       type: MessageType.error,
  //     );
  //   }
  // }
  void _onStart() async {}
  void _onEnd() async {}


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
      title: 'Attendance',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: AttendanceView(onStart: _onStart, onEnd: _onEnd),
    );
  }
}
