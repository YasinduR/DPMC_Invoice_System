import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/widgets/app_page.dart';

// Middle Screen for Every Menu Screen 
//in the begining this will check whethere the current user has specific permission to the given screenId
class PermissionCheckScreen extends ConsumerStatefulWidget {
  final String screenId;
  final String  screenTitle;
  final WidgetBuilder destinationScreenBuilder;

  const PermissionCheckScreen({
    super.key,
    required this.screenId,
    required this.screenTitle,
    required this.destinationScreenBuilder,
  });

  @override
  ConsumerState<PermissionCheckScreen> createState() =>
      _PermissionCheckScreenState();
}


class _PermissionCheckScreenState extends ConsumerState<PermissionCheckScreen> {
  String? _currentTitle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.screenTitle;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
  }

  Future<void> _checkPermission() async {
    if (!mounted) return;

    final user = ref.read(authProvider).currentUser;
    if (user == null) {
      setState(() {
        _currentTitle = 'Access Denied';
        _errorMessage = 'Authentication Error: No user is currently logged in.';
      });
      return;
    }

    await checkScreenPermission(
      context: context,
      screenId: widget.screenId,
      roleIds: user.roles,
      onSuccess: () {
        if (!mounted) return;
        // On success, replace this screen entirely with the destination.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: widget.destinationScreenBuilder),
        );
      },
      onError: (errorMessage) {
        if (!mounted) return;
        // On error, update the state to rebuild the UI with the error message.
        setState(() {
          _currentTitle = 'Access Denied';
          _errorMessage = errorMessage;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _currentTitle ?? 'Loading...',
      contentPadding: const EdgeInsets.all(16.0),
      child: Center(
      child: _errorMessage == null
          ? const Text( // It's good practice to use const for static widgets
              'Loading...',
              style: TextStyle(fontSize: 16),
            )
          : Text(
              _errorMessage!,
              // Add this line to center the text content
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 16),
            ),
    ),
    );
  }
}


// class _PermissionCheckScreenState extends ConsumerState<PermissionCheckScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Perform the check as soon as the widget is initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
//     //_checkPermission();
//   }

//   Future<void> _checkPermission() async {
//     final user = ref.read(authProvider).currentUser;
//     if (user == null) {
//       // This should not happen if the route guard is set up correctly, but it's a good safeguard.
//       //Navigator.of(context).pop(); // Go back
//       // ScaffoldMessenger.of(
//       //   context,
//       // ).showSnackBar(const SnackBar(content: Text('Authentication Error.')));
//       return;
//     }

//     // Use a local context that is guaranteed to be mounted.
//     final currentContext = context;

//     await checkScreenPermission(
//       context: currentContext,
//       screenId: widget.screenId,
//       roleIds: user.roles,
//       onSuccess: () {
//         // If permission is granted, replace this loading screen with the real one.
//         Navigator.of(currentContext).pushReplacement(
//           MaterialPageRoute(builder: widget.destinationScreenBuilder),
//         );
//       },
//       onError: (errorMessage) {
//         // If permission is denied, pop this screen and show an error.
//         Navigator.of(currentContext).pop();
//         ScaffoldMessenger.of(
//           currentContext,
//         ).showSnackBar(SnackBar(content: Text(errorMessage)));
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show a loading indicator while the check is in progress.
//     return AppPage(
//       title: currentTitle,
//       contentPadding: EdgeInsets.zero,
//       child: ,
//     );
//   }
// }
