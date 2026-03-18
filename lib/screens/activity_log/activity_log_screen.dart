import 'package:flutter/material.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/print_footer_detail_model.dart';
import 'package:myapp/services/printer_service.dart';
import 'package:myapp/views/activity_log_detail_view.dart';
import 'package:myapp/views/activity_log_view.dart';
import 'package:myapp/views/selected_activity_log_view.dart';
import 'package:myapp/widgets/app_page.dart';


class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  int _currentStep = 0;
  Activity? _selectedActivity;


  void _submit(activity) {
      setState(() {
        _currentStep++;
        _selectedActivity = activity;
      });
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _selectedActivity = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;

    switch (_currentStep) {
      case 0:
        currentView = ActivityLogView(onSubmit: _submit);
        break;
      case 1:
        currentView = ActivityLogDetailView(onBack: _goBack, activity: _selectedActivity!,);
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
      case 1:
        currentTitle = 'Activity Log';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      currentRouteName: 'activityLog',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}
