import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart'; 

class LocalAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticateBiometrics(String localizedReason) async {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Unlock to proceed',
            biometricHint: 'Scan your finger or face',
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up your screen lock or biometrics.',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false, // Allows device credentials too
          stickyAuth: true,
        ),
      );
    return didAuthenticate;
  }
}
