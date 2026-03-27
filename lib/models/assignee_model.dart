import 'package:myapp/contracts/mappable.dart';

class Assignee extends Mappable {
  final String supervisorId;
  final String assigneeId;
  final String name;
  late final List<String> dealerListAssigned;   // renamed

  Assignee({
    required this.supervisorId,
    required this.assigneeId,
    required this.name,
    required this.dealerListAssigned,
  });

  factory Assignee.fromMap(Map<String, dynamic> map) {
    return Assignee(
      supervisorId: map['supervisorId'] as String,
      assigneeId: map['assigneeId'] as String,
      name: map['name'] as String,
      dealerListAssigned: (map['dealerListAssigned'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'supervisorId': supervisorId,
      'assigneeId': assigneeId,
      'name': name,
      'dealerListAssigned': dealerListAssigned,
    };
  }

  Assignee copyWith({
    String? supervisorId,
    String? assigneeId,
    String? name,
    List<String>? dealerListAssigned,
  }) {
    return Assignee(
      supervisorId: supervisorId ?? this.supervisorId,
      assigneeId: assigneeId ?? this.assigneeId,
      name: name ?? this.name,
      dealerListAssigned: dealerListAssigned ?? this.dealerListAssigned,
    );
  }
}