import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/part_model.dart';

class DispatchNoteSave implements Mappable {
  final String dispatchNumber;
  final String tinNo;
  final String orderNo;
  final String payOndel;
  final String route;
  final String dealerName;
  final String dealerVatNo;
  final String dealerAddress;
  final String dealerId;

  final String userId;
  final DateTime dispatchTime;

  final int noOfBoxes;
  final int noOfTags;
  final int noOfPlasticBoxes;
  final String? remarks;

  final List<Part> parts;

  DispatchNoteSave({
    required this.dispatchNumber,
    required this.tinNo,
    required this.orderNo,
    required this.payOndel,
    required this.route,
    required this.dealerName,
    required this.dealerVatNo,
    required this.dealerAddress,
    required this.dealerId,
    required this.userId,
    required this.dispatchTime,
    required this.noOfBoxes,
    required this.noOfTags,
    required this.noOfPlasticBoxes,
    this.remarks,
    required this.parts,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'dispatchNumber': dispatchNumber,
      'tinNo': tinNo,
      'orderNo': orderNo,
      'payOndel': payOndel,
      'route': route,
      'dealerName': dealerName,
      'dealerVatNo': dealerVatNo,
      'dealerAddress': dealerAddress,
      'dealerId': dealerId,
      'userId': userId,
      'dispatchTime': dispatchTime.toIso8601String(),
      'noOfBoxes': noOfBoxes,
      'noOfTags': noOfTags,
      'noOfPlasticBoxes': noOfPlasticBoxes,
      'remarks': remarks,
      'parts': parts.map((item) => item.toMap()).toList(),
    };
  }

  DispatchNoteSave copyWith({
    String? dispatchNumber,
    String? tinNo,
    String? orderNo,
    String? payOndel,
    String? route,
    String? dealerName,
    String? dealerVatNo,
    String? dealerAddress,
    String? dealerId,
    String? userId,
    DateTime? dispatchTime,
    int? noOfBoxes,
    int? noOfTags,
    int? noOfPlasticBoxes,
    String? remarks,
    List<Part>? parts,
  }) {
    return DispatchNoteSave(
      dispatchNumber: dispatchNumber ?? this.dispatchNumber,
      tinNo: tinNo ?? this.tinNo,
      orderNo: orderNo ?? this.orderNo,
      payOndel: payOndel ?? this.payOndel,
      route: route ?? this.route,
      dealerName: dealerName ?? this.dealerName,
      dealerVatNo: dealerVatNo ?? this.dealerVatNo,
      dealerAddress: dealerAddress ?? this.dealerAddress,
      dealerId: dealerId ?? this.dealerId,
      userId: userId ?? this.userId,
      dispatchTime: dispatchTime ?? this.dispatchTime,
      noOfBoxes: noOfBoxes ?? this.noOfBoxes,
      noOfTags: noOfTags ?? this.noOfTags,
      noOfPlasticBoxes: noOfPlasticBoxes ?? this.noOfPlasticBoxes,
      remarks: remarks ?? this.remarks,
      parts: parts ?? this.parts,
    );
  }
}