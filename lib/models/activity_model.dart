import 'package:myapp/contracts/mappable.dart';

//class Activity implements Mappable {
//   final String id;
//   final String title;
//   final String? description;
//   final DateTime timestamp;
//   final ActivityType type;
//   final String? user;
//   final Map<String, dynamic>? metadata;
//   final StatusType? status;

//   Activity({
//     required this.id,
//     required this.title,
//     this.description,
//     required this.timestamp,
//     required this.type,
//     this.user,
//     this.metadata,
//     this.status,
//   });

//     @override
//     Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "title": title,
//       "description": description,
//       "timestamp": timestamp.toIso8601String(),
//       "type": type.name,
//       "user": user,
//       "metadata": metadata,
//       "status": status,
//     };
//   }

//     factory Activity.fromJson(Map<String, dynamic> json) {
//     return Activity(
//       id: json["id"],
//       title: json["title"],
//       description: json["description"],
//       timestamp: DateTime.parse(json["timestamp"]),
//       type: ActivityType.values.firstWhere((e) => e.name == json["type"]),
//       user: json["user"],
//       metadata: json["metadata"],
//       status: json["status"],
//     );
//   }
// }

class Activity implements Mappable {
  final String id;
  final String title;
  final String? endpoint;
  final DateTime timestamp;
  final ActivityType type;
  final String? user;
  final Map<String, dynamic>? metadata;
  final StatusType status;

  Activity({
    required this.id,
    required this.title,
    this.endpoint,
    required this.timestamp,
    required this.type,
    this.user,
    this.metadata,
    required this.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "endpoint": endpoint,
      "timestamp": timestamp.toIso8601String(),
      "type": type.name,
      "user": user,
      "metadata": metadata,
      "status": status.name,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json["id"],
      title: json["title"],
      endpoint: json["endpoint"],
      timestamp: DateTime.parse(json["timestamp"]),
      type: ActivityType.values.firstWhere((e) => e.name == json["type"]),
      user: json["user"],
      metadata: json["metadata"],
      status: StatusType.values.firstWhere((e) => e.name == json["status"])
    );
  }


   String getActivityName() {
    switch (type) {
      case ActivityType.invoiceSave:
        return "Invoice";
      case ActivityType.invoiceReprint:
        return "Invoice Reprint";
      case ActivityType.receiptSave:
        return "Receipt";
      case ActivityType.receiptReprint:
        return "Receipt Reprinted";
      case ActivityType.returnSave:
        return "Return";
      case ActivityType.adviceOfDispatchNote:
        return "Advice of Dispatch Note";
      case ActivityType.returnRequestAdjustment:
        return "Return Request Adjustment";
      case ActivityType.attendanceOn:
        return "Attendance On";
      case ActivityType.attendanceOff:
        return "Attendance Off";
    }
  }
}

enum ActivityType {
  invoiceSave,
  invoiceReprint,
  receiptSave,
  receiptReprint,
  returnSave,
  adviceOfDispatchNote,
  returnRequestAdjustment,
  attendanceOn,
  attendanceOff,
}

enum StatusType {
  success,
  failed,
  pending,
}