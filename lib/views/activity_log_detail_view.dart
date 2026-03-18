import 'package:flutter/material.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/services/log_text_service.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/cards/activity_card.dart';
import 'package:myapp/widgets/cards/activity_detail_card.dart';


class ActivityLogDetailView extends StatefulWidget {
  final Activity activity;
  final Function onBack;

  const ActivityLogDetailView({
    super.key,
    required this.activity,
    required this.onBack,
  });

  @override
  State<ActivityLogDetailView> createState() =>
      _ActivityLogDetailViewState();
}

class _ActivityLogDetailViewState extends State<ActivityLogDetailView> {
  final LocalStorageService _storageService = LocalStorageService();

  late Activity activity;

  @override
  void initState() {
    super.initState();
    activity = widget.activity; 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ActivityDetailCard(activity: activity),
            ),
          ),
          const SizedBox(height: 16),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Export',
            onPressed: () async {
              final buffer = StringBuffer();
              buffer.writeln("===== ACTIVITY LOG EXPORT =====");
              buffer.writeln("Exported on: ${DateTime.now()}");
              buffer.writeln("================================\n");
              buffer.writeln(activity.getActivityLog());
              buffer.writeln("\n--------------------------------\n");

              final content = buffer.toString();
              final now = DateTime.now();

              final fileName = "Activity_${now
                .toIso8601String()
                .replaceAll(':', '-')
                .replaceAll('T', '_')
                .split('.')
                .first}.txt";
              //final fileName = "Activity_${DateTime.now()}.txt";

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