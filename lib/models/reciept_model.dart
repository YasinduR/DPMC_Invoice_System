import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/credit_note_model.dart';


class Receipt implements Mappable {
  final String dealerCode;
  final String chequeNumber;
  final double chequeAmount;
  final DateTime chequeDate;
  final String bankCode;
  final String branchCode;
  final List<String> tinNumbers;
  final List<CreditNote> creditNotes;

  Receipt({
    required this.dealerCode,
    required this.chequeNumber,
    required this.chequeAmount,
    required this.chequeDate,
    required this.bankCode,
    required this.branchCode,
    required this.tinNumbers,
    required this.creditNotes,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'dealer': dealerCode,
      'chequeNumber': chequeNumber,
      'chequeAmount': chequeAmount,
      'chequeDate': chequeDate.toIso8601String(), // Standard format for APIs
      'bank': bankCode,
      'branch': branchCode,
      'tinData': tinNumbers,
      'creditNotes': creditNotes.map((note) => note.toMap()).toList()
    };
  }
}