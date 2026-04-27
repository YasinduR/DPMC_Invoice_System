import 'package:myapp/mappers/mappable.dart';

class DealerStat extends Mappable {
  // Dealer Statistics to show on supervisor summary Page
  final String dealerName;
  final String accountCode;
  final int approvedTinCount;
  final int proceedTinCount;
  final int partiallyProceedTinCount;

  DealerStat({
    required this.dealerName,
    required this.accountCode,
    this.approvedTinCount = 0,
    this.proceedTinCount = 0,
    this.partiallyProceedTinCount = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'dealerName': dealerName,
      'accountCode': accountCode,
      'approvedTinCount': approvedTinCount,
      'proceedTinCount': proceedTinCount,
      'partiallyProceedTinCount': partiallyProceedTinCount,
    };
  }
}
