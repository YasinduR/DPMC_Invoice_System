// lib/services/auth_service.dart
import 'package:myapp/models/user_model.dart'; // Import the new model

class AuthService {

  static final List<User> _users = [
    User(
      id: '2619',
      username: 'yasindu',
      email: 'yasindu@example.com',
      password: '12345',
    ),
    User(
      id: '8108',
      username: 'nimesh',
      email: 'test@example.com',
      password: '12345',
    ),
    User(
      id: '1111',
      username: 'admin',
      email: 'admin@example.com',
      password: 'admin123',
    ),
  ];
  // The login method now returns a Future<User?>.
  Future<User?> login(String username, String password) async {
    // Simulate a network delay.
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an API call.
    // Here, we'll mock a successful login.
    // Find a user in the list that matches the credentials.
    try {
      final user = _users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      return user;
    } catch (e) {
      // firstWhere throws a StateError if no element is found.
      // We catch it and return null, indicating a failed login.
      return null;
    }
  }

  // The logout method is simpler now, as there's no stored data to clear.
  Future<void> logout() async {
    // In a real app, you might notify a server. For now, it does nothing.
    await Future.delayed(const Duration(milliseconds: 200));
  }
}