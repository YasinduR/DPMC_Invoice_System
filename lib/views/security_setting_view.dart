import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_switch_setting.dart';


// (AppSwitchSetting remains the same as above)

// ------------------- FIXED SecuritySettingView (StatefulWidget with didUpdateWidget) -------------------
class SecuritySettingView extends StatefulWidget {
  final bool isBioEnabled;
  final ValueChanged<bool> onBiometricChange;

  const SecuritySettingView({
    super.key,
    required this.isBioEnabled,
    required this.onBiometricChange,
  });

  @override
  State<SecuritySettingView> createState() => _SecuritySettingViewState();
}

class _SecuritySettingViewState extends State<SecuritySettingView> {
  late bool _isBioEnabled;

  @override
  void initState() {
    super.initState();
    _isBioEnabled = widget.isBioEnabled;
  }

  // --- IMPORTANT FIX HERE ---
  @override
  void didUpdateWidget(covariant SecuritySettingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent widget passed a new 'isBioEnabled' value, update the internal state.
    if (widget.isBioEnabled != oldWidget.isBioEnabled) {
      setState(() {
        _isBioEnabled = widget.isBioEnabled;
      });
    }
  }
  // --- END IMPORTANT FIX ---

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
                onChanged: widget.onBiometricChange,
                value: _isBioEnabled, // Use the internal state that's now updated
              ),
              const SizedBox(height: 24),
              // Include Upcoming Settings Here
            ],
          ),
        ),
      ],
    );
  }
}