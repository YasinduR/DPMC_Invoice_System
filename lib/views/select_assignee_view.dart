// TIN selection view shows after the dealer selection
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';

class SelectAssigneeView extends ConsumerStatefulWidget {
  //final Function(TinData) onTinNumberSelected;
  final Function(Assignee) onSubmit;
  final Assignee? selectedUser;

  const SelectAssigneeView({
    super.key,
    //required this.onTinNumberSelected,
    required this.onSubmit,
    this.selectedUser,
  });

  @override
  ConsumerState<SelectAssigneeView> createState() => _SelectUserViewState();
}

class _SelectUserViewState extends ConsumerState<SelectAssigneeView> {
  final TextEditingController _assigneeController = TextEditingController();
  bool _isUserSelectionCommitted = false;
  Assignee? _currentSelectedUser;

  @override
  void initState() {
    super.initState();
    if (widget.selectedUser != null) {
      _assigneeController.text = widget.selectedUser!.assigneeId;
      _currentSelectedUser = widget.selectedUser!;
      _isUserSelectionCommitted = true;
    }
  }

  @override
  void didUpdateWidget(covariant SelectAssigneeView old) {
    super.didUpdateWidget(old);
    if (widget.selectedUser?.assigneeId != old.selectedUser?.assigneeId) {
      _assigneeController.text = widget.selectedUser?.assigneeId ?? '';
    }
  }

  void _onUserSubmitted() {
    if (_currentSelectedUser != null) {
      widget.onSubmit(_currentSelectedUser!);
      _assigneeController.clear();
      setState(() {
        _isUserSelectionCommitted = false;
      });
    }
  }

  @override
  void dispose() {
    _assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;
    final String supervisorId = currentUser!.id ;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField<Assignee>(
            controller: _assigneeController,
            labelText: 'Select Assignee',
            selectionSheetTitle: 'Select a Assignee',
            initialValue: widget.selectedUser,
            //onSelected: widget.onTinNumberSelected,
            onSelected: (assignee) {
              setState(() {
                _currentSelectedUser = assignee;
              });
            },
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isUserSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['Name','Assignee'],
            valueFields: const ['name','assigneeId'],
            mainField: 'assigneeId',
            dataUrl: 'assignee/list',
            filterConditions: [
              ['supervisorId', '=',supervisorId],
            ],
            layoutType: SelectionSheetLayoutType.card,
            
          ),

          const Spacer(),

          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: _onUserSubmitted,
            disabled: !_isUserSelectionCommitted,
          ),
        ],
      ),
    );
  }
}
