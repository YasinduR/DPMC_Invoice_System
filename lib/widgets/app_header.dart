import 'package:flutter/material.dart';
//import 'package:myapp/theme/app_theme.dart';

// Common AppHeader
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Title of the Current view
  final VoidCallback? onBack; // Callback for back button
  final List<Widget>? actions; // For Future integrations
  final bool showBackButton;
  const AppHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);
    final VoidCallback? backCallback = onBack;
    if (showBackButton) {
      return AppBar(
        leading:
            canPop
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                      backCallback != null
                          ? backCallback
                          : () => Navigator.of(context).pop(),
                )
                : null,
        title: Text(title),
        actions: actions,
      );
    }
    else{
        return AppBar(title: Text(title),actions: actions,automaticallyImplyLeading:false);
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}
