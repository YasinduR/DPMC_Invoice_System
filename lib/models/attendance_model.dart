import 'package:myapp/contracts/mappable.dart';

class Attendance implements Mappable {
  final String userID;
  final DateTime date;
  final String attendanceType;
  final String workMode;
  final DateTime? start;
  final double? startLat; // Starting Position Lat
  final double? startLon; // Starting Position Lon
  final DateTime? end;
  final double? endLat; // Ending Position Lat
  final double? endLon; // Ending Position Lon
  final String? remark;

  Attendance({
    required this.userID,
    required this.date,
    required this.attendanceType,
    required this.workMode,
    this.start,
    this.startLat,
    this.startLon,
    this.end,
    this.endLat,
    this.endLon,
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
      'end': end?.toIso8601String() ?? 'N/A',
      'startLat':startLat,  
      'startLon':startLon,
      'endLat':endLat,  
      'endLon':endLon,      // Convert to ISO 8601 string if not null, otherwise 'N/A'
      'remark': remark,
    };
  }

    Attendance copyWith({
    String? userID,
    DateTime? date,
    String? attendanceType,
    String? workMode,
    DateTime? start,
    double? startLat,
    double? startLon,
    DateTime? end,
    double? endLat,
    double? endLon,
    String? remark,
  }) {
    return Attendance(
      userID: userID ?? this.userID,
      date: date ?? this.date,
      attendanceType: attendanceType ?? this.attendanceType,
      workMode: workMode ?? this.workMode,
      start: start ?? this.start,
      startLat: startLat ?? this.startLat,
      startLon: startLon ?? this.startLon,
      end: end ?? this.end,
      endLat: endLat ?? this.endLat,
      endLon: endLon ?? this.endLon,
      remark: remark ?? this.remark,
    );
  }
}