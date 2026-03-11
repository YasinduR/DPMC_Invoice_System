import 'package:flutter/material.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/widgets/cards/activity_card.dart';


class ActivityLogView extends StatefulWidget {
  final Function() onSubmit;
  final String? selectedLog;

  const ActivityLogView({
    super.key,
    required this.onSubmit,
    this.selectedLog,
  });

  @override
  State<ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends State<ActivityLogView> {
  final LocalStorageService _storageService = LocalStorageService();

  List<Activity> _activities = [];
  String? _selectedLog;

  @override
  void initState() {
    super.initState();
    _selectedLog = widget.selectedLog;
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final logs = await _storageService.getActivities();
    setState(() {
      _activities = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [

        Expanded(
          child: _activities.isEmpty
          ? const Center(child: Text("No Activities to show"))
          : ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            return ActivityCard(
              activity: activity,
              onTap: () {
                setState(() {
                  _selectedLog = activity.id;
                });
              },
            );
          },
        ),
        ),
          const SizedBox(height: 16),
          /// Print Button
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Export',
            onPressed: () => widget.onSubmit(),
          ),
        ],
      ),
    );
  }
}