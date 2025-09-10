import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';

// --- Part 1: Define the immutable state class ---
@immutable
class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? errorMessage;
  final User? currentUser;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.errorMessage,
    this.currentUser,
  });

  // Create an initial state
  const AuthState.initial()
    : isLoggedIn = false,
      isLoading = false,
      errorMessage = null,
      currentUser = null;

  // Helper method to create a copy of the state with new values
  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? errorMessage,
    User? currentUser,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

// --- Part 2: Create the StateNotifier ---
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  // Initialize with the initial state
  AuthNotifier(this._authService) : super(const AuthState.initial());

  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _authService.login(
        context: context,
        username: username,
        password: password,
      );

      if (user != null) {
        state = state.copyWith(
          isLoggedIn: true,
          currentUser: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          errorMessage: 'Invalid username or password.',
          isLoggedIn: false,
          currentUser: null,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'An unexpected error occurred.',
        isLoggedIn: false,
        currentUser: null,
        isLoading: false,
      );
    }
  }

  // --- NEW METHOD ---
  /// Attempts to change the password for the currently logged-in user.
  /// On success, it will log the user out.
  Future<bool> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    // 1. Guard clause: Ensure a user is logged in before attempting.
    if (state.currentUser == null) {
      // This should ideally not happen if your UI is built correctly, but it's safe to have.
      return false;
    }

    // 2. Set loading state and clear previous errors.
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 3. Call the service layer.
      final success = await _authService.changePassword(
        context: context,
        username:
            state.currentUser!.username, // Use username from the current state
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (success) {
        // 4. IMPORTANT: On success, call the existing logout method.
        // This will reset the state to AuthState.initial(), forcing a re-login.
        await logout(context);
        return true;
        // Optional: You could introduce a success message in your state
        // if you want to show a snackbar like "Password changed! Please log in again."
        // For now, simply logging out is the clearest action.
      } else {
        // 5. On failure, update the error message.
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to change password. Please check your old password.',
        );
        return false;

      }
    } catch (e) {
      // 6. Handle any unexpected exceptions from the service.
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred.',
      );
              return false;

    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout(context: context);
    // Reset to the initial state on logout
    state = const AuthState.initial();
  }
}

// --- Part 3: Create the Providers ---

// A simple provider for our AuthService dependency
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// The StateNotifierProvider for our AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // We read the authService provider to pass it as a dependency
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
