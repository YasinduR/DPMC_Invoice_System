// Use to Save/Print of return saved
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/return_item_model.dart';

// --- Return Model ---
class Return implements Mappable {
  final String returnId;
  final String tinNo;
  final String route;
  final String dealerName;
  final String dealerId;
  final String userId;
  final String returnType;
  final String returnReason;
  final DateTime returnTime; 
  final List<ReturnItem> returnItems;

  Return({
    required this.returnId,
    required this.tinNo,
    required this.route,
    required this.dealerName,
    required this.dealerId,
    required this.userId,
    required this.returnType,
    required this.returnReason,
    required this.returnTime,
    required this.returnItems,
  });


  @override
  Map<String, dynamic> toMap() {
    return {
      'returnId': returnId,
      'tinNo': tinNo,
      'route': route,
      'dealerName': dealerName,
      'dealerId': dealerId,
      'userId': userId,
      'returnType': returnType,
      'returnReason': returnReason,
      'returnTime': returnTime.toIso8601String(),
      'returnItems': returnItems.map((item) => item.toMap()).toList(),
    };
  }

  Return copyWith({
    String? returnId,
    String? tinNo,
    String? route,
    String? dealerName,
    String? dealerId,
    String? userId,
    String? returnType,
    String? returnReason,
    DateTime? returnTime,
    List<ReturnItem>? returnItems,
  }) {
    return Return(
      returnId: returnId ?? this.returnId,
      tinNo: tinNo ?? this.tinNo,
      route: route ?? this.route,
      dealerName: dealerName ?? this.dealerName,
      dealerId: dealerId ?? this.dealerId,
      userId: userId ?? this.userId,
      returnType: returnType ?? this.returnType,
      returnReason: returnReason ?? this.returnReason,
      returnTime: returnTime ?? this.returnTime,
      returnItems: returnItems ?? this.returnItems,
    );
  }
}

