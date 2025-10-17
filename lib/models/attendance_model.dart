import 'package:myapp/contracts/mappable.dart';

class Attendance implements Mappable {
  final String userID;
  final DateTime date;
  final String attendanceType;
  final String workMode;
  final DateTime? start;
  final DateTime? end;
  final String? remark;

  Attendance({
    required this.userID,
    required this.date,
    required this.attendanceType,
    required this.workMode,
    this.start,
    this.end,
    this.remark,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'date': date.toIso8601String(),
      'attendanceType': attendanceType,
      'workMode': workMode,
      'start': start?.toIso8601String() ?? 'N/A', // Convert to ISO 8601 string if not null, otherwise 'N/A'
      'end': end?.toIso8601String() ?? 'N/A',     // Convert to ISO 8601 string if not null, otherwise 'N/A'
      'remark': remark,
    };
  }

    Attendance copyWith({
    String? userID,
    DateTime? date,
    String? attendanceType,
    String? workMode,
    DateTime? start,
    DateTime? end,
    String? remark,
  }) {
    return Attendance(
      userID: userID ?? this.userID,
      date: date ?? this.date,
      attendanceType: attendanceType ?? this.attendanceType,
      workMode: workMode ?? this.workMode,
      start: start ?? this.start,
      end: end ?? this.end,
      remark: remark ?? this.remark,
    );
  }
}