import 'package:myapp/models/screen_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final List<String> roles;
  final List<Screen> accessibleScreen;
  final List<String> rolenames;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.roles,
    this.accessibleScreen = const [],
    this.rolenames = const[]
  });

   User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    List<String>? roles,
    List<Screen>? accessibleScreen,
    List<String>? rolenames,

  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      roles: roles ?? this.roles,
      accessibleScreen: accessibleScreen ?? this.accessibleScreen,
      rolenames: rolenames ?? this.rolenames, 
    );
  }
}
