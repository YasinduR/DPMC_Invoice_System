import 'package:flutter/material.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/models/user_model.dart';
//import 'package:myapp/services/attendance_reminder_service.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/services/secure_storage_services.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

class AuthService {
  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Instantiate SecureStorageService
  String baseUrl = Config.baseUrl;
  String userPath = 'user/';

  String get loginUrl => '${baseUrl}user/login';
  String get changePasswordUrl => '${baseUrl}user/changepassword';
  String get requestPasswordResetUrl => '${baseUrl}user/request-password-reset';
  String get resetPasswordUrl => '${baseUrl}user/reset-password';
  String get setPasswordUrl => '${baseUrl}user/set-password';
  String get renewPasswordUrl => '${baseUrl}user/renew-password';
  String get verifyOtpUrl => '${baseUrl}user/verify-otp';


  Future<void> logout({required BuildContext context}) async {
    final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      await Future.delayed(const Duration(milliseconds: 500));
      await _secureStorageService.clearTokens();
    } catch (e) {
      return null;
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  Future<User?> login({
    required BuildContext context,
    required String username,
    required String password,
    String mode = '',
    required Function(Exception e) onError,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      // final user =
      //     await MockApiService.post(
      //           'api/user/login',
      //           body: {
      //             'username': username,
      //             'password': password,
      //             'mode': mode,
      //           },
      //         )
      //         as User;
      // Assume MockApiService.post returns a Map containing user data and tokens
      final Map<String, dynamic> apiResponse =
          await MockApiService.post(
                loginUrl,
                body: {
                  'username': username,
                  'password': password,
                  'mode': mode,
                },
              )
              as Map<String, dynamic>;

      final user = User.fromMap(apiResponse['user'] as Map<String, dynamic>);
      final accessToken = apiResponse['accessToken'] as String;
      final refreshToken = apiResponse['refreshToken'] as String;
      // final accessTokenExpiryString = apiResponse['accessTokenExpiry'] as String;
      // final accessTokenExpiry = DateTime.parse(accessTokenExpiryString);

      // --- START: Print tokens for testing ---
      //print('--- Login Successful ---');
      //print('Access Token: $accessToken');
      //print('Refresh Token: $refreshToken');
      // print('Access Token Expiry (String): $accessTokenExpiryString');
      // print('Access Token Expiry (DateTime): $accessTokenExpiry');
      //print('------------------------');
      // --- END: Print tokens for testing ---

      // Save tokens securely
      await _secureStorageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        // accessTokenExpiry: accessTokenExpiry,
      );

      // await AttendanceReminderManager.setupDailyAttendanceNotifications(); // If applicable
      return user;
      // await AttendanceReminderManager.setupDailyAttendanceNotifications();
      // return user;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      if (e is Exception) {
        onError(e);
      } else {
        onError(Exception(e.toString()));
      }
      return null;
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  Future<void> changePassword({
    required BuildContext context,
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      await MockApiService.post(
        changePasswordUrl,
        body: {
          'username': username,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } on UnauthorisedException {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      rethrow;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      throw FetchDataException(
        "Could not connect to the server. Please try again.",
      );
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // forget password --> req pwd change
  Future<String?> requestPasswordReset({
    required BuildContext context,
    required String username,
    //required String email,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      return await MockApiService.post(
            requestPasswordResetUrl,
            body: {
              'username': username,
              //'email': email
            },
          )
          as String?;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      rethrow;
      // return null;
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // forget password --> reset
  Future<bool> resetPassword({
    required BuildContext context,
    required String username,
    required String token,
    required String newPassword,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      return await MockApiService.post(
            resetPasswordUrl,
            body: {
              'username': username,
              'token': token,
              'newPassword': newPassword,
            },
          )
          as bool;
    } catch (e) {
      return false;
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // This is the setPassword for first-time login
  Future<User> setPassword({
    required BuildContext context,
    required String username,
    required String newPassword,
    required SecurityQuestionAnswer securityQandA,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final updatedUser =
          await MockApiService.post(
                setPasswordUrl,
                body: {
                  'username': username,
                  'newPassword': newPassword,
                  'securityQuestion': securityQandA.question,
                  'securityAnswer': securityQandA.answer,
                },
              )
              as User;
      return updatedUser;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      if (e is Exception) {
        throw e;
      } else {
        throw Exception('An unknown error occurred during password change: $e');
      }
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // This is the setPassword for first-time login
  Future<User> renewPassword({
    required BuildContext context,
    required String username,
    required String newPassword,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final updatedUser =
          await MockApiService.post(
                renewPasswordUrl,
                body: {'username': username, 'newPassword': newPassword},
              )
              as User;
      return updatedUser;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      if (e is Exception) {
        throw e;
      } else {
        throw Exception('An unknown error occurred during password change: $e');
      }
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  // Added by Darshan R on 12/03/2026
  Future<String> verifyOtp({
    required BuildContext context,
    required String username,
    required String token,
  }) async {
    try {
      return await MockApiService.post(
        verifyOtpUrl,
        body: {'username': username, 'token': token},
      ) as String;
    } catch (e) {
      rethrow;
    }
  }

  // --- NEW LOCAL STORAGE METHODS ---
}
