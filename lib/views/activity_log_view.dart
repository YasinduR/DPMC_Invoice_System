import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/log_text_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/activity_card.dart';


class ActivityLogView extends ConsumerStatefulWidget {
  final Function(Activity) onSubmit;
  const ActivityLogView({
    super.key,
    required this.onSubmit,
  });

  @override
  ConsumerState<ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends ConsumerState<ActivityLogView> {
  final LocalStorageService _storageService = LocalStorageService();

  List<Activity> _activities = [];
  
  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final userid = ref.read(authProvider).currentUser!.id;
    final logs = await _storageService.getActivities(userid);
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
              widget.onSubmit(activity);
              },
            );
          },
        ),
        ),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Export',
            onPressed: () async {
              if (_activities.isEmpty) {
              showSnackBar(
                context: context,
                message: "No activities to export",
                type: MessageType.warning,
              );
              return;
                }
      final buffer = StringBuffer();
      buffer.writeln("===== ACTIVITY LOG EXPORT =====");
      buffer.writeln("Exported on: ${DateTime.now()}");
      buffer.writeln("================================\n");
      for (final activity in _activities) {
        buffer.writeln(activity.getActivityLog());
        buffer.writeln("\n--------------------------------\n");
      }
      final content = buffer.toString();
      final fileName = "Activity_Log.txt";
      await LogTextService.saveFile(
        fileName: fileName,
        content: content,
        context: context,
      );
  },
),
        ],
      ),
    );
  }
}