import 'package:myapp/contracts/mappable.dart';

class Reference implements Mappable {
  final String refId;
  final String remark;

  const Reference({required this.refId, required this.remark});

  /// Converts the Reference instance into a map.
  /// This is required for the AppSelectionField to dynamically access its data.
  @override
  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'remark': remark,
    };
  }
}