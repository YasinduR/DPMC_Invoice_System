
import 'package:myapp/contracts/mappable.dart';

class CreditNote implements Mappable {
  final String crnNumber;
  final double amount;

  CreditNote({required this.crnNumber, required this.amount});
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'crnNumber':crnNumber,
      'amount': amount
      };
  }
}