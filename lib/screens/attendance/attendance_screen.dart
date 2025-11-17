import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/attendance_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;

    if (currentUser == null) {
      return AppPage(
        title: 'Attendance',
        onBack: _goBack, // Allow going back from this screen if no user
        child: const Center(
          child: Text('No user is logged in. Please log in again.'),
        ),
      );
    }

    // Pass the current user to AttendanceView, which will handle its own loading and errors
    return AppPage(
      title: 'Attendance',
      onBack: _goBack,
      //contentPadding: EdgeInsets.zero,
      child: AttendanceView(
        currentUser: currentUser,
      ),
    );
  }
}






// class AttendanceScreen extends ConsumerStatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
//   Attendance? _currentAttendance;
//   String? _selectedWorkOption;
//   bool _isLoadingAttendance = true;
//   String? _attendanceErrorMessage;

//   // New state variables for employee info
//   Employee? _employeeInfo;
//   bool _isLoadingEmployee = true; // Separate loading state for employee info
//   String? _employeeErrorMessage; // Separate error message for employee info

//   @override
//   void initState() {
//     super.initState();
//     _fetchTodayAttendance();
//     _fetchEmployeeInfo();
//   }

//   Future<void> _fetchTodayAttendance() async {
//     setState(() {
//       _isLoadingAttendance = true;
//       _attendanceErrorMessage = null; // Clear previous errors
//     });

//     final authState = ref.read(authProvider);
//     final User? currentUser = authState.currentUser;

//     if (currentUser == null) {
//       if (context.mounted) {
//         showSnackBar(
//           context: context,
//           message: 'No user is logged in. Please log in again.',
//           type: MessageType.error,
//         );
//       }
//       setState(() {
//         _isLoadingAttendance = false;
//         _attendanceErrorMessage = 'User not logged in.';
//       });
//       return;
//     }

//     final today = DateTime.now();
//     final filters = {
//       'userID': currentUser.id,
//       'date': DateTime(today.year, today.month, today.day).toIso8601String(),
//     };

//     if (!context.mounted) return;
//     await inquire<Attendance>(
//       context: context,
//       dataUrl: 'attendance/list',
//       filters: filters,
//       onSuccess: (data) {
//         // Defer setState until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!context.mounted) return;
//           // setState(() {
//           if (data.isNotEmpty) {
//             _currentAttendance = data.first;
//             _selectedWorkOption = _currentAttendance!.workMode;
//           } else {
//             _currentAttendance = null;
//             _selectedWorkOption = null;
//           }
//           _isLoadingAttendance = false;
//         });
//         //  });
//       },
//       onError: (e) {
//         // Defer setState and showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!context.mounted) return;
//           String? localErrorMessage;
//           //  setState(() {
//           _isLoadingAttendance = false;
//           if (e.contains('No data found')) {
//             _currentAttendance = null;
//             _selectedWorkOption = null;
//           } else {
//             String errorMessage = e.toString().replaceFirst('Exception: ', '');
//             localErrorMessage =
//                 'Failed to fetch attendance data: $errorMessage';
//             _attendanceErrorMessage = localErrorMessage;
//           }
//           //  });
//           if (localErrorMessage != null && context.mounted) {
//             showSnackBar(
//               context: context,
//               message: localErrorMessage!,
//               type: MessageType.error,
//             );
//           }
//         });
//       },
//     );
//     setState(() {});
//   }

//   // New method to fetch employee information using the provided inquire function
//   Future<void> _fetchEmployeeInfo() async {
//     setState(() {
//       _isLoadingEmployee = true;
//       _employeeErrorMessage = null;
//     });

//     final authState = ref.read(authProvider);
//     final User? currentUser = authState.currentUser;

//     if (currentUser == null) {
//       setState(() {
//         _isLoadingEmployee = false;
//         _employeeErrorMessage = 'User not logged in to fetch employee info.';
//       });
//       return;
//     }

//     // Filter by 'id' for the Employee model
//     final filters = {'id': currentUser.id};

//     if (!context.mounted) return;
//     await inquire<Employee>(
//       // Use Employee type for inquire
//       context: context,
//       dataUrl: 'employee/list',
//       filters: filters,
//       onSuccess: (data) {
//         // Defer setState until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!context.mounted) return;
//           // setState(() {
//           if (data.isNotEmpty) {
//             _employeeInfo = data.first;
//           } else {
//             _employeeInfo = null;
//             _employeeErrorMessage =
//                 'Employee data not found.'; // Treat as a message, not a critical error
//           }
//           _isLoadingEmployee = false;
//           //  });
//         });
//       },
//       onError: (e) {
//         // Defer setState and showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!context.mounted) return;
//           String? localErrorMessage;
//           // setState(() {
//           _isLoadingEmployee = false;
//           if (e.contains('No data found') ||
//               e.contains('Exception: No data found')) {
//             _employeeInfo = null;
//             localErrorMessage = 'Employee data not found.';
//             _employeeErrorMessage = localErrorMessage;
//           } else {
//             String errorMessage = e.toString().replaceFirst('Exception: ', '');
//             localErrorMessage = 'Failed to fetch employee data: $errorMessage';
//             _employeeErrorMessage = localErrorMessage;
//           }
//           // });
//           if (localErrorMessage != null &&
//               context.mounted &&
//               !e.contains('No data found') &&
//               !e.contains('Exception: No data found')) {
//             showSnackBar(
//               context: context,
//               message: localErrorMessage!,
//               type: MessageType.error,
//             );
//           }
//         });
//       },
//     );
//     setState(() {});
//   }

//   void _onStart() async {
//     final authState = ref.read(authProvider);
//     final User? currentUser = authState.currentUser;

//     if (currentUser == null || _selectedWorkOption == null) {
//       if (context.mounted) {
//         showSnackBar(
//           context: context,
//           message: 'Please select a work mode and ensure user is logged in.',
//           type: MessageType.error,
//         );
//       }
//       return;
//     }

//     final now = DateTime.now();
//     final newAttendance = Attendance(
//       userID: currentUser.id,
//       date: DateTime(now.year, now.month, now.day),
//       attendanceType: 'ATTENDANCE', // Default status
//       workMode: _selectedWorkOption!,
//       start: now,
//       end: null,
//       remark: null,
//     );

//     if (!context.mounted) return;
//     await save<Attendance>(
//       context: context,
//       dataUrl: 'attendance/save',
//       dataToSave: newAttendance,
//       onSuccess: () {
//         // Defer showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (context.mounted) {
//             showSnackBar(
//               context: context,
//               message: 'Attendance started successfully!',
//               type: MessageType.success,
//             );
//           }
//           _fetchTodayAttendance(); // This internally handles postFrameCallback for its setState
//         });
//       },
//       onError: (e) {
//         // Defer showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (context.mounted) {
//             String errorMessage = e.toString().replaceFirst('Exception: ', '');
//             showSnackBar(
//               context: context,
//               message: 'Failed to start attendance: $errorMessage',
//               type: MessageType.error,
//             );
//           }
//         });
//       },
//     );
//   }

//   void _onEnd() async {
//     if (_currentAttendance == null || _currentAttendance!.start == null) {
//       if (context.mounted) {
//         showSnackBar(
//           context: context,
//           message:
//               'Cannot end attendance. Attendance was not started or not found.',
//           type: MessageType.error,
//         );
//       }
//       return;
//     }

//     final now = DateTime.now();
//     final updatedAttendance = _currentAttendance!.copyWith(end: now);

//     if (!context.mounted) return;
//     await save<Attendance>(
//       context: context,
//       dataUrl: 'attendance/save',
//       dataToSave: updatedAttendance,
//       onSuccess: () {
//         // Defer showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (context.mounted) {
//             showSnackBar(
//               context: context,
//               message: 'Attendance ended successfully!',
//               type: MessageType.success,
//             );
//           }
//           _fetchTodayAttendance(); // This internally handles postFrameCallback for its setState
//         });
//       },
//       onError: (e) {
//         // Defer showSnackBar until after the current frame
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (context.mounted) {
//             String errorMessage = e.toString().replaceFirst('Exception: ', '');
//             showSnackBar(
//               context: context,
//               message: 'Failed to end attendance: $errorMessage',
//               type: MessageType.error,
//             );
//           }
//         });
//       },
//     );
//   }

//   // Future<void> _fetchTodayAttendance() async {
//   //   setState(() {
//   //     _isLoadingAttendance = true;
//   //     _attendanceErrorMessage = null; // Clear previous errors
//   //   });

//   //   final authState = ref.read(authProvider);
//   //   final User? currentUser = authState.currentUser;

//   //   if (currentUser == null) {
//   //     if (context.mounted) {
//   //       showSnackBar(
//   //         context: context,
//   //         message: 'No user is logged in. Please log in again.',
//   //         type: MessageType.error,
//   //       );
//   //     }
//   //     setState(() {
//   //       _isLoadingAttendance = false;
//   //       _attendanceErrorMessage = 'User not logged in.';
//   //     });
//   //     return;
//   //   }

//   //   final today = DateTime.now();
//   //   final filters = {
//   //     'userID': currentUser.id,
//   //     'date': DateTime(today.year, today.month, today.day).toIso8601String(),
//   //   };

//   //   if (!context.mounted) return;
//   //   await inquire<Attendance>(
//   //     context: context,
//   //     dataUrl: 'attendance/list',
//   //     filters: filters,
//   //     onSuccess: (data) {
//   //       setState(() {
//   //         if (data.isNotEmpty) {
//   //           _currentAttendance = data.first;
//   //           _selectedWorkOption = _currentAttendance!.workMode;
//   //         } else {
//   //           _currentAttendance = null;
//   //           _selectedWorkOption = null; // Or set a default like 'Office'
//   //         }
//   //         _isLoadingAttendance = false;
//   //       });
//   //     },
//   //     onError: (e) {
//   //       setState(() {
//   //         _isLoadingAttendance = false;
//   //         // Handle 'No data found' as a non-error state for initial display
//   //         if (e.contains('No data found')) {
//   //           _currentAttendance = null;
//   //           _selectedWorkOption = null;
//   //         } else {
//   //           String errorMessage = e.toString().replaceFirst('Exception: ', '');
//   //           _attendanceErrorMessage =
//   //               'Failed to fetch attendance data: $errorMessage';
//   //           if (context.mounted) {
//   //             showSnackBar(
//   //               context: context,
//   //               message: _attendanceErrorMessage!,
//   //               type: MessageType.error,
//   //             );
//   //           }
//   //         }
//   //       });
//   //     },
//   //   );
//   // }

//   // // New method to fetch employee information using the provided inquire function
//   // Future<void> _fetchEmployeeInfo() async {
//   //   setState(() {
//   //     _isLoadingEmployee = true;
//   //     _employeeErrorMessage = null;
//   //   });

//   //   final authState = ref.read(authProvider);
//   //   final User? currentUser = authState.currentUser;

//   //   if (currentUser == null) {
//   //     setState(() {
//   //       _isLoadingEmployee = false;
//   //       _employeeErrorMessage = 'User not logged in to fetch employee info.';
//   //     });
//   //     return;
//   //   }

//   //   // Filter by 'id' for the Employee model
//   //   final filters = {'id': currentUser.id};

//   //   if (!context.mounted) return;
//   //   await inquire<Employee>(
//   //     // Use Employee type for inquire
//   //     context: context,
//   //     dataUrl: 'employee/list',
//   //     filters: filters,
//   //     onSuccess: (data) {
//   //       setState(() {
//   //         if (data.isNotEmpty) {
//   //           _employeeInfo = data.first;
//   //         } else {
//   //           _employeeInfo = null;
//   //           _employeeErrorMessage = 'Employee data not found.';
//   //         }
//   //         _isLoadingEmployee = false;
//   //       });
//   //     },
//   //     onError: (e) {
//   //       setState(() {
//   //         _isLoadingEmployee = false;
//   //         // Check for 'No data found' as a non-error state if no employee is found for the ID
//   //         if (e.contains('No data found') ||
//   //             e.contains('Exception: No data found')) {
//   //           _employeeInfo = null;
//   //           _employeeErrorMessage = 'Employee data not found.';
//   //         } else {
//   //           String errorMessage = e.toString().replaceFirst('Exception: ', '');
//   //           _employeeErrorMessage =
//   //               'Failed to fetch employee data: $errorMessage';
//   //           if (context.mounted) {
//   //             showSnackBar(
//   //               context: context,
//   //               message: _employeeErrorMessage!,
//   //               type: MessageType.error,
//   //             );
//   //           }
//   //         }
//   //       });
//   //     },
//   //   );
//   // }

//   // void _onStart() async {
//   //   final authState = ref.read(authProvider);
//   //   final User? currentUser = authState.currentUser;

//   //   if (currentUser == null || _selectedWorkOption == null) {
//   //     if (context.mounted) {
//   //       showSnackBar(
//   //         context: context,
//   //         message: 'Please select a work mode and ensure user is logged in.',
//   //         type: MessageType.error,
//   //       );
//   //     }
//   //     return;
//   //   }

//   //   final now = DateTime.now();
//   //   final newAttendance = Attendance(
//   //     userID: currentUser.id,
//   //     date: DateTime(now.year, now.month, now.day),
//   //     attendanceType: 'ATTENDANCE', // Default status
//   //     workMode: _selectedWorkOption!,
//   //     start: now,
//   //     end: null,
//   //     remark: null,
//   //   );

//   //   if (!context.mounted) return;
//   //   await save<Attendance>(
//   //     context: context,
//   //     dataUrl: 'attendance/save',
//   //     dataToSave: newAttendance,
//   //     onSuccess: () {
//   //       if (context.mounted) {
//   //         showSnackBar(
//   //           context: context,
//   //           message: 'Attendance started successfully!',
//   //           type: MessageType.success,
//   //         );
//   //       }
//   //       _fetchTodayAttendance(); // Refresh UI
//   //     },
//   //     onError: (e) {
//   //       if (context.mounted) {
//   //         String errorMessage = e.toString().replaceFirst('Exception: ', '');
//   //         showSnackBar(
//   //           context: context,
//   //           message: 'Failed to start attendance: $errorMessage',
//   //           type: MessageType.error,
//   //         );
//   //       }
//   //     },
//   //   );
//   // }

//   // void _onEnd() async {
//   //   if (_currentAttendance == null || _currentAttendance!.start == null) {
//   //     if (context.mounted) {
//   //       showSnackBar(
//   //         context: context,
//   //         message:
//   //             'Cannot end attendance. Attendance was not started or not found.',
//   //         type: MessageType.error,
//   //       );
//   //     }
//   //     return;
//   //   }

//   //   final now = DateTime.now();
//   //   final updatedAttendance = _currentAttendance!.copyWith(end: now);

//   //   if (!context.mounted) return;
//   //   await save<Attendance>(
//   //     context: context,
//   //     dataUrl: 'attendance/save',
//   //     dataToSave: updatedAttendance,
//   //     onSuccess: () {
//   //       if (context.mounted) {
//   //         showSnackBar(
//   //           context: context,
//   //           message: 'Attendance ended successfully!',
//   //           type: MessageType.success,
//   //         );
//   //       }
//   //       _fetchTodayAttendance(); // Refresh UI
//   //     },
//   //     onError: (e) {
//   //       if (context.mounted) {
//   //         String errorMessage = e.toString().replaceFirst('Exception: ', '');
//   //         showSnackBar(
//   //           context: context,
//   //           message: 'Failed to end attendance: $errorMessage',
//   //           type: MessageType.error,
//   //         );
//   //       }
//   //     },
//   //   );
//   // }

//   void _onWorkOptionSelected(String? option) {
//     setState(() {
//       _selectedWorkOption = option;
//     });
//   }

//   void _goBack() {
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final User? currentUser = authState.currentUser;

//     if (currentUser == null) {
//       return const AppPage(
//         title: '',
//         child: Center(
//           child: Text('No user is logged in. Please log in again.'),
//         ),
//       );
//     }
//     if (_isLoadingAttendance || _isLoadingEmployee) {
//       return const AppPage(
//         title: 'Attendance',
//         onBack: null,
//         canPop: false,
//         child: Center(child: Text('Loading..')),
//       );
//     }
//     if (_attendanceErrorMessage != null) {
//       return AppPage(
//         title: 'Attendance',
//         onBack: _goBack,
//         child: Center(child: Text(_attendanceErrorMessage!)),
//       );
//     }
//     if (_employeeErrorMessage != null) {
//       return AppPage(
//         title: 'Attendance',
//         onBack: _goBack,
//         child: Center(child: Text(_employeeErrorMessage!)),
//       );
//     }

//     return AppPage(
//       title: 'Attendance',
//       onBack: _goBack,
//       contentPadding: EdgeInsets.zero,
//       child: AttendanceView(
//         employee: _employeeInfo!,
//         start: _currentAttendance?.start,
//         end: _currentAttendance?.end,
//         selectedWorkOption: _selectedWorkOption,
//         onWorkOptionSelected: _onWorkOptionSelected,
//         onStart: _onStart,
//         onEnd: _onEnd,
//       ),
//     );
//   }
// }
