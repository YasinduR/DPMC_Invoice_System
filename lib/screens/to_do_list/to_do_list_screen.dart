import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_page.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
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
      case 0:
        currentView = Center(child: Text('No Pending Activities.'));
        break;
      default:
        currentView = Center(child: Text('No Pending Activities.'));
    }

    final String currentTitle;

    switch (_currentStep) {
      case 0:
      case 1:
        currentTitle = 'To Do List';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      currentRouteName: 'toDoList',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}