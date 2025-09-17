
// -- IMPORTANT : REMOVE THIS LATER---//
import 'package:flutter/material.dart';
import 'package:myapp/services/notification_services.dart';
import 'package:myapp/widgets/app_dialog_boxes.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_page.dart'; // Adjust path if needed


// Thi is written test commn snackbars dialog boxes remove later
class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Replace Scaffold with AppPage for a consistent layout.
    return AppPage(
      title: 'Test Alerts & Notifications',
      // The content of your page goes into the 'child' property.
      child: SingleChildScrollView( // Added for safety if more buttons are added
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3. Replace all ElevatedButton instances with ActionButton.
            ActionButton(
              label: 'Show Instant Notification',
              onPressed: () {
                NotificationService.showNotification(
                  title: 'Instant Notification',
                  body: 'This is a test local notification!',
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Schedule Notification (5s)',
              onPressed: () {
                NotificationService.showScheduledNotification(
                  title: 'Scheduled Notification',
                  body: 'This notification was scheduled 5s ago!',
                );
                showSnackBar(
                  context: context,
                  message: 'Notification scheduled for 5s from now!',
                  type: MessageType.success,
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Snack Error',
              color: Colors.red, // Example of overriding color
              onPressed: () {
                showSnackBar(
                  context: context,
                  message: 'Test Error message',
                  type: MessageType.error,
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Snack Success',
              color: Colors.green, // Example of overriding color
              onPressed: () {
                showSnackBar(
                  context: context,
                  message: 'Test Success message',
                  type: MessageType.success,
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Snack Warning',
              color: Colors.orange, // Example of overriding color
              onPressed: () {
                showSnackBar(
                  context: context,
                  message: 'Test Warning message',
                  type: MessageType.warning,
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Info Dialog (Success)',
              onPressed: () {
                showInfoDialog(
                  context: context,
                  title: 'Payment Successful',
                  content: 'Your invoice has been paid and a receipt has been sent to your email.',
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Info Dialog (Error)',
              onPressed: () {
                showInfoDialog(
                  context: context,
                  title: 'Connection Failed',
                  content: 'Unable to connect to the server. Please check your internet connection and try again.',
                  isError: true,
                );
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Test Confirmation Dialog',
              onPressed: () async {
                final confirmed = await showConfirmationDialog(
                  context: context,
                  title: 'Payment Confirmation',
                  content: 'Are you sure you want to proceed with this payment?',
                  confirmButtonText: 'Proceed',
                );
                if (confirmed) {
                  showSnackBar(
                    context: context,
                    message: 'Payment has been confirmed.',
                    type: MessageType.success,
                  );
                } else {
                  showSnackBar(
                    context: context,
                    message: 'Payment was cancelled.',
                    type: MessageType.warning,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



// class TestPage extends StatelessWidget {
//   const TestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Notifications & Alerts')),
//       body: Center(
//         // Use a Column to hold multiple buttons
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 NotificationService.showNotification(
//                   title: 'Instant Notification',
//                   body: 'This is a test local notification!',
//                 );
//               },
//               child: const Text('Show Instant Notification'),
//             ),
//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 // Call the new scheduled notification method
//                 NotificationService.showScheduledNotification(
//                   title: 'Scheduled Notification',
//                   body: 'This notification was scheduled 5s ago!',
//                 );

//                 // 2. Use the common showSnackBar function for user feedback
//                 showSnackBar(
//                   context: context,
//                   message: 'Notification scheduled for 5s from now!',
//                   type:
//                       MessageType
//                           .success, // Using 'success' for positive feedback
//                 );

//               },
//               child: const Text('Schedule Notification (5 s)'),
//             ),
//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 // Call the new scheduled notification method
//                 // 2. Use the common showSnackBar function for user feedback
//                 showSnackBar(
//                                     context: context,

//                   message: 'Test Error message',
//                   type:
//                       MessageType
//                           .error, // Using 'success' for positive feedback
//                 );
//               },
//               child: const Text('Test Snack Error message'),
//             ),
//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 showSnackBar(
//                                     context: context,

//                   message: 'Test Success message',
//                   type:
//                       MessageType
//                           .success, // Using 'success' for positive feedback
//                 );
//               },
//               child: const Text('Test Snack Success message'),
//             ),
//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 showSnackBar(
//                                     context: context,
//                   message: 'Test Warning message',
//                   type:
//                       MessageType
//                           .warning, // Using 'success' for positive feedback
//                 );
//               },
//               child: const Text('Test Snack Warning message'),
//             ),

//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 showInfoDialog(
//                   context: context,
//                   title: 'Payment Successful',
//                   content:
//                       'Your invoice has been paid and a receipt has been sent to your email.',
//                 );
//               },
//               child: const Text('Test Payment Success message'),
//             ),

//             const SizedBox(height: 10), // Add some space between buttons
//             ElevatedButton(
//               onPressed: () {
//                 showInfoDialog(
//                   context: context,
//                   title: 'Connection Failed',
//                   content:
//                       'Unable to connect to the server. Please check your internet connection and try again.',
//                   isError: true,
//                 );
//               },
//               child: const Text('Test Connection Failed message'),
//             ),
//             const SizedBox(height: 10),
//             // --- Example for Confirmation Dialog ---
//             ElevatedButton(
//               onPressed: () async {
//                 final confirmed = await showConfirmationDialog(
//                   context: context,
//                   title: 'Payment Confirmation',
//                   content: 'Are you sure you want toproceed this payment',
//                   confirmButtonText: 'Proceed',
//                 );
//                 if (confirmed) {
//                   showSnackBar(
//                     context: context,
//                     message: 'Payment has been confirmed.',
//                     type: MessageType.success,
//                   );
//                 } else {
//                   showSnackBar(
//                     context: context,
//                     message: 'Payment was cancelled.',
//                     type: MessageType.warning,
//                   );
//                 }
//               },
//               child: const Text('Payment Confirmation'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
