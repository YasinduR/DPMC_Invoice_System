import 'package:myapp/contracts/mappable.dart';

class ReturnItem implements Mappable {
  final String partNo;
  final int requestQty;
  int returnQty;
  //bool isSelected;

  ReturnItem({
    required this.partNo,
    required this.requestQty,
   // this.isSelected = false,
    this.returnQty = 0
  });

  @override
  Map<String, dynamic> toMap() {
    return {'partNo': partNo, 'requestQty': requestQty,'returnQty':returnQty};
  }

  ReturnItem copyWith({
    String? partNo,
    int? requestQty,
    int? returnQty,
  }) {
    return ReturnItem(
      partNo: partNo ?? this.partNo,
      requestQty: requestQty ?? this.requestQty,
      returnQty: returnQty ?? this.returnQty,
    );
  }
}
