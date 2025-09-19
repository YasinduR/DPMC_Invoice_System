import 'package:flutter/material.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

// API Calls with Generic Types

Future<void> inquire<T extends Mappable>({
  required BuildContext context,
  required String dataUrl,
  required Function(List<T> data) onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    final List<T> data = await MockApiService.get<T>(dataUrl);
    onSuccess(data);
  } catch (e) {
    onError('Failed to load data: $e');
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

Future<void> dealerLogin({
  required BuildContext context,
  required String dealerCode,
  required String pin,
  required VoidCallback onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    final bool isAuthenticated =
        await MockApiService.post(
              'api/dealer/login',
              body: {'dealerCode': dealerCode, 'pin': pin},
            )
            as bool;

    if (isAuthenticated) {
      onSuccess();
    } else {
      onError('Authentication failed.');
    }
  } catch (e) {
    onError(e.toString());
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

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
    await MockApiService.post(dataUrl, body: dataToSave);
    onSuccess();
  } catch (e) {
    onError(e.toString());
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}


Future<void> checkScreenPermission({
  required BuildContext context,
  required String screenId,
  required List<String> roleIds,
  required VoidCallback onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    final bool hasPermission =
        await MockApiService.post(
              'api/permission/check',
              body: {'screenId': screenId, 'roleIds': roleIds},
            )
            as bool;

    if (hasPermission) {
      onSuccess();
    } else {
      onError('Access Denied: You do not have permission to view this screen.');
    }
  } catch (e) {
    onError(e.toString());
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

// THIS IS TO COLLECT ALL SCREEN INFO ON APP ROUTE INITIALIZING //
Future<List<Screen>> loadScreens() async {
  try {
    final List<Screen> data = await MockApiService.get<Screen>('api/screens/list');
    return data;
  } catch (e) {
    throw Exception('Failed to load screens: $e');
  }
}