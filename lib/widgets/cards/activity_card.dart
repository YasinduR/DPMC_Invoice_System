import 'package:flutter/material.dart';
import 'package:myapp/contracts/common_functions.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/theme/app_colors.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  //final bool selected;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    //required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(
          _getActivityIcon(activity.type),
          color: _getStatusColor(activity.status),
        ),
        title: Text(activity.getActivityName()),
        subtitle: Text(formatDateTime(activity.timestamp)),
        trailing:
            activity.status != null
                ? Text(
                  activity.status!.name.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(activity.status),
                    fontWeight: FontWeight.bold,
                  ),
                )
                : null,
        onTap: onTap,
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.invoiceSave:
        return Icons.receipt;
      case ActivityType.invoiceReprint:
        return Icons.print;
      case ActivityType.receiptSave:
        return Icons.payments;
      case ActivityType.receiptReprint:
        return Icons.print;
      case ActivityType.returnSave:
        return Icons.assignment_return;
      case ActivityType.adviceOfDispatchNote:
        return Icons.local_shipping;
      case ActivityType.returnRequestAdjustment:
        return Icons.edit_note;
      case ActivityType.attendanceOn:
        return Icons.login;
      case ActivityType.attendanceOff:
        return Icons.logout;
    }
  }

  Color _getStatusColor(StatusType? status) {
    switch (status) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.failed:
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }
}
