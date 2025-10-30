import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/credit_note_model.dart';

class Receipt implements Mappable {
  final String recieptNo;
  final DateTime recieptTime;
  final String userId;
  final String dealerCode;
  final String dealerName;
  final String chequeNumber;
  final double chequeAmount;
  final DateTime chequeDate;
  final String bankCode;
  final String branchCode;
  final String branchName;
  final List<TinInvoice> tins;
  final List<CreditNote> creditNotes;

  Receipt({
    required this.recieptNo,
    required this.recieptTime,
    required this.userId,
    required this.dealerName,
    required this.dealerCode,
    required this.chequeNumber,
    required this.chequeAmount,
    required this.chequeDate,
    required this.bankCode,
    required this.branchCode,
    required this.branchName,
    required this.tins,
    required this.creditNotes,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'recieptNo':recieptNo,
      'recieptTime': recieptTime.toIso8601String(), // Standard format for APIs
      'dealerCode': dealerCode,
      'userId': userId,
      'dealerName': dealerName,
      'dealer': dealerCode,
      'chequeNumber': chequeNumber,
      'chequeAmount': chequeAmount,
      'chequeDate': chequeDate.toIso8601String(), // Standard format for APIs
      'bankCode': bankCode,
      'branchCode': branchCode,
      'branchName': branchName,
      'tins': tins.map((tin) => tin.toMap()).toList(),
      'creditNotes': creditNotes.map((note) => note.toMap()).toList(),
    };
  }
    Receipt copyWith({
    String? recieptNo,
    DateTime? recieptTime,
    String? userId,
    String? dealerCode,
    String? dealerName,
    String? chequeNumber,
    double? chequeAmount,
    DateTime? chequeDate,
    String? bankCode,
    String? branchCode,
    String? branchName,
    List<TinInvoice>? tins,
    List<CreditNote>? creditNotes,
  }) {
    return Receipt(
      recieptNo: recieptNo ?? this.recieptNo,
      recieptTime: recieptTime ?? this.recieptTime,
      userId: userId ?? this.userId,
      dealerCode: dealerCode ?? this.dealerCode,
      dealerName: dealerName ?? this.dealerName,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      chequeAmount: chequeAmount ?? this.chequeAmount,
      chequeDate: chequeDate ?? this.chequeDate,
      bankCode: bankCode ?? this.bankCode,
      branchCode: branchCode ?? this.branchCode,
      branchName: branchName ?? this.branchName,
      tins: tins ?? this.tins,
      creditNotes: creditNotes ?? this.creditNotes,
    );
  }
}
