import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/views/change_password_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  Future<void> _handleChangePassword(
    String oldPassword,
    String newPassword,
  ) async {

    if(oldPassword==newPassword){
      showSnackBar(
        context: context,
        message: 'New password cannot be the same as the old password.',
        type: MessageType.error,
        );
      return;
    }

    final bool haschanged = await ref
        .read(authProvider.notifier)
        .changePassword(
          context,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

         if (!mounted) return;

    if (haschanged) {
      showInfoDialog(
          context: context,
          title: 'Password Changed !',
          content: 'Your Password has been changed successfully. Please log in again.',
          );
    
      }
    else{
      final errorMessage = ref.read(authProvider).errorMessage;
      showSnackBar(
        context: context,
        message: errorMessage!,
        type: MessageType.error,
        );

    }
    
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.currentUser;

    if (currentUser == null) {
      return const AppPage(
        title: '',
        child: Center(child: Text('No user is logged in. Please log in again.')),
      );
    }
    return AppPage(
      title: 'Change Password',
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: ChangePasswordView(
        user: currentUser,
        onSubmit: _handleChangePassword,
      ),
    );
  }
}