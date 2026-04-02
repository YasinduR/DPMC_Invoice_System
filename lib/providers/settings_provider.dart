// Settings Provider - Added by Darshan R on 2026-04-03
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/local_storage_service.dart';

class SettingsState {
  final String iconStyle;

  SettingsState({required this.iconStyle});

  SettingsState copyWith({String? iconStyle}) {
    return SettingsState(
      iconStyle: iconStyle ?? this.iconStyle,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _localStorageService;

  SettingsNotifier(this._localStorageService)
      : super(SettingsState(iconStyle: 'Apple Glass')) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final style = await _localStorageService.getIconStyle();
    state = state.copyWith(iconStyle: style);
  }

  Future<void> setIconStyle(String style) async {
    await _localStorageService.saveIconStyle(style);
    state = state.copyWith(iconStyle: style);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final localStorageService = ref.read(localStorageServiceProvider);
  return SettingsNotifier(localStorageService);
});
