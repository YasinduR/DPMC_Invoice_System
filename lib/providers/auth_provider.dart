import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/local_auth_service.dart';
import 'package:myapp/services/local_storage_service.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final User? currentUser;
  final bool requiresPasswordChange;
  final String? passwordChangeType;
  final String?
  lastLoginPassword; // NEW: To store the last successfully used password

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.currentUser,
    this.requiresPasswordChange = false,
    this.passwordChangeType,
    this.lastLoginPassword, // NEW
  });

  const AuthState.initial()
    : isLoggedIn = false,
      isLoading = false,
      currentUser = null,
      requiresPasswordChange = false,
      passwordChangeType = null,
      lastLoginPassword = null; // NEW

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    User? currentUser,
    User? Function()? currentUserUpdate, // Added for nulling out currentUser
    bool? requiresPasswordChange,
    String? passwordChangeType,
    String? lastLoginPassword,
    String? Function()? lastLoginPasswordUpdate,
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
      lastLoginPassword:
          lastLoginPasswordUpdate != null
              ? lastLoginPasswordUpdate()
              : lastLoginPassword ?? this.lastLoginPassword, // NEW
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final LocalAuthService _localAuthService;
  final LocalStorageService _localStorageService;

  AuthNotifier(
    this._authService,
    this._localAuthService,
    this._localStorageService,
  ) : super(AuthState.initial());

  //  Perform biometric login
  Future<bool> loginWithBiometrics(
    BuildContext context,
    Function(Exception e) onError,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final isBiometricEnabled =
          await _localStorageService.getBiometricPreference(context);
      final savedUsername =
          await _localStorageService.getSavedUsernameForBiometric();

      if (!isBiometricEnabled || savedUsername == null) {
        throw Exception('Biometric login not enabled or username not saved.');
      }

      final bool authenticated = await _localAuthService.authenticateBiometrics(
        'Authenticate to log in with your saved account',
      );

      if (authenticated) {
        final savedPassword =
            await _localStorageService.getSavedPasswordForBiometric();

        final User? user = await _authService.login(
          context: context,
          username: savedUsername,
          mode: 'BioMetric',
          password: savedPassword ?? '', // This is a placeholder.//Saved token
          onError: onError, // Pass a dummy onError if not handled by real login
        );

        if (user != null) {
          state = state.copyWith(
            isLoggedIn: true,
            currentUser: user,
            requiresPasswordChange:
                user.isTemporaryPassword || user.isPasswordExpired,
            passwordChangeType:
                user.isTemporaryPassword
                    ? 'SET'
                    : (user.isPasswordExpired ? 'RESET' : null),
            lastLoginPassword: savedPassword,
          );

          return true;
        } else {
          state = state.copyWith(
            isLoggedIn: false,
            currentUserUpdate: () => null,
            lastLoginPasswordUpdate: () => null,
          );
          onError(
            UnauthorisedException(
              'Failed to log in after biometric authentication.',
            ),
          );
          return false;
        }
      } else {
        onError(
          UnauthorisedException(
            'Biometric authentication failed or cancelled.',
          ),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false, // Ensure logged out if biometric login fails
        currentUserUpdate: () => null,
        lastLoginPasswordUpdate: () => null, // NEW: Clear password on failure
      );
      onError(e is Exception ? e : Exception(e.toString()));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //  Confirm biometric login
  Future<bool> confirmBiometrics( // Check Bio METRIC IS VALID BEFORE ENABLING IT
    BuildContext context,
    Function(Exception e) onError,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final bool authenticated = await _localAuthService.authenticateBiometrics(
        'Verify your identity to enable biometric login',
      );
      if(!authenticated){
                  onError(
            UnauthorisedException(
              'Failed to Enable biometric login.',
            ),
          );
      }
      return authenticated;
    } catch (e) {
      state = state.copyWith(
        isLoading: false
      );
      onError(e is Exception ? e : Exception(e.toString()));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

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
          lastLoginPassword: password, // NEW: Save the password here
        );
      } else {
        state = state.copyWith(
          isLoggedIn: false,
          currentUserUpdate: () => null,
          lastLoginPasswordUpdate: () => null, // NEW: Clear password on failure
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoggedIn: false,
        currentUserUpdate: () => null,
        lastLoginPasswordUpdate: () => null,
      );
      onError(
        e is Exception ? e : Exception(e.toString()),
      ); // Exception types can be hndle from login screen
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveUserInfo(
    BuildContext context,
    //String password, // Password parameter
    Function(Exception e) onError,
  ) async {
    state = state.copyWith(isLoading: true); // Start loading

    try {
      if (state.currentUser == null) {
        throw Exception('No current user logged in to save information for.');
      }
      await _localStorageService.saveUsernameForBiometric(
        state.currentUser!.username,
        state.lastLoginPassword!, // Use password from AuthState
      );
    } catch (e) {
      print('Error saving user info: $e');
      onError(e is Exception ? e : Exception(e.toString()));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // NEW: Method to set biometric preference in local storage and save user info
  Future<void> setBiometricPreference(
    bool enable,
    Function(Exception e) onError,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      if (enable) {
        if (state.currentUser == null ||
            state.lastLoginPassword == null ||
            state.lastLoginPassword!.isEmpty) {
          throw Exception(
            'User not logged in or password not available to enable biometrics.',
          );
        }
        await _localStorageService.saveUsernameForBiometric(
          state.currentUser!.username,
          state.lastLoginPassword!,
        );
        await _localStorageService.setBiometricPreference(true);
      } else {
        await _localStorageService
            .clearSavedLoginInfo(); // Clear all biometric-related info
        await _localStorageService.setBiometricPreference(false);
      }
      // No need to update AuthState directly here unless you have a dedicated 'isBiometricEnabled' field in AuthState
      // which would reflect the *preference* not just the local storage status.
    } catch (e) {
      print('Error setting biometric preference: $e');
      onError(e is Exception ? e : Exception(e.toString()));
      await _localStorageService.setBiometricPreference(!enable); // Revert
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String> getCurrentSavedUsername() async {
    state = state.copyWith(isLoading: true); // Start loading
    String? username;
    try {
      username = await _localStorageService.getSavedUsernameForBiometric();
    } catch (e) {
      print('Error getting saved username from local storage: $e');
      username = null;
    } finally {
      state = state.copyWith(isLoading: false); // End loading
    }
    return username ?? '';
  }

  Future<bool> isBioMetEnabled(    BuildContext context,
) async {
    state = state.copyWith(isLoading: true);

    bool? loginMethod;
    try {
      loginMethod = await _localStorageService.getBiometricPreference(context);
    } catch (e) {
      loginMethod = false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return loginMethod;
  }

  Future<void> clearUserInfo() async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorageService.clearSavedLoginInfo();
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

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
        lastLoginPassword:
            newPassword, // NEW: Update password if it's being set/changed
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
        throw Exception(
          "Cannot renew password: current user information missing.",
        );
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
          lastLoginPassword:
              newPassword, // NEW: Update password if it's being set/changed
        );
      } else {
        state = state.copyWith(
          isLoggedIn: false,
          currentUserUpdate: () => null,
          lastLoginPasswordUpdate: () => null, // NEW: Clear password on failure
        );
        onError(Exception('Password renewal failed.'));
      }
    } catch (e) {
      state = state.copyWith(
        isLoggedIn: false,
        currentUserUpdate: () => null,
        lastLoginPasswordUpdate: () => null, // NEW: Clear password on failure
      );
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

// NEW: Provider for LocalAuthService
final localAuthServiceProvider = Provider<LocalAuthService>((ref) {
  return LocalAuthService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final localAuthService = ref.read(
    localAuthServiceProvider,
  ); // Read the new service
  final localStorageService = ref.read(localStorageServiceProvider);
  return AuthNotifier(
    authService,
    localAuthService,
    localStorageService,
  ); // Pass both services
});



  // // NEW: Toggle biometric authentication preference
  // Future<void> toggleBiometricLogin(bool enable) async {
  //   state = state.copyWith(isLoading: true);
  //   try {
  //     if (enable) {
  //       // Check if device supports biometrics before enabling
  //       final bool canCheck = await _authService.canCheckBiometrics();
  //       if (!canCheck) {
  //         throw Exception('Biometric authentication is not available on this device.');
  //       }
  //       // Optionally, prompt for biometric auth once to confirm setup
  //       final bool authenticated = await _authService.authenticateBiometrics(
  //         'Confirm your identity to enable biometric login',
  //       );
  //       if (!authenticated) {
  //         throw Exception('Biometric authentication failed or was cancelled.');
  //       }
  //       await _authService.saveBiometricPreference(true);
  //       // If enabling, and a user is logged in, save their username
  //       if (state.currentUser != null) {
  //         await _authService.saveUsernameForBiometric(state.currentUser!.username);
  //         state = state.copyWith(savedUsername: state.currentUser!.username);
  //       }
  //       state = state.copyWith(isBiometricEnabled: true);
  //     } else {
  //       await _authService.saveBiometricPreference(false);
  //       await _authService.clearSavedLoginInfo(); // Also clear saved username
  //       state = state.copyWith(
  //         isBiometricEnabled: false,
  //         savedUsernameUpdate: () => null,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error toggling biometric login: $e');
  //     // Optionally, revert the UI state or show an error message
  //   } finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }
