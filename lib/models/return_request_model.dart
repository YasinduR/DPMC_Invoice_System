// --- Return Model ---
// Use to Save/Print of return saved
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/return_item_model.dart';

class ReturnRequest implements Mappable {
  final String returnId;
 // final String tinNo;
//  final String route;
  //final String dealerName;
  final String dealerId;
  final String userId;
  final String returnType;
  final String returnReason;
  final DateTime? requestUpdate;
  final DateTime returnTime; 
  final List<ReturnItem> returnItems;

  ReturnRequest({
    required this.returnId,
   // required this.tinNo,
   // required this.route,
  //  required this.dealerName,
    required this.dealerId,
    required this.userId,
    required this.returnType,
    required this.returnReason,
    required this.returnTime,
    this.requestUpdate,
    required this.returnItems,
  });


  @override
  Map<String, dynamic> toMap() {
    return {
      'returnId': returnId,
    // 'tinNo': tinNo,
    // 'route': route,
    // 'dealerName': dealerName,
      'dealerId': dealerId,
      'userId': userId,
      'returnType': returnType,
      'returnReason': returnReason,
      'requestUpdate': requestUpdate!.toIso8601String(),
      'returnTime': returnTime.toIso8601String(),
      'returnItems': returnItems.map((item) => item.toMap()).toList(),
    };
  }

  ReturnRequest copyWith({
    String? returnId,
    //String? tinNo,
  //  String? route,
   // String? dealerName,
    String? dealerId,
    String? userId,
    String? returnType,
    String? returnReason,
    DateTime? returnTime,
    DateTime? requestUpdate,
    List<ReturnItem>? returnItems,
  }) {
    return ReturnRequest(
      returnId: returnId ?? this.returnId,
    //  tinNo: tinNo ?? this.tinNo,
     // route: route ?? this.route,
     // dealerName: dealerName ?? this.dealerName,
      dealerId: dealerId ?? this.dealerId,
      userId: userId ?? this.userId,
      returnType: returnType ?? this.returnType,
      returnReason: returnReason ?? this.returnReason,
      returnTime: returnTime ?? this.returnTime,
      returnItems: returnItems ?? this.returnItems, 
      requestUpdate: requestUpdate ?? this.requestUpdate,
    );
  }
}

