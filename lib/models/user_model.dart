import 'package:myapp/models/screen_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String telephone;
  final List<String> roles;
  final List<Screen> accessibleScreen;
  final List<String> rolenames;

  // Fields for password management
  bool isLocked;
  int incPins; // Changed to mutable
  
  final DateTime? passwordUpdatedAt;
  final bool isTemporaryPassword;
  final bool isPasswordExpired;



  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.telephone,
    required this.roles,
    this.accessibleScreen = const [],
    this.rolenames = const [],
    this.isLocked = false, // Default to not locked
    this.passwordUpdatedAt, // Nullable, set when password is updated
    this.isTemporaryPassword = false, // Default to not a temporary password
    this.isPasswordExpired = false, // Default to not expired
    this.incPins=0
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? telephone,
    String? password,
    List<String>? roles,
    List<Screen>? accessibleScreen,
    List<String>? rolenames,
    bool? isLocked,
    DateTime? passwordUpdatedAt,
    bool? isTemporaryPassword,
    bool? isPasswordExpired,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      telephone: telephone??this.telephone,
      roles: roles ?? this.roles,
      accessibleScreen: accessibleScreen ?? this.accessibleScreen,
      rolenames: rolenames ?? this.rolenames,
      isLocked: isLocked ?? this.isLocked,
      passwordUpdatedAt: passwordUpdatedAt ?? this.passwordUpdatedAt,
      isTemporaryPassword: isTemporaryPassword ?? this.isTemporaryPassword,
      isPasswordExpired: isPasswordExpired ?? this.isPasswordExpired,
    );
  }
}
