import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_switch_setting.dart';


// (AppSwitchSetting remains the same as above)

// ------------------- FIXED SecuritySettingView (StatefulWidget with didUpdateWidget) -------------------
class SecuritySettingView extends StatefulWidget {
  final bool isBioEnabled;
  final bool isActivityHistoryClearEnabled;
  final ValueChanged<bool> onBiometricChange;
  final ValueChanged<bool> onActivityHistoryClearChange;

  const SecuritySettingView({
    super.key,
    required this.isBioEnabled,
    required this.onBiometricChange,
    required this.isActivityHistoryClearEnabled,
    required this.onActivityHistoryClearChange,
  });

  @override
  State<SecuritySettingView> createState() => _SecuritySettingViewState();
}

class _SecuritySettingViewState extends State<SecuritySettingView> {
  late bool _isBioEnabled;
  late bool _isActivityHistoryClearEnabled;

  @override
  void initState() {
    super.initState();
    _isBioEnabled = widget.isBioEnabled;
    _isActivityHistoryClearEnabled = widget.isActivityHistoryClearEnabled;
  }

  @override
  void didUpdateWidget(covariant SecuritySettingView oldWidget) {
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
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
            ],
          ),
        ),
      ],
    );
  }
}