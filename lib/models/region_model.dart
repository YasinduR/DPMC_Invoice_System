import 'package:myapp/contracts/mappable.dart';

class Region implements Mappable {
  final String region;
  final String head;

  Region({
    required this.region,
    required this.head,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'head': head,
    };
  }
}