import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/app_switch_setting.dart';
import 'package:myapp/providers/settings_provider.dart';

class SettingsView extends ConsumerStatefulWidget {
  final bool isBioEnabled;
  final bool isActivityHistoryClearEnabled;
  final ValueChanged<bool> onBiometricChange;
  final ValueChanged<bool> onActivityHistoryClearChange;

  const SettingsView({
    super.key,
    required this.isBioEnabled,
    required this.onBiometricChange,
    required this.isActivityHistoryClearEnabled,
    required this.onActivityHistoryClearChange,
  });

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late bool _isBioEnabled;
  late bool _isActivityHistoryClearEnabled;

  // Icon Styles - Added by Darshan R on 2026-04-03
  final List<String> _iconStyles = [
    'Apple Glass',
    'Material Default',
    'Material 3',
    '3D',
    'Lucide',
    'Iconly',
    'HugeIcons',
    'Font Awesome',
    'Flutter Awesome'
  ];

  @override
  void initState() {
    super.initState();
    _isBioEnabled = widget.isBioEnabled;
    _isActivityHistoryClearEnabled = widget.isActivityHistoryClearEnabled;
  }

  @override
  void didUpdateWidget(covariant SettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync biometric state
    if (widget.isBioEnabled != oldWidget.isBioEnabled) {
      _isBioEnabled = widget.isBioEnabled;
    }

    // Sync activity history clear state
    if (widget.isActivityHistoryClearEnabled !=
        oldWidget.isActivityHistoryClearEnabled) {
      _isActivityHistoryClearEnabled =
          widget.isActivityHistoryClearEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIconStyle = ref.watch(settingsProvider).iconStyle;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Security',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 12),
              AppSwitchSetting(
                title: 'Bio-Metric Login',
                value: _isBioEnabled,
                onChanged: (value) {
                  setState(() => _isBioEnabled = value);
                  widget.onBiometricChange(value);
                },
              ),

              const SizedBox(height: 8),

              AppSwitchSetting(
                title: 'Clear Activity History',
                value: _isActivityHistoryClearEnabled,
                onChanged: (value) {
                  setState(() => _isActivityHistoryClearEnabled = value);
                  widget.onActivityHistoryClearChange(value);
                },
              ),
              // Appearance - Added by Darshan R on 2026-04-03
              const Divider(height: 32),
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Icon Style'),
                subtitle: const Text('Change the look of menu icons'),
                trailing: DropdownButton<String>(
                  value: _iconStyles.contains(selectedIconStyle) ? selectedIconStyle : 'Apple Glass',
                  items: _iconStyles.map((style) {
                    return DropdownMenuItem(
                      value: style,
                      child: Text(style, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(settingsProvider.notifier).setIconStyle(val);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}