import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';

// @immutable
// class AuthState {
//   final bool isLoggedIn;
//   final bool isLoading;
//   final User? currentUser;
//   final bool requiresPasswordChange; // NEW FIELD


//   const AuthState({
//     required this.isLoggedIn,
//     required this.isLoading,
//     this.currentUser,
//     this.requiresPasswordChange = false, // Default to false

//   });

//   const AuthState.initial()
//     : isLoggedIn = false,
//       isLoading = false,
//       currentUser = null,
//       requiresPasswordChange = false;


//   AuthState copyWith({
//     bool? isLoggedIn,
//     bool? isLoading,
//     User? currentUser,
//     bool? requiresPasswordChange,
//   }) {
//     return AuthState(
//       isLoggedIn: isLoggedIn ?? this.isLoggedIn,
//       isLoading: isLoading ?? this.isLoading,
//       currentUser: currentUser ?? this.currentUser,
//       requiresPasswordChange: requiresPasswordChange ?? this.requiresPasswordChange,

//     );
//   }
// }

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final User? currentUser;
  final bool requiresPasswordChange;


  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.currentUser,
    this.requiresPasswordChange = false,
  });

  const AuthState.initial()
    : isLoggedIn = false,
      isLoading = false,
      currentUser = null,
      requiresPasswordChange = false;


  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    User? currentUser,
    User? Function()? currentUserUpdate, // Added for nulling out currentUser
    bool? requiresPasswordChange,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUserUpdate != null ? currentUserUpdate() : currentUser ?? this.currentUser,
      requiresPasswordChange: requiresPasswordChange ?? this.requiresPasswordChange,
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
        state = state.copyWith(
          isLoggedIn: true ,
          currentUser: user,
          requiresPasswordChange: user.isTemporaryPassword,
        );
      } else {
        // If login failed (user is null), ensure logged out state
        state = state.copyWith(isLoggedIn: false, currentUserUpdate: () => null);
      }
    } catch (e) {
      // Catch any unhandled exceptions from _authService.login and ensure state is clean
      state = state.copyWith(isLoggedIn: false, currentUserUpdate: () => null);
      onError(e is Exception ? e : Exception(e.toString()));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // This method is for the *first-time* password change.
  // It ensures the user remains logged in after the change.
  Future<void> setPassword( // Kept name as per your prompt
    BuildContext context, {
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      if (state.currentUser == null) {
        throw Exception('No current user logged in to set initial password.');
      }
      final updatedUser = await _authService.setPassword( // Call the AuthService.setPassword
        context: context,
        username: state.currentUser!.username,
        //oldPassword: oldPassword,
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
  // Future<void> login(
  //   BuildContext context,
  //   String username,
  //   String password,
  //   Function(Exception e) onError, 
  // ) async {
  //       state = state.copyWith(isLoading: true, requiresPasswordChange: false); // Reset flag on new login attempt

  //   //state = state.copyWith(isLoading: true);
  //     final user = await _authService.login(
  //       context: context,
  //       username: username,
  //       password: password,
  //       onError: onError
  //     );

  //     if (user != null) {
  //       state = state.copyWith(
  //         isLoggedIn: true,
  //         currentUser: user,
  //         requiresPasswordChange: user.isTemporaryPassword, // Set flag based on user data
  //       );
  //     } 
  //     state = state.copyWith(isLoading: false);
    
  // }


}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
