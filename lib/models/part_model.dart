import 'package:myapp/mappers/mappable.dart';
import 'package:myapp/helpers/common_functions.dart';

class Part implements Mappable{
  final String id;
  final String partNo;
  final int requestQty;
  final String description;
  final double price;
  final double discount; // The price for a single unit of this part.
  int receivedQty;

  Part({
    required this.id,
    required this.partNo,
    required this.requestQty,
    required this.price,
    this.description = 'N/A',
    this.discount = 0,
    this.receivedQty = 0, // Defaults to 0 received
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partNo': partNo,
      'requestQty': requestQty,
      'description': description,
      'price': formatNumber(price),
      'discount': formatNumber(discount),
      'receivedQty': receivedQty,
    };
  }
  Part copyWith({
    String? id,
    String? partNo,
    double? price,
    int? requestQty,
    int? receivedQty,
    String? description,
    double? discount,
    int? returnQty,
  }) {
    return Part(
      id: id ?? this.id,
      partNo: partNo ?? this.partNo,
      price: price ?? this.price,
      requestQty: requestQty ?? this.requestQty,
      receivedQty: (returnQty != null) 
          ? ((requestQty ?? this.requestQty) - returnQty).clamp(0, requestQty ?? this.requestQty) 
          : (receivedQty ?? this.receivedQty),
      description: description ?? this.description,
      discount: discount ?? this.discount,
    );
  }
  int get returnQty => (requestQty - receivedQty).clamp(0, requestQty);
  set returnQty(int value) {
    receivedQty = requestQty - value;
  }

  factory Part.fromJson(Map<String, dynamic> json) {
  return Part(
    id: json['loadedNo'] ?? '',
    partNo: json['partNo'] ?? '',
    requestQty: json['quantity'] ?? 0,
    price: (json['priceWithTaxes'] as num?)?.toDouble() ?? 0.0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    description: json['prodHierCode'] ?? 'N/A',
    receivedQty: 0,
  );
}
}
