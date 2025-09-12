import 'package:myapp/contracts/mappable.dart';
class Part implements Mappable {
  final String id;
  final String partNo;
  final int requestQty;
  final double price; // The price for a single unit of this part.
  
  // These fields represent the state manipulated by the user in the UI.
  //bool isSelected;
  int receivedQty;

  Part({
    required this.id,
    required this.partNo,
    required this.requestQty,
    required this.price,
    //this.isSelected = false, // Defaults to not selected
    this.receivedQty = 0,    // Defaults to 0 received
  });
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'partNo': partNo, 
      'requestQty': requestQty,
      'price': price,
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
  }) {
    return Part(
      id: id ?? this.id,
      partNo: partNo ?? this.partNo,
      price: price ?? this.price,
      requestQty: requestQty ?? this.requestQty,
      receivedQty: receivedQty ?? this.receivedQty,
    );
  }
}



