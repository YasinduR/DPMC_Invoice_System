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