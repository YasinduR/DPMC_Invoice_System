import 'package:myapp/mappers/mappable.dart';

class Bank implements Mappable {
  final String bankCode;
  final String bankName;
  Bank({required this.bankCode, required this.bankName});

  @override
  Map<String, dynamic> toMap() {
    return {'bankCode': bankCode, 'bankName': bankName};
  }

//  Convert Json response to Bank
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      bankCode: json['bankCode'] as String,
      bankName: json['bankDescription'] as String,
    );
  }

}
