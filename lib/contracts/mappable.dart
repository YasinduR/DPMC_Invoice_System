/// A contract for classes that can be converted into a Map.
/// This is used by generic widgets like SelectionSheet to access
/// object properties dynamically without reflection.
abstract class Mappable {
  /// Converts the object into a key-value map.
  Map<String, dynamic> toMap();
}