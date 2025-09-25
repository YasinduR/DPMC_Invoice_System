import 'package:myapp/contracts/mappable.dart';

class Dealer implements Mappable {
  final String name;
  final String surname;
  final String accountCode;
  final String address;
  final String city;
  final String region;
  final String pin; // Added a pin field to store the dealer's PIN
  final bool hasBankGuarantee;
  bool isLocked; // Changed to mutable
  int incPins; // Changed to mutable

  Dealer({
    required this.name,
    required this.surname,
    required this.accountCode,
    required this.address,
    required this.city,
    this.pin ='123', // pin is now required
    this.region = '',
    this.hasBankGuarantee = false,
    this.isLocked = false,
    this.incPins = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountCode': accountCode,
      'surname': surname,
      'address': address,
      'city': city,
      'region': region,
    };
  }
}
