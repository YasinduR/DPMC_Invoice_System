// Added by Darshan R on 09/04/2026
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/local_storage_service.dart';

class SettingsState {
  final String iconStyle;
  final String themeMode;

  SettingsState({
    required this.iconStyle,
    required this.themeMode,
  });

  SettingsState copyWith({
    String? iconStyle,
    String? themeMode,
  }) {
    return SettingsState(
      iconStyle: iconStyle ?? this.iconStyle,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _localStorageService;

  SettingsNotifier(this._localStorageService)
      : super(SettingsState(iconStyle: 'Apple Glass', themeMode: 'Light')) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final style = await _localStorageService.getIconStyle();
    final theme = await _localStorageService.getThemeMode();
    state = state.copyWith(iconStyle: style, themeMode: theme);
  }

  Future<void> setIconStyle(String style) async {
    await _localStorageService.saveIconStyle(style);
    state = state.copyWith(iconStyle: style);
  }

  Future<void> setThemeMode(String mode) async {
    await _localStorageService.saveThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }
}

// Provider definition
final settingsProvider = 
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
      final localStorageService = ref.watch(localStorageServiceProvider);
      return SettingsNotifier(localStorageService);
    });

// Assuming localStorageServiceProvider exists based on context or adding it if missing
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
