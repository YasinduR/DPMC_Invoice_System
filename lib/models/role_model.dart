import 'package:myapp/mappers/mappable.dart';

class Role implements Mappable {
  final String roleId;
  final String roleName;
  Role({required this.roleId, required this.roleName});

  @override
  Map<String, dynamic> toMap() {
    return {'roleId': roleId, 'roleName': roleName};
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'] ?? '',
      roleName: json['roleName'] ?? '',
    );
  }
  
}




