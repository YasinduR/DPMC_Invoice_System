import 'package:flutter/material.dart';

class AppSwitchSetting extends StatelessWidget {
  const AppSwitchSetting({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.enabled = true, 
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged; 
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? actualOnChanged = enabled ? onChanged : null;

    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: actualOnChanged, 
      secondary: icon != null ? Icon(icon) : null,
    );
  }
}