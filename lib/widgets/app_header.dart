import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppHeader({super.key, required this.title, this.onBack, this.actions});

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);
    final VoidCallback? backCallback = onBack;

    return AppBar(
      leading:
          canPop
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primary,
                ),
                onPressed:
                    backCallback != null
                        ? backCallback
                        : () => Navigator.of(context).pop(),
              )
              : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}
