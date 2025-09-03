// // lib/providers/auth_provider.dart
// // Auth provider for provider dep:
// import 'package:flutter/material.dart';
// import 'package:myapp/models/user_model.dart'; // Import the User model
// import 'package:myapp/services/auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   final AuthService _authService = AuthService();

//   bool _isLoggedIn = false;
//   bool _isLoading = false;
//   String? _errorMessage;
//   User? _currentUser; // Holds the information of the logged-in user.

//   // Public getters for the UI to access the state.
//   bool get isLoggedIn => _isLoggedIn;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   User? get currentUser => _currentUser; // Getter for the user object.

//   // The session check is no longer needed for this approach.

//   Future<void> login(String username, String password) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final user = await _authService.login(username, password);

//       if (user != null) {
//         _isLoggedIn = true;
//         _currentUser = user; // Store the user object in the provider's state.
//       } else {
//         _errorMessage = 'Invalid username or password.';
//         _isLoggedIn = false;
//         _currentUser = null;
//       }
//     } catch (e) {
//       _errorMessage = 'An unexpected error occurred.';
//       _isLoggedIn = false;
//       _currentUser = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> logout() async {
//     await _authService.logout();
//     _isLoggedIn = false;
//     _currentUser = null; // Clear the user data on logout.
//     notifyListeners();
//   }

  
// }