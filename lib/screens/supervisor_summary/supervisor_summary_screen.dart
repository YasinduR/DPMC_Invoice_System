import 'package:flutter/material.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/dealer_stat_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/views/select_assignee_view.dart';
import 'package:myapp/views/supervisor_summary_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/views/dealerwise_tin_detail_view.dart';

class SupervisorSummaryScreen extends StatefulWidget {
  const SupervisorSummaryScreen({super.key});

  @override
  State<SupervisorSummaryScreen> createState() =>
      _SupervisorSummaryScreenState();
}

class _SupervisorSummaryScreenState extends State<SupervisorSummaryScreen> {
  int _currentStep = 0;
  Assignee? _selectedAssignee;
  DealerStat? _selectedDealer;
  List<TinData>? _tins;

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
        if (_currentStep == 0) {
          _selectedAssignee = null;
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onDealerSelected(DealerStat dealer, List<TinData> tins) {
    setState(() {
      _selectedDealer = dealer;
      _tins = tins;
      _currentStep = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    switch (_currentStep) {
      case 0:
        currentView = SelectAssigneeView(
          onSubmit: _submit
          );
        break;
      case 1:
        currentView = SupervisorSummaryView(
          assignee: _selectedAssignee!,
          onSubmit: _onDealerSelected,
        );
        break;
      case 2:
        currentView = DealerTinView(
          dealer: _selectedDealer!,
          tins: _tins!
          );
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
      case 1:
      case 2:
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
