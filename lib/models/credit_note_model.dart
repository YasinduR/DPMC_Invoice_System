
import 'package:myapp/contracts/mappable.dart';
import 'package:equatable/equatable.dart';
class CreditNote extends Equatable implements Mappable {
  final String crnNumber;
  final double amount;

  CreditNote({required this.crnNumber, required this.amount});
    @override
  // This tells Equatable that two CreditNote objects are the same if
  // their crnNumber AND amount are the same.
  @override
  List<Object?> get props => [crnNumber, amount];

  @override
  Map<String, dynamic> toMap() {
    return {
      'crnNumber':crnNumber,
      'amount': amount
      };
  }
}