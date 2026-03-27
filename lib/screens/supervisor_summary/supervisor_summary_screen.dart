import 'package:flutter/material.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/views/select_assignee_view.dart';
import 'package:myapp/views/supervisor_summary_view.dart';
import 'package:myapp/widgets/app_page.dart';


class SupervisorSummaryScreen extends StatefulWidget {
  const SupervisorSummaryScreen({super.key});

  @override
  State<SupervisorSummaryScreen> createState() => _SupervisorSummaryScreenState();
}

class _SupervisorSummaryScreenState extends State<SupervisorSummaryScreen> {
  int _currentStep = 0;
  Assignee? _selectedAssignee;


  void _submit(user) {
      setState(() {
        _currentStep++;
        _selectedAssignee = user;
      });
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _selectedAssignee = null;
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
        currentView = SelectAssigneeView(onSubmit: _submit);
        break;
      case 1:
        currentView = SupervisorSummaryView(assignee: _selectedAssignee!);
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
      case 1:
        currentTitle = 'Supervisor Summary';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      currentRouteName: 'supervisorSummary',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}
