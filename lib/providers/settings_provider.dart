// Settings Provider - Added by Darshan R on 2026-04-03
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/color_scheme_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/theme/app_color_scheme.dart';
import 'package:myapp/theme/app_colors.dart';

class SettingsState {
  final String iconStyle;
  final AppColorScheme theme;

  SettingsState({
    required this.iconStyle,
    required this.theme,
  });

  SettingsState copyWith({
    String? iconStyle,
    AppColorScheme? theme,
  }) {
    return SettingsState(
      iconStyle: iconStyle ?? this.iconStyle,
      theme: theme ?? this.theme,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _storage;

  SettingsNotifier(this._storage)
      : super(SettingsState(
          iconStyle: 'Apple Glass',
          theme: AppThemes.light,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final style = await _storage.getIconStyle();
    final savedThemeName = await _storage.getSavedTheme();

    final theme =
        savedThemeName == 'dark' ? AppThemes.dark : AppThemes.light;

    state = state.copyWith(
      iconStyle: style,
      theme: theme,
    );
  }

  Future<void> setIconStyle(String style) async {
    await _storage.saveIconStyle(style);
    state = state.copyWith(iconStyle: style);
  }

  Future<void> setTheme(AppColorScheme scheme) async {
    final themeName = scheme == AppThemes.dark ? 'dark' : 'light';

    await _storage.saveTheme(themeName);
    state = state.copyWith(theme: scheme);
  }
}





// class SettingsNotifier extends StateNotifier<SettingsState> {
//   final LocalStorageService _localStorageService;

//   SettingsNotifier(this._localStorageService)
//       : super(SettingsState(iconStyle: 'Apple Glass')) {
//     _loadSettings();
//   }

//   Future<void> _loadSettings() async {
//     final style = await _localStorageService.getIconStyle();
//     state = state.copyWith(iconStyle: style);
//   }

//   Future<void> setIconStyle(String style) async {
//     await _localStorageService.saveIconStyle(style);
//     state = state.copyWith(iconStyle: style);
//   }
// }

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final localStorageService = ref.read(localStorageServiceProvider);
  return SettingsNotifier(localStorageService);
});
