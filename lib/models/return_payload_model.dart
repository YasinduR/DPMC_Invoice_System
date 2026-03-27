import 'package:myapp/contracts/mappable.dart';

class ReturnPayload implements Mappable {
  final Map<String, dynamic> payload;
  ReturnPayload(this.payload);

  @override
  Map<String, dynamic> toMap() => payload;
}