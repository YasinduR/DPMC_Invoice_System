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
// FromMap constructor for deserialization
  @override
  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        username = map['username'] as String,
        email = map['email'] as String,
        password = map['password'] as String,
        telephone = map['telephone'] as String,
        roles = List<String>.from(map['roles'] as List),
        accessibleScreen = (map['accessibleScreen'] as List<dynamic>?)
                ?.map((e) => Screen.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        rolenames = List<String>.from(map['rolenames'] as List? ?? []),
        isLocked = map['isLocked'] as bool? ?? false,
        incPins = map['incPins'] as int? ?? 0,
        passwordUpdatedAt = map['passwordUpdatedAt'] != null
            ? DateTime.parse(map['passwordUpdatedAt'] as String)
            : null,
        isTemporaryPassword = map['isTemporaryPassword'] as bool? ?? false,
        isPasswordExpired = map['isPasswordExpired'] as bool? ?? false;

  // toMap method for serialization
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'telephone': telephone,
      'roles': roles,
      'accessibleScreen': accessibleScreen.map((s) => s.toMap()).toList(),
      'rolenames': rolenames,
      'isLocked': isLocked,
      'incPins': incPins,
      'passwordUpdatedAt': passwordUpdatedAt?.toIso8601String(),
      'isTemporaryPassword': isTemporaryPassword,
      'isPasswordExpired': isPasswordExpired,
    };
  }

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
