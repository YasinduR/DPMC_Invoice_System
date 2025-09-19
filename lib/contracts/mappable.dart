/// A contract for classes that can be converted into a Map.
/// Used to Call object properties with property name string
abstract class Mappable {
  /// Converts the object into a key-value map.
  Map<String, dynamic> toMap();
}