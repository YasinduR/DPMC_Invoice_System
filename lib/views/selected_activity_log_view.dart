import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_action_button.dart';

// Select Invoice or Receipt to Reprint View from the Screen
class SelectedActivityLogView extends StatefulWidget {
  final Function() onBack;
  final String? selectedLog;

  const SelectedActivityLogView({super.key, required this.onBack, this.selectedLog});

  @override
  State<SelectedActivityLogView> createState() => _SelectedActivityLogViewState();
}

class _SelectedActivityLogViewState extends State<SelectedActivityLogView> {
  late String? _selectedLog;

  @override
  void initState() {
    super.initState();
    _selectedLog = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          ActionButton(
            icon: Icons.arrow_back,
            label: 'Back',
            onPressed: () => widget.onBack(),
            //disabled: _isPrintDisabled,
          ),
        ],
      ),
    );
  }
}
