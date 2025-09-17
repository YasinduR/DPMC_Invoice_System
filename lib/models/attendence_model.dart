import 'package:myapp/contracts/mappable.dart';

class Attendance implements Mappable {
  final String userID;
  final DateTime date;
  final bool attendance;
  final String? remark;

  Attendance({
    required this.userID,
    required this.date,
    required this.attendance,
    this.remark,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'date': date.toIso8601String(),
      'attendance': attendance,
      'remark': remark,
    };
  }
}