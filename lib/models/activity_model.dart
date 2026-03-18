import 'dart:convert';

import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/helpers/common_functions.dart';

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
      status: StatusType.values.firstWhere((e) => e.name == json["status"]),
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

  // String getActivityLog() {
  //   final buffer = StringBuffer();
  //   buffer.writeln("Activity       : ${getActivityName()}");
  //   buffer.writeln("--------------------------------------");
  //   buffer.writeln("Timestamp      : ${formatDateTime(timestamp)}");
  //   buffer.writeln("User ID        : $user");
  //   buffer.writeln("Status         : ${status.toString().toUpperCase()}");
  //   buffer.writeln("Endpoint       : $endpoint");
  //   buffer.writeln("Data           : ");
  //   if (metadata != null && metadata!["data"] != null) {
  //     buffer.writeln(
  //       const JsonEncoder.withIndent('  ').convert(metadata!["data"]),
  //     );
  //   }
  //   return buffer.toString();
  // }


  String getActivityLog() {
  final buffer = StringBuffer();

  buffer.writeln("Activity       : ${getActivityName()}");
  buffer.writeln("--------------------------------------");
  buffer.writeln("Timestamp      : ${formatDateTime(timestamp)}");
  buffer.writeln("User ID        : $user");
  buffer.writeln("Status         : ${status.name.toUpperCase()}");
 

  Map<String, dynamic>? data;

  if (metadata != null && metadata!["data"] != null) {
    if (metadata!["data"] is Map<String, dynamic>) {
      data = metadata!["data"];
    }
  }

  if (data != null) {
    buffer.writeln("");

    switch (type) {

      case ActivityType.invoiceSave:
        buffer.writeln("Dealer Name    : ${data["dealerName"]}");
        buffer.writeln("TIN No         : ${data["tinNo"]}");
        buffer.writeln("Invoice Amount : ${data["invoiceAmount"]}");
        break;

      case ActivityType.receiptSave:
        buffer.writeln("Dealer Name    : ${data["dealerName"]}");
        buffer.writeln("Cheque Number  : ${data["chequeNumber"]}");
        buffer.writeln("Cheque Amount  : ${data["chequeAmount"]}");
        buffer.writeln("Branch Name    : ${data["branchName"]}");
        break;

      case ActivityType.returnSave :
        buffer.writeln("Dealer Name    : ${data["dealerName"]}");
        buffer.writeln("Return Type    : ${data["returnType"]}");
        buffer.writeln("Return Reason  : ${data["returnReason"]}");

        if (data["returnItems"] is List) {
          buffer.writeln("Return Items   :");
          for (var item in data["returnItems"]) {
            buffer.writeln("  - ${jsonEncode(item)}");
          }
        }
        break;

        case ActivityType.returnRequestAdjustment :
        buffer.writeln("Dealer Name    : ${data["dealerName"]}");
        buffer.writeln("Return Type    : ${data["returnType"]}");
        buffer.writeln("Return Reason  : ${data["returnReason"]}");

        if (data["returnItems"] is List) {
          buffer.writeln("Return Items   :");
          for (var item in data["returnItems"]) {
            buffer.writeln("  - ${jsonEncode(item)}");
          }
        }
        break;

      case ActivityType.adviceOfDispatchNote:
        buffer.writeln("Dealer Name    : ${data["dealerName"]}");

        if (data["tins"] is List) {
          buffer.writeln("TINS           :");
          for (var tin in data["tins"]) {
            buffer.writeln("  - ${jsonEncode(tin)}");
          }
        }
        break;
      
      case ActivityType.attendanceOn:
      case ActivityType.attendanceOff:
        buffer.writeln("Attendance Type : ${data["attendanceType"]}");
        if (data["workMode"] != null) {
          buffer.writeln("Work Mode       : ${data["workMode"]}");
        }
        if (data["start"] != null) buffer.writeln("Start Time      : ${data["start"]}");
        if (data["end"] != null) buffer.writeln("End Time        : ${data["end"]}");
        if (data["remark"] != null) buffer.writeln("Remark          : ${data["remark"]}");
      break;
      default:
        break;
    }
    buffer.writeln("--------------------------------------");
    buffer.writeln("Endpoint       : $endpoint");
    buffer.writeln("");
    buffer.writeln("Data           :");
    buffer.writeln(const JsonEncoder.withIndent('  ').convert(data));
  }
  return buffer.toString();
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

enum StatusType { success, failed, pending }
