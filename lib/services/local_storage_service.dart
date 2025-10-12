import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kBiometricEnabled = 'biometricEnabled';
  static const _kSavedUsername = 'savedUsername';
  static const _kSavedPwd = 'savedPassword';

  Future<void> saveBiometricPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, enabled);
  }

  Future<bool> getBiometricPreference(BuildContext context) async {
    final loadingOverlay = AppLoadingOverlay();
    try {
      loadingOverlay.show(context);
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kBiometricEnabled) ?? false;
    } catch (e) {
      return false;
    } finally{
    if (loadingOverlay.isShowing) {
        loadingOverlay.hide();
      }
    }
  }


  Future<void> saveUsernameForBiometric(
    String username,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, true);
    await prefs.setString(_kSavedUsername, username);
    await prefs.setString(_kSavedPwd, password);
  }

  Future<void> setBiometricPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, value);
  }

  Future<String?> getSavedUsernameForBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSavedUsername);
  }

  Future<String?> getSavedPasswordForBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSavedPwd);
  }

  Future<void> clearSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kBiometricEnabled);
    await prefs.remove(_kSavedUsername);
    await prefs.remove(_kSavedPwd);
  }
}
