import 'package:myapp/contracts/mappable.dart';

class Role implements Mappable {
  final String roleId;
  final String roleName;
  Role({required this.roleId, required this.roleName});

  @override
  Map<String, dynamic> toMap() {
    return {'roleId': roleId, 'roleName': roleName};
  }
}




