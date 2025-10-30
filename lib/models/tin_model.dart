import 'package:myapp/contracts/mappable.dart'; // Make sure this path is correct for your project

class TinData implements Mappable {
  final String tinNumber;
  final String orderNumber;
  final String payOnDel;
  final double totalValue;

  const TinData({
    required this.tinNumber,
    required this.orderNumber,
    required this.totalValue,
    this.payOnDel='N'
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'tinNumber': tinNumber,
      'orderNumber': orderNumber,
      'payOnDel': payOnDel,
      'totalValue': totalValue,
    };
  }
}
