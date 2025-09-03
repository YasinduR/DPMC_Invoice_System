import 'package:myapp/contracts/mappable.dart';

class ReturnItem implements Mappable {
  final String partNo;
  final int requestQty;
  bool isSelected;
  ReturnItem({
    required this.partNo,
    required this.requestQty,
    this.isSelected = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'partNo': partNo, 'requestQty': requestQty};
  }
}
