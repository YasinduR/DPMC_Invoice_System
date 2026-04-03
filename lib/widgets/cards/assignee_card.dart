import 'package:flutter/material.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Assignee Information Card Element 

class AssigneeInfoCard extends StatelessWidget {
  final Assignee assignee;
  const AssigneeInfoCard({super.key, required this.assignee});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
      // Text(
      //   '${Assignee.name} - ${Assignee.accountCode}',
      //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      // ),
      AutoSizeText(
        '${assignee.name} - ${assignee.assigneeId}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        maxLines: 1,
      ),
    );
  }
}
