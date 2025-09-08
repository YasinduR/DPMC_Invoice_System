import 'package:myapp/contracts/mappable.dart';

class TinInvoice implements Mappable {
  final String tinNo;
  final String mobileInvNo;
  final double invAmount;
  final String paymentOnDeliveryStatus;
  final bool receiptStatus;
  final String dealerAccCode;

  const TinInvoice({
    required this.tinNo,
    required this.mobileInvNo,
    required this.invAmount,
    required this.paymentOnDeliveryStatus,
    this.receiptStatus = false,
    required this.dealerAccCode,
  });

  /// Converts the TinInvoice instance into a map.
  /// This can be useful for serialization or dynamic data handling.
  @override
  Map<String, dynamic> toMap() {
    return {
      'tinNo': tinNo,
      'mobileInvNo': mobileInvNo,
      'invAmount': invAmount,
      'paymentOnDeliveryStatus': paymentOnDeliveryStatus,
      'receiptStatus': receiptStatus,
      'dealerAccCode': dealerAccCode,
    };
  }
}