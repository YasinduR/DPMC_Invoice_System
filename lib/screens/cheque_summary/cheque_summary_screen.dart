import 'package:flutter/material.dart';
import 'package:myapp/views/cheque_summary_view.dart';
import 'package:myapp/widgets/app_page.dart';


class ChequeSummaryScreen extends StatefulWidget {
  const ChequeSummaryScreen({super.key});

  @override
  State<ChequeSummaryScreen> createState() => _ChequeSummaryScreenState();
}

class _ChequeSummaryScreenState extends State<ChequeSummaryScreen> {
  int _currentStep = 0;
  //Activity? _selectedActivity;


  void _print() {

      // setState(() {
      //   _currentStep++;
      //  // _selectedActivity = activity;
      // });
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      //  _selectedActivity = null;
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
        currentView = ChequeSummaryView(onPrint: _print);
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
      case 1:
        currentTitle = 'Cheque Summary';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}