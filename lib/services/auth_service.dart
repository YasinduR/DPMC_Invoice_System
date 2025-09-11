import 'package:flutter/material.dart';
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
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final user =
          await MockApiService.post(
                'api/user/login',
                body: {'username': username, 'password': password},
              )
              as User; 
      return user;
    } catch (e) {
      return null;
    } finally {
            if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }


  Future<bool> changePassword({
    required BuildContext context,
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      return await MockApiService.post(
        'api/user/changepassword',
        body: {
          'username': username,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      ) as bool;
    } catch (e) {
      return false;
    } finally {
            if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }

  

  Future<String?> requestPasswordReset({
    required BuildContext context,
    required String username,
    required String email,
  }) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      return await MockApiService.post(
        'api/user/request-password-reset',
        body: {'username': username, 'email': email},
      ) as String?;
    } catch (e) {
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
      ) as bool;
    } catch (e) {
      return false;
    } finally {
            if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }



}
