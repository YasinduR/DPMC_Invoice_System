import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/services/secure_storage_services.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> inquire<T extends Mappable>({
  required BuildContext context,
  required String dataUrl,
  required Function(List<T> data) onSuccess,
  required Function(String errorMessage) onError,
  Map<String, dynamic>? filters,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  //if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
          String baseUrl = Config.baseUrl;
      String url = '${baseUrl}$dataUrl';
    //String url = dataUrl;
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
      final SecureStorageService _secureStorageService = SecureStorageService(); // Instantiate SecureStorageService

      final String? accessToken = await _secureStorageService.getAccessToken(); 

      if (accessToken == null) {
        print('Error: No access token found. User is not authenticated.');
        throw UnauthorisedException('Please log in to access this data.');
      }

       final List<T> data = await MockApiService.get<T>(
        url,
        authToken: accessToken, // Pass the retrieved access token
      );

    //final List<T> data = await MockApiService.get<T>(url);
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
      String baseUrl = Config.baseUrl;
      String url = '${baseUrl}dealer/login';
      final SecureStorageService _secureStorageService = SecureStorageService(); // Instantiate SecureStorageService
      final String? accessToken = await _secureStorageService.getAccessToken(); 

    final bool isAuthenticated =
        await MockApiService.post(
              url,
              body: {'dealerCode': dealerCode, 'pin': pin},
              accessToken: accessToken
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
  required ActivityType activityType,
  User? user,
  Function(T rawReceivedData)? onReceivedData, // Optional call back based on response (ex-print)
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  final LocalStorageService localStorageService =  LocalStorageService();


  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
 
      String baseUrl = Config.baseUrl;
      String url = '${baseUrl}$dataUrl';
      final SecureStorageService _secureStorageService = SecureStorageService(); // Instantiate SecureStorageService
      final String? accessToken = await _secureStorageService.getAccessToken(); 
    // Call the generic postData method in the service
    //await MockApiService.post(dataUrl, body: dataToSave);

        // MockApiService.post returns Future<dynamic>, so apiResponse will be dynamic.
    final dynamic apiResponse = await MockApiService.post(url, body: dataToSave,accessToken: accessToken); // Pass dataToSave directly

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

    await localStorageService.saveActivity(
      Activity(
        id: const Uuid().v4(),
        title: "Successfully Saved",
        endpoint: dataUrl,
        timestamp: DateTime.now(),
        type: activityType,
        status: StatusType.success,
        metadata: {
          "data": dataToSave.toMap()
        },
      ),
    );

  } catch (e) {
    onError(e.toString());
    await localStorageService.saveActivity(
      Activity(
        id: const Uuid().v4(),
        title: "Error Occured",
        endpoint: dataUrl,
        timestamp: DateTime.now(),
        type: activityType,
        status: StatusType.failed,
        metadata: {
          "data": dataToSave.toMap()
        },
      ),
    );

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
    String baseUrl = Config.baseUrl;
    final SecureStorageService _secureStorageService = SecureStorageService(); // Instantiate SecureStorageService
    final String? accessToken = await _secureStorageService.getAccessToken(); 

    final bool hasPermission =
        await MockApiService.post(
              '${baseUrl}permission/check',
              body: {'screenId': screenId, 'roleIds': roleIds},
              accessToken: accessToken
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
      // final String? accessToken = await _secureStorageService.getAccessToken();

      // if (accessToken == null) {
      //   // Handle case where no token is found (e.g., user not logged in)
      //   print('Error: No access token found. User is not authenticated.');
      //   // You might want to navigate to a login screen or show an error message
      //   throw UnauthorisedException('Please log in to access this data.');
      // }

      // final List<Screen> data = await MockApiService.get<Screen>(
      //   'api/screens/list',
      //   authToken: accessToken, // Pass the retrieved access token
      // );
    String baseUrl = Config.baseUrl;
    final List<Screen> data = await MockApiService.get<Screen>(
      '${baseUrl}screens/list',
    );
    return data;
  } catch (e) {
    throw Exception('Failed to load screens: $e');
  }
}
