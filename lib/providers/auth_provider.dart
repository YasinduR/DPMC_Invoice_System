import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final User? currentUser;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.currentUser,
  });

  const AuthState.initial()
    : isLoggedIn = false,
      isLoading = false,
      currentUser = null;

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    User? currentUser,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
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
    state = state.copyWith(isLoading: true);
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
        );
      } 
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

Future<void> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {

    state = state.copyWith(isLoading: true);

    try {
      await _authService.changePassword(
        context: context,
        username: state.currentUser!.username,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      await logout(context);

    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
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
