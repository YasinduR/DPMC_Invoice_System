import 'package:flutter/material.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

class AuthService {
  Future<void> logout({required BuildContext context}) async {
    final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      await Future.delayed(const Duration(milliseconds: 500));
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
    required Function(Exception e) onError,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final user = await MockApiService.post(
        'api/user/login',
        body: {'username': username, 'password': password},
      ) as User;
      return user;
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
        'api/user/changepassword',
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

  Future<String?> requestPasswordReset({
    required BuildContext context,
    required String username,
    //required String email,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      return await MockApiService.post(
            'api/user/request-password-reset',
            body: {'username': username, 
            //'email': email
            },
          )
          as String?;
    } catch (e) {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
      return null;
    } finally {
      if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

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
            'api/user/reset-password',
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

  // This is the setPassword for first-time login as per your prompt
  Future<User> setPassword({ // Renamed from setInitialPassword to match your prompt
    required BuildContext context,
    required String username,
    required String newPassword,
    required SecurityQuestionAnswer securityQandA, 
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final updatedUser = await MockApiService.post(
        'api/user/set-password', 
        body: 
        {
          'username': username,
          'newPassword': newPassword,
          'securityQuestion': securityQandA.question,
          'securityAnswer': securityQandA.answer,
        },
      ) as User;
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

}
