// ID Name Employee Company.
import 'package:myapp/contracts/mappable.dart';

class Employee implements Mappable  {
  final String id;
  final String name;
  final String compName;

  Employee({
    required this.id,
    required this.name,
    required this.compName,
  });


  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'compName': compName,
      'id': id
    };
  }
  
  Employee copyWith({
    String? id,
    String? name,
    String? compName,
 
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      compName: compName ?? this.compName
    );
  }
}
