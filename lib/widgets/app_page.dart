import 'package:flutter/material.dart';
import 'app_header.dart';
import 'app_footer.dart';
import 'package:myapp/theme/app_theme.dart';

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showFooter;
  final EdgeInsets contentPadding;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.actions,
    this.showFooter = true, // Defaults to true
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 16.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppHeader(title: title, onBack: onBack, actions: actions),

      body: Column(
        children: [
          // 1. CONTENT AREA: Fills all available space.
          Expanded(
            // 2. SCROLLING: Automatically enabled for long content.
            //child: SingleChildScrollView(  removed
            child: Padding(
              padding: contentPadding,
              child: child, // Your screen's unique content is injected here.
            ),
            // ),
          ),
          // 4. FOOTER: Conditionally shown at the bottom.
          if (showFooter)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: const AppFooter(), // The AppFooter is now the child
            ),
        ],
      ),
    );
  }
}
