import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/tin_model.dart';

// Advice of Dispatch note model
class DispatchNoteSave implements Mappable {
  final String dispatchNumber;
  final List<TinData> tins;
  final String route;
  final String dealerName;
  final String dealerVatNo;
  final String dealerAddress;
  final String dealerId;
  final String userId;
  final DateTime dispatchTime;

  DispatchNoteSave({
    required this.dispatchNumber,
    required this.tins,
    required this.route,
    required this.dealerName,
    required this.dealerVatNo,
    required this.dealerAddress,
    required this.dealerId,
    required this.userId,
    required this.dispatchTime,

  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'dispatchNumber': dispatchNumber,
      'route': route,
      'dealerName': dealerName,
      'dealerVatNo': dealerVatNo,
      'dealerAddress': dealerAddress,
      'dealerId': dealerId,
      'userId': userId,
      'dispatchTime': formatDateTime(dispatchTime),
      'tins': tins.map((item) => item.toMap()).toList(),
    };
  }

 // Corrected copyWith method
  DispatchNoteSave copyWith({
    String? dispatchNumber,
    List<TinData>? tins,
    String? route,
    String? dealerName,
    String? dealerVatNo,
    String? dealerAddress,
    String? dealerId,
    String? userId,
    DateTime? dispatchTime,
  }) {
    return DispatchNoteSave(
      dispatchNumber: dispatchNumber ?? this.dispatchNumber,
      tins: tins ?? this.tins,  // Fixed: now properly handles tins
      route: route ?? this.route,
      dealerName: dealerName ?? this.dealerName,
      dealerVatNo: dealerVatNo ?? this.dealerVatNo,
      dealerAddress: dealerAddress ?? this.dealerAddress,
      dealerId: dealerId ?? this.dealerId,
      userId: userId ?? this.userId,
      dispatchTime: dispatchTime ?? this.dispatchTime,
    );
  }

}