import 'package:myapp/contracts/mappable.dart';

class Bank implements Mappable {
  final String bankCode;
  final String bankName;
  Bank({required this.bankCode, required this.bankName});

  @override
  Map<String, dynamic> toMap() {
    return {'bankCode': bankCode, 'bankName': bankName};
  }
}
