import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/views/new_password_setup_view.dart';
import 'package:myapp/views/user_info_request_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  int _currentStep = 0;
  String _username = '';
  // String _token = '';

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _submitUserNameEmail(String username) async {
    setState(() => _isLoading = true);
    _username = username;

    try {
      final resetTokenmsg = await _authService.requestPasswordReset(
        context: context,
        username: username,
       // email: email,
      );

      if (resetTokenmsg != null) {

        if (mounted) {
          await showInfoDialog(
          context: context,
          title: 'Check Your Email',
          content: resetTokenmsg,
        );
        }
        setState(() {
          _currentStep = 1;
        });
      } else {
        if (mounted) {
          showSnackBar(
            context: context,
            message: 'Invalid username provided.',
            type: MessageType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring('Exception: '.length);
        }
        showSnackBar(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      }
    } finally {
      if(mounted){
         setState(() => _isLoading = false);
      }
    }
  }

  // void _submitOnetimePassword(String token) {
  //   _token = token;
  //   setState(() {
  //     _currentStep = 2;
  //   });
  // }

  Future<void> _resetPassword(String token,String newPassword) async {
    setState(() => _isLoading = true);

    try {
      final success = await _authService.resetPassword(
        context: context,
        username: _username,
        token: token,
        newPassword: newPassword,
      );
      if (success && mounted) {
        await showInfoDialog(
          context: context,
          title: 'Password Changed!',
          content: 'Your password has been changed successfully.',
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else if (mounted) {
        showSnackBar(
          context: context,
          message: 'Failed to reset password. The token may be invalid.',
          type: MessageType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString().replaceFirst('Exception: ', '');
        showSnackBar(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goBack() {
    if (_isLoading) return;

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
        currentView = UserInfoRequestView(onSubmit: _submitUserNameEmail);
        break;
      // case 1:
      //   currentView = OnetimePasswordRequestView(
      //     onSubmit: _submitOnetimePassword,
      //   );
      case 1:
        currentView = NewPasswordSetupView(onSubmit: _resetPassword);

        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case 0:
        currentTitle = 'Provide Your Information';
        break;
      // case 1:
      //   currentTitle = 'One-time Password';
      case 1:
        currentTitle = 'New Password Setup';
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
