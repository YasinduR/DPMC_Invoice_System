import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'app_header.dart';
import 'app_footer.dart';
//import 'package:myapp/theme/app_theme.dart';

// Common Setup of an app page
class AppPage extends StatelessWidget {
  final String title; // The text for the app bar title.
  final Widget child; // The main content of the page.
  final VoidCallback? onBack; // Custom action for the back button.
  final List<Widget>?
  actions; // Icons/buttons on the right of the app bar.(For Future Integrations)
  final bool showFooter; // Toggles the footer visibility.
  final EdgeInsets contentPadding; // Padding around the main content.
  final bool showAppBar; // Toggles the app bar visibility.
  final bool showBackButton; // Toggles the backbutton visibility.

  final bool
  canPop; // override Back Button behavior Set this false to prevent pop
  final Future<void> Function(bool didPop)?
  onPopInvoked; // Optional handler for pop default one asks whether to close the app

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.actions,
    this.showFooter = true, // Defaults to true
    this.showAppBar = true,
    this.showBackButton = true, // Defaults to true
    this.canPop = true, // By default back button can pop
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 16.0,
    ),
    this.onPopInvoked,
    
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (onPopInvoked != null) {
          await onPopInvoked!(didPop);
        } else if (!canPop) {
          // If canPop is false and no custom handler, show the default exit dialog
          final bool shouldExit = await showConfirmationDialog(
            context: context,
            confirmButtonText: 'Yes',
            cancelButtonText: 'No',
            title: 'Do you want to exit the application?',
          );

          if (shouldExit) {
            // SystemNavigator.pop(); // Closes App
            exit(0); // Ensure app closes
          }
        }
      },
      child: Scaffold(
        //backgroundColor: AppColors.background,
         appBar:
            showAppBar
                ? AppHeader(
                    title: title,
                    // Pass onBack only if showBackButton is true
                    onBack: showBackButton ? onBack : null,
                    actions: actions,
                    showBackButton: showBackButton, // Pass the new property

                  )
                : null,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: contentPadding,
                child: child, // Your screen's unique content is injected here.
              ),
            ),
            if (showFooter)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: const AppFooter(), // The AppFooter is now the child
              ),
          ],
        ),
      ),
    );
  }
}
