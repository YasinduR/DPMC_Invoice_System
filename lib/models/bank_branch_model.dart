import 'package:myapp/mappers/mappable.dart';

class BankBranch implements Mappable {
    final String bankCode;
    final String bankName;
    final String branchCode;
    final String branchName;

    BankBranch({
      required this.bankCode, 
      required this.bankName,
      required this.branchCode,
      required this.branchName
      });

    @override
    Map<String, dynamic> toMap() {
      return {'bankCode': bankCode, 'bankName': bankName,'branchCode': branchCode,'branchName': branchName};
    }

  factory BankBranch.fromJson(Map<String, dynamic> json) {
    return BankBranch(
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      branchCode: json['branchCode'] ?? '',
      branchName: json['branchDescription'] ?? '',
    );
  }

}