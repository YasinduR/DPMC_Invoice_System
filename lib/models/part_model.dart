import 'package:myapp/contracts/mappable.dart';

class Part implements Mappable {
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
      'price': price,
      'discount': discount,
      'receivedQty': receivedQty,
    };
  }

  // This creates a new `Part` instance with same properties if not replaced
  Part copyWith({
    String? id,
    String? partNo,
    double? price,
    int? requestQty,
    int? receivedQty,
    String? description,
    double? discount,
  }) {
    return Part(
      id: id ?? this.id,
      partNo: partNo ?? this.partNo,
      price: price ?? this.price,
      requestQty: requestQty ?? this.requestQty,
      receivedQty: receivedQty ?? this.receivedQty,
      description: description ?? this.description,
      discount: discount ?? this.discount,
    );
  }
}
