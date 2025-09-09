// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/widgets/app_loading_overlay.dart'; // Import the new model

class AuthService {
  // Dummy Users
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
  // Future<User?> login(String username, String password) async {
  //   // Simulate a network delay.
  //   await Future.delayed(const Duration(seconds: 1));

  //   // In a real app, you would make an API call.
  //   // Here, we'll mock a successful login.
  //   // Find a user in the list that matches the credentials.
  //   try {
  //     final user = _users.firstWhere(
  //       (user) => user.username == username && user.password == password,
  //     );
  //     return user;
  //   } catch (e) {
  //     // firstWhere throws a StateError if no element is found.
  //     // We catch it and return null, indicating a failed login.
  //     return null;
  //   }
  // }

  Future<User?> login({
    required BuildContext context, // The widget's context to show the overlay.
    required String username, // The username to check.
    required String password, // The password to check.
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context); // Show loading indicator.
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay.

      // Find a user that matches the provided credentials.
      final user = _users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      loadingOverlay.hide(); // Hide before returning.
      return user;
    } catch (e) {
      // firstWhere throws an error if no user is found.
      loadingOverlay.hide(); // Hide on failure.
      return null; // Return null to indicate a failed login.
    }
  }

  /// Logs out the current user.
  Future<void> logout({required BuildContext context}) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context); // Show loading indicator.
      // Simulate notifying a server or clearing tokens.
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      // Always ensure the overlay is hidden.
      loadingOverlay.hide();
    }
  }


}



  // // The logout method is simpler now, as there's no stored data to clear.
  // Future<void> logout() async {
  //   // In a real app, you might notify a server. For now, it does nothing.
  //   await Future.delayed(const Duration(milliseconds: 200));
  // }
