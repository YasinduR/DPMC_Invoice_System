import 'package:myapp/contracts/mappable.dart';

class Dealer implements Mappable {
  final String name;
  final String surname;
  final String accountCode;
  final String address;
  final String city;
  final String region;

  Dealer({
    required this.name,
    required this.surname,
    required this.accountCode,
    required this.address,
    required this.city,
    this.region =''
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountCode': accountCode,
      'surname': surname,
      'address': address,
      'city': city,
      'region': region
    };
  }
}
