import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

Future<void> inquire<T extends Mappable>({
  required BuildContext context,
  required String dataUrl,
  required Function(List<T> data) onSuccess,
  required Function(String errorMessage) onError,
  Map<String, dynamic>? filters,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    String url = dataUrl;
    if (filters != null && filters.isNotEmpty) {
      List<List<dynamic>> filterConditions = [];
      // filters.forEach((key, value) {
        
      //   filterConditions.add([
      //     key,
      //     '=',
      //     value,
      //   ]); // Assuming '=' operator only for now
      // });
            filters.forEach((key, value) {
        if (key.endsWith('_start')) {
          // For date_start, use original field name (e.g., 'date') and '>=' operator
          filterConditions.add([key.replaceFirst('_start', ''), '>=', value]);
        } else if (key.endsWith('_end')) {
          // For date_end, use original field name (e.g., 'date') and '<=' operator
          filterConditions.add([key.replaceFirst('_end', ''), '<=', value]);
        } else {
          // Default to '=' for other filters
          filterConditions.add([key, '=', value]);
        }
      });


      url += '?filters=${jsonEncode(filterConditions)}';
    }

    final List<T> data = await MockApiService.get<T>(url);
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
  required Function(Exception e)
  onError, // MODIFIED: Changed to accept Exception
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
      onError(UnauthorisedException('Authentication failed.'));
    }
  } catch (e) {
    if (e is Exception) {
      onError(e);
    } else {
      onError(Exception(e.toString()));
    }
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
  Function(T rawReceivedData)? onReceivedData, // Optional call back based on response (ex-print)
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    // Call the generic postData method in the service
    //await MockApiService.post(dataUrl, body: dataToSave);

        // MockApiService.post returns Future<dynamic>, so apiResponse will be dynamic.
    final dynamic apiResponse = await MockApiService.post(dataUrl, body: dataToSave); // Pass dataToSave directly

    // If onReceivedData callback is provided, we attempt to process the API response.
    if (onReceivedData != null) {
      T? dataForCallback;

    if (apiResponse is T) {
        dataForCallback = apiResponse;
      }
      if (dataForCallback != null) {
        onReceivedData(dataForCallback);
      } else {
        print('Warning: onReceivedData was provided, but API response could not be interpreted as Map<String, dynamic> or a Mappable object. Actual type: ${apiResponse.runtimeType}. Response: $apiResponse');
        // You might want to provide more specific error handling or logging here.
      }
    }
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
    final List<Screen> data = await MockApiService.get<Screen>(
      'api/screens/list',
    );
    return data;
  } catch (e) {
    throw Exception('Failed to load screens: $e');
  }
}
