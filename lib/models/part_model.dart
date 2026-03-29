import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/return_item_model.dart';

class Part implements Mappable, ReturnItem {
  final String id;
  @override
  final String partNo;
  @override
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

  @override
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

  @override
  int get returnQty => (requestQty - receivedQty).clamp(0, requestQty);

  @override
  set returnQty(int value) {
    receivedQty = requestQty - value;
  }
}
