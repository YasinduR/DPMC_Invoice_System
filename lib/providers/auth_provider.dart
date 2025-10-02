import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final User? currentUser;
  final bool requiresPasswordChange;
  final String? passwordChangeType; // RESET OR SET

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.currentUser,
    this.requiresPasswordChange = false,
    this.passwordChangeType,
  });

  const AuthState.initial()
    : isLoggedIn = false,
      isLoading = false,
      currentUser = null,
      requiresPasswordChange = false,
      passwordChangeType = null;

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    User? currentUser,
    User? Function()? currentUserUpdate, // Added for nulling out currentUser
    bool? requiresPasswordChange,
    String? passwordChangeType,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      currentUser:
          currentUserUpdate != null
              ? currentUserUpdate()
              : currentUser ?? this.currentUser,
      requiresPasswordChange:
          requiresPasswordChange ?? this.requiresPasswordChange,
      passwordChangeType: passwordChangeType ?? this.passwordChangeType,
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
    Function(Exception e) onError,
  ) async {
    state = state.copyWith(isLoading: true, requiresPasswordChange: false);

    try {
      final user = await _authService.login(
        context: context,
        username: username,
        password: password,
        onError: onError,
      );

      if (user != null) {
        String? _changeType;
        if (user.isTemporaryPassword) {
          _changeType = 'SET';
        } else if (user.isPasswordExpired) {
          _changeType = 'RESET';
        }

        state = state.copyWith(
          isLoggedIn: true,
          currentUser: user,
          requiresPasswordChange:
              user.isTemporaryPassword || user.isPasswordExpired,
          passwordChangeType: _changeType,
        );
      } else {
        // If login failed (user is null), ensure logged out state
        state = state.copyWith(
          isLoggedIn: false,
          currentUserUpdate: () => null,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoggedIn: false, currentUserUpdate: () => null);
      onError(e is Exception ? e : Exception(e.toString())); // Exception types can be hndle from login screen
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // This method is for the *first-time* password change.
  // It ensures the user remains logged in after the change.
  Future<void> setPassword(
    BuildContext context, {
    required String newPassword,
    required SecurityQuestionAnswer securityQandA, 
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      if (state.currentUser == null) {
        throw Exception('No current user logged in to set initial password.');
      }
      final updatedUser = await _authService.setPassword(
        context: context,
        username: state.currentUser!.username,
        securityQandA: securityQandA, 
        newPassword: newPassword,
      );

      state = state.copyWith(
        currentUser: updatedUser,
        isLoggedIn: true,
        requiresPasswordChange: false, // Initial password setup is complete
      );
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
  // NEW: Method to handle renewing an expired password
Future<void> renewPassword(
  BuildContext context,
  String newPassword,
  Function(Exception e) onError,
) async {
  state = state.copyWith(isLoading: true);

  try {

    final username = state.currentUser?.username;
    if (username == null) {
      throw Exception("Cannot renew password: current user information missing.");
    }

    final updatedUser = await _authService.renewPassword(
      context: context,
      username: username,
      newPassword: newPassword,
    );

    // ignore: unnecessary_null_comparison
    if (updatedUser != null) {
      state = state.copyWith(
        isLoggedIn: true,
        currentUser: updatedUser,
        requiresPasswordChange: false,
        passwordChangeType: null, 
      );
    } else {
      state = state.copyWith(
        isLoggedIn: false,
        currentUserUpdate: () => null,
      );
    onError(Exception('Password renewal failed.'));
    }
  } catch (e) {
    state = state.copyWith(isLoggedIn: false, currentUserUpdate: () => null);
    onError(e is Exception ? e : Exception(e.toString()));
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
