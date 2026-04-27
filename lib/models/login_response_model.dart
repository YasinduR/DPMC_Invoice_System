import 'package:myapp/models/user_model.dart';

  class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      expiresAt: DateTime.parse(map['expiresAt'] ?? DateTime.now().toIso8601String()),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }
}