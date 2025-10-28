// The InitializerScreen to Intialize Location Service
import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/services/location_service.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_loading_indicator.dart';
import 'package:myapp/widgets/app_page.dart';

class InitializerScreen extends StatefulWidget {
  const InitializerScreen({super.key});

  @override
  State<InitializerScreen> createState() => _InitializerScreenState();
}

class _InitializerScreenState extends State<InitializerScreen>
    with WidgetsBindingObserver {
  bool _locationReady = false;
  bool _isLoading = true;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationAndPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationAndPermissions();
    }
  }

  Future<void> _checkLocationAndPermissions() async {
    setState(() {
      _isLoading = true;
    });

    final bool ready =
        await _locationService.initializeLocationAndPermissions();

    if (mounted) {
      setState(() {
        _locationReady = ready;
        _isLoading = false;
      });

      if (_locationReady) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body:AppLoadingIndicator()
       );
    } else if (!_locationReady) {
      return AppPage(
        showBackButton: false,
        canPop: false,
        title: 'Location Required',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 80,
                  color: AppColors.disabled,
                ),
                const SizedBox(height: 20),
                Text(
                  'Location services and permissions are essential.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                ActionButton(
                  icon: Icons.location_on,
                  label: 'Open Location Settings',
                  onPressed: () async {
                    await _locationService
                        .openLocationSettings(); // Open device location settings
                  },
                ),
                const SizedBox(height: 10),
                ActionButton(
                  icon: Icons.location_on,
                  label: 'Open App Permissions',
                  onPressed: () async {
                    await _locationService.openAppSettings();
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _checkLocationAndPermissions,
                  child: const Text('Re-check Location Status'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body:AppLoadingIndicator()
       );
    }
  }
}
