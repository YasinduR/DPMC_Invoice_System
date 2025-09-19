import 'package:myapp/contracts/mappable.dart'; // Make sure this path is correct for your project

class TinData implements Mappable {
  final String tinNumber;
  final double totalValue;

  const TinData({required this.tinNumber, required this.totalValue});

  @override
  Map<String, dynamic> toMap() {
    return {
      'tinNumber': tinNumber,
      'totalValue': totalValue,
    };
  }
}