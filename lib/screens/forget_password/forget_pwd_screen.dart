import 'package:flutter/material.dart';
import 'package:myapp/errors/app_exceptions.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/views/new_password_setup_view.dart';
import 'package:myapp/views/otp_view.dart';
import 'package:myapp/views/user_info_request_view.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/services/dummy_data.dart';
import 'package:myapp/helpers/common_functions.dart';

import 'package:myapp/services/mock_api_service.dart'; // DEV ONLY

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  int _currentStep = 0;
  String _username = '';
  String _contactHint = '';
  String _token = '';
  String _maskedPhone = '';
  String _maskedEmail = '';
  String _devOtp = '';    // DEV ONLY

  final AuthService _authService = AuthService();
  final LocalStorageService _storageService = LocalStorageService();
  bool _isLoading = false;

  Future<void> _submitUserNameEmail(String username) async {
    setState(() => _isLoading = true);
    _username = username;

    try {
      final resetTokenmsg = await _authService.requestPasswordReset(
        context: context,
        username: username,
      );

      if (resetTokenmsg != null) {
        // Added by Darshan R on 12/03/2026
        final userMatches = DummyData.users
            .where((u) => u.username == _username.toLowerCase());
        final user = userMatches.isNotEmpty ? userMatches.first : null;

        String phoneHint = '';
        String emailHint = '';

        if (user != null) {
          phoneHint = maskPhoneNumber(user.telephone);
          emailHint = maskEmail(user.email);
        }

        setState(() {
          _maskedPhone = phoneHint;
          _maskedEmail = emailHint;
          _devOtp = MockApiService.devOtp; // DEV ONLY
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
        String errorMessage;
        if (e is UnauthorisedException) {
          errorMessage = e.toString(); // Cast here
        } else {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }

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

  // void _submitOnetimePassword(String token) {
  //   _token = token;
  //   setState(() {
  //     _currentStep = 2;
  //   });
  // }

  Future<void> _resetPassword(String token, String newPassword) async {
    setState(() => _isLoading = true);

    try {
      final success = await _authService.resetPassword(
        context: context,
        username: _username,
        token: token,
        newPassword: newPassword,
      );
      if (success && mounted) {
        await _storageService.clearSavedLoginInfo();
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
        String errorMessage;
        if (e is UnauthorisedException) {
          errorMessage = e.toString(); // Cast here
        } else {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }

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
        // Added by Darshan R on 12/03/2026
        currentView = OtpView(
          contactPhone: _maskedPhone,  
          contactEmail: _maskedEmail,  
          devOtp: _devOtp,            // DEV ONLY
          onSubmit: (token) async {
            try {
              final resetToken = await _authService.verifyOtp(
                context: context,
                username: _username,
                token: token,
              );
              if (mounted) {
                setState(() {
                  _token = resetToken;     // stores the signed reset JWT
                  _currentStep = 2;
                });
              }
            } catch (e) {
              if (mounted) {
              showSnackBar(
                context: context,
                message: e is UnauthorisedException
                    ? e.toString()
                    : 'Invalid or expired OTP.',
                type: MessageType.error,
              );
            }
          }
        });
        break;
      case 2:
        currentView = NewPasswordSetupView(onSubmit: (newPassword) => _resetPassword(_token, newPassword));
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case 0:
        currentTitle = 'Provide Your Information';
        break;
      case 1:
        currentTitle = 'Enter One-time Password';
        break;
      case 2:
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
