import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/tin_model.dart';

class MapperRegistry {
  static final Map<Type, Function> _map = {
    Dealer: (json) => Dealer.fromJson(json),
    TinData: (json) => TinData.fromJson(json),
    Region: (json) => Region.fromJson(json),
    Part: (json) => Part.fromJson(json),

  };

  static T fromMap<T>(Map<String, dynamic> json) {
    return _map[T]!(json) as T;
  }
}