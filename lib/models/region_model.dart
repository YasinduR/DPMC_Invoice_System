import 'package:myapp/mappers/mappable.dart';

class Region implements Mappable {
  final String region;
  final String head;
  final String regionCode;

  Region({required this.region, required this.head, required this.regionCode});

  @override
  Map<String, dynamic> toMap() {
    return {'region': region, 'head': head,'regionCode':regionCode };
  }

  factory Region.fromJson(Map<String, dynamic> json) {
  return Region(
    region: json['routeDescription'] ?? '',
    head: '', // not available
    regionCode: json['routeCode'] ?? '',
  );
}
}
