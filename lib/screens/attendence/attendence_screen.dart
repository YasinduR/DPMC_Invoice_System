import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_page.dart';

// --- MAIN WIDGET: Manages the flow state ---
class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  int _currentStep = 0;

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    switch (_currentStep) {
      default:
        currentView = const Center(child: Text('Under-Development'));
    }

    final String currentTitle;
    switch (_currentStep) {
      default:
        currentTitle = 'Attendence';
    }
    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}
