import 'package:myapp/contracts/mappable.dart'; // Make sure this path is correct for your project

class TinData implements Mappable {
    final String tinNumber;
    final String orderNumber;
    final String payOnDel;
    final String paymentStatus;  // P - Payment Pending, C - Payment Completed A- Payment Approved
    final double totalValue;
    final String dealercode;

    const TinData({
      required this.tinNumber,
      required this.orderNumber,
      required this.totalValue,
      required this.paymentStatus,
      required this.dealercode,
      this.payOnDel = 'N',
      });

    String get _paymentStatusText {
      switch (paymentStatus) {
        case 'P':
          return 'Pending';
        case 'C':
          return 'Completed';
        case 'A':
          return 'Approved';
      default:
        return paymentStatus;
  }
}

      @override
    Map<String, dynamic> toMap() {
      return {
        'tinNumber': tinNumber,
        'orderNumber': orderNumber,
        'payOnDel': payOnDel,
        'paymentStatus': _paymentStatusText,
        'totalValue': totalValue,
        'dealerCode': dealercode
        };
      }
    }
