import 'package:myapp/mappers/mappable.dart';

class Dealer implements Mappable {
  final String name;
  final String surname;
  final String accountCode;
  final String address;
  final String city;
  final String region;
  final String pin; // Added a pin field to store the dealer's PIN
  final bool hasBankGuarantee;
  final double usableAmount;
  final String vatNo;
  bool isLocked; // Changed to mutable remove later
  int incPins; // Changed to mutable  remove later

  Dealer({
    required this.name,
    required this.surname,
    required this.accountCode,
    required this.address,
    required this.city,
    this.vatNo = 'N/A',
    this.pin = '123', // pin is now required
    this.region = '',
    this.hasBankGuarantee = false,
    this.usableAmount =0,
    this.isLocked = false,
    this.incPins = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountCode': accountCode,
      'surname': surname,
      'vatNo': vatNo,
      'address': address,
      'city': city,
      'region': region,
      'usableAmount': usableAmount,
    };
  }

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      accountCode: json['customerCode'] ?? '',
      name: json['customerName'] ?? '',
      surname: json['customerDescription'] ?? '',
      address: json['address1'] ?? '',
      city: json['address2'] ?? '',
      region: '', // not available in API
      vatNo:(json['vatRegNo'] == null || json['vatRegNo'] == '') ? 'N/A' : json['vatRegNo'],
      hasBankGuarantee: false,
     // isLocked: json['status'] != 'A',
      usableAmount: (json['usableAmount'] == null) ? 0.0 : double.tryParse(json['usableAmount'].toString()) ?? 0.0,
      pin: '123',
      incPins: 0,
    );
  }
}
