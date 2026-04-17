import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/color_scheme_model.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/theme/app_colors.dart';


// class ThemeNotifier extends StateNotifier<AppColorScheme> {
//   final LocalStorageService _storage = LocalStorageService();
//   ThemeNotifier() : super(AppThemes.light) {
//     _loadSavedTheme(); // load asynchronously on creation
//   }

//   Future<void> _loadSavedTheme() async {
//     final savedThemeName = await _storage.getSavedTheme();
//     final newState = savedThemeName == 'dark' ? AppThemes.dark : AppThemes.light;
//     state = newState;
//   }

//   Future<void> setLightTheme() async {
//     state = AppThemes.light;
//     await _storage.saveTheme('light');
//   }

//   Future<void> setDarkTheme() async {
//     state = AppThemes.dark;
//     await _storage.saveTheme('dark');
//   }

//   Future<void> setTheme(AppColorScheme scheme) async {
//     state = scheme;
//     final themeName = scheme == AppThemes.dark ? 'dark' : 'light';
//     await _storage.saveTheme(themeName);
//   }
// }

// final themeProvider = StateNotifierProvider<ThemeNotifier, AppColorScheme>((ref) {
//   return ThemeNotifier();
// });