import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';

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

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

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

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    if (state.currentUser == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _authService.changePassword(
        context: context,
        username: state.currentUser!.username,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (success) {
        await logout(context);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to change password. Please check your old password.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred.',
      );
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout(context: context);
    state = const AuthState.initial();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
