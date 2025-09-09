import 'package:flutter/material.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';


/// A reusable utility function to handle API data fetching with a loading overlay.
///
/// This function simplifies the process of:
/// 1. Showing a loading overlay.
/// 2. Calling an async data-fetching operation (e.g., an API).
/// 3. Hiding the overlay on success or failure.
/// 4. Updating the widget's state with the fetched data or an error message.
///
/// - [context]: The BuildContext required to show the overlay.
/// - [dataUrl]: The API endpoint to fetch data from.
/// - [onSuccess]: A callback that receives the fetched data list.
/// - [onError]: A callback that receives an error message if the fetch fails.
/// 
/// 
Future<void> inquire<T extends Mappable>({
  required BuildContext context,
  required String dataUrl,
  required Function(List<T> data) onSuccess,
  required Function(String errorMessage) onError,
}) async {
  // Initialize the loading overlay
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();

  // Check if the widget is still in the tree before proceeding
  if (!context.mounted) return;

  try {
    // Show the overlay before starting the async operation
    loadingOverlay.show(context);

    // Fetch data from the API
    final List<T> data = await MockApiService.fetchData<T>(dataUrl);

    // If successful, call the onSuccess callback with the data
    onSuccess(data);

  } catch (e) {
    // If an error occurs, call the onError callback with an error message
    onError('Failed to load data: $e');

  } finally {
    // IMPORTANT: Always hide the overlay when the operation is complete
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

/// Authenticates a dealer and handles its own loading overlay.
Future<void> dealerLogin({
  required BuildContext context,
  required String dealerCode,
  required String pin,
  required VoidCallback onSuccess, // Callback for successful authentication
  required Function(String errorMessage) onError, // Callback for failures
}) async {
  // Initialize the loading overlay for this specific operation.
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();

  // Check if the widget is still in the tree before proceeding.
  if (!context.mounted) return;

  try {
    // Show the overlay before starting the async operation.
    loadingOverlay.show(context);

    // Simulate a 1-second network delay for the API call.
    await Future.delayed(const Duration(seconds: 1));

    // --- MOCK LOGIC ---
    // In a real app, you would check the result from the API call.
    // For now, we'll assume it's always successful.
    final bool isAuthenticated = true;

    if (isAuthenticated) {
      // If successful, call the onSuccess callback.
      onSuccess();
    // ignore: dead_code
    } else {
      // If the API returned a failure (e.g., wrong PIN), call onError.
      onError('Invalid PIN. Please try again.');
    }

  } catch (e) {
    // If an error/exception occurs, call the onError callback.
    onError('An unexpected error occurred: $e');

  } finally {
    // IMPORTANT: This block guarantees the overlay is always hidden
    // after the operation completes (either success or failure).
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

/// A generic function to save Mappable data to a specified endpoint.
Future<void> save<T extends Mappable>({
  required BuildContext context,
  required String dataUrl, // Now takes a dataUrl
  required T dataToSave,
  required Function() onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    // Call the generic postData method in the service
    await MockApiService.postData<T>(dataUrl, dataToSave);
    onSuccess();
  } catch (e) {
    onError(e.toString());
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}