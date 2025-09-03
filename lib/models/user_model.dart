// lib/models/user_model.dart

// A simple model class to represent the authenticated user.
class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email, 
    required this.password,
  });
}