import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config/app_config.dart';
import 'package:myapp/mappers/mappable.dart';
import 'package:myapp/mappers/mapper_registry.dart';
import 'package:myapp/errors/error_mapper.dart';
import 'package:myapp/errors/app_exceptions.dart';
import 'package:myapp/helpers/api_response_handler.dart';
import 'package:myapp/models/activity_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/local_storage_service.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/services/secure_storage_services.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiRequest {
  static Future<T> execute<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      throw ErrorMapper.fromError(e);
    }
  }
}

Future<List<T>> helperInquiry<T extends Mappable>(
  String url, {
  required Map<String, dynamic> body,
}) async {
  try {
    final uri = Uri.parse(url);

    final storage = SecureStorageService();
    final authToken = await storage.getAccessToken();

    if (authToken == null) {
      throw const UnauthorisedException('Please log in to continue');
    }

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15)); // 🔥 important

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw ErrorMapper.fromHttp(response, decoded);
    }

    if (decoded['success'] != true) {
      throw ApiException(
        decoded['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'];

    if (data is! List) {
      throw const ApiException('Invalid response format');
    }

    return data.map<T>((e) => MapperRegistry.fromMap<T>(e)).toList();
  } catch (e) {
    if (e is AppException) rethrow;
    throw ErrorMapper.fromError(e);
  }
}

// Future<List<T>> postList<T>({
//   required String endpoint,
//   required Map<String, dynamic> body,
//   required T Function(Map<String, dynamic>) fromJson,
// }) {

//   return ApiRequest.execute(() async {
//     final response = await http.post(
//       Uri.parse(endpoint),
//       body: jsonEncode(body),
//           headers: {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     },
//     );

//     final decoded = jsonDecode(response.body);

//     if (response.statusCode != 200) {
//       throw ErrorMapper.fromHttp(response, decoded);
//     }

//     if (decoded['success'] != true) {
//       throw ApiException(decoded['message'] ?? 'Request failed');
//     }

//     return (decoded['data'] as List)
//         .map((e) => fromJson(e))
//         .toList();
//   });
// }

// Future<List<T>> helperInquiry<T extends Mappable>(
//   String url, {
//   required Map<String, dynamic> body,
//   String? authToken,
// }) async {
//   final uri = Uri.parse(url);
//   final response = await http.post(
//     uri,
//     headers: {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     },
//     body: jsonEncode(body),
//   );

//   final decoded = jsonDecode(response.body);

//   if (decoded['success'] == true) {
//   //  final List data = decoded['data'] ?? [];
//   //List<T> dataList = data.map<T>((e) => e.fromMap<T>(e)).toList();
//   // List<T> dataList = data.map<T>((e) => fromMap(e as Map<String, dynamic>)).toList();
//     // List<T> dataList = parseApiResponse<List<T>>(decoded, (
//     //   rawData,
//     // ) {
//     //   final list = rawData as List<dynamic>;
//     //   return list.map((item) => T.fromJson(item)).toList();
//     // });

//   List<T> data = (decoded['data'] as List).map<T>((e) => MapperRegistry.fromMap<T>(e)).toList();

//     return data;
//   } else {
//     // throw Exception(
//     //   decoded['message'] ??
//     //       decoded['errors']?.toString() ??
//     //       'Failed to load data',
//     // );
//     throw Exception(
//       '❌ API ERROR\n'
//       'URL: $url\n'
//       'BODY: ${jsonEncode(body)}\n'
//       'STATUS: ${response.statusCode}\n'
//       'MESSAGE: ${decoded['message'] ?? decoded['errors'] ?? 'Unknown error'}',
//     );

//   }
// }

// Future<List<T>> helperInquiry<T extends Mappable>(
//   String url, {
//   required Map<String, dynamic> body,
//   String? authToken,
// }) async {
//   final uri = Uri.parse(url);

//   final response = await http.post(
//     uri,
//     headers: {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     },
//     body: jsonEncode(body),
//   );

//   final decoded = jsonDecode(response.body);

//   if (decoded['success'] == true) {
//   //  final List data = decoded['data'] ?? [];
//   //List<T> dataList = data.map<T>((e) => e.fromMap<T>(e)).toList();
//   // List<T> dataList = data.map<T>((e) => fromMap(e as Map<String, dynamic>)).toList();
//     // List<T> dataList = parseApiResponse<List<T>>(decoded, (
//     //   rawData,
//     // ) {
//     //   final list = rawData as List<dynamic>;
//     //   return list.map((item) => T.fromJson(item)).toList();
//     // });

//   List<T> data = (decoded['data'] as List).map<T>((e) => MapperRegistry.fromMap<T>(e)).toList();

//     return data;
//   } else {
//     // throw Exception(
//     //   decoded['message'] ??
//     //       decoded['errors']?.toString() ??
//     //       'Failed to load data',
//     // );
//     throw Exception(
//       '❌ API ERROR\n'
//       'URL: $url\n'
//       'BODY: ${jsonEncode(body)}\n'
//       'STATUS: ${response.statusCode}\n'
//       'MESSAGE: ${decoded['message'] ?? decoded['errors'] ?? 'Unknown error'}',
//     );

//   }
// }
Future<void> inquireN({
  required BuildContext context,
  required String dataUrl,
  required Map<String, dynamic> body,
  //required Function(List<dynamic> data) onSuccess,
  required Function(dynamic rawData) onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();

  try {
    loadingOverlay.show(context);

    String baseUrl = Config.baseApiTestUrl;
    String url = '$baseUrl$dataUrl';
    final uri = Uri.parse(url);

    final SecureStorageService secureStorageService = SecureStorageService();
    final String? authToken = await secureStorageService.getAccessToken();

    if (authToken == null) {
      throw UnauthorisedException('Please log in to access this data.');
    }

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      onError(ErrorMapper.fromHttp(response, decoded).toString());
      return;
    }
    if (decoded['success'] == true) {
      if ((decoded['data']) == null) {
        onError('No data found');
      } else {
        onSuccess(decoded['data']);
      }
    } else {
      onError(decoded['message'] ?? 'Unknown error');
    }
  } catch (e) {
    String errorMsg = ErrorMapper.fromError(e).toString();
    onError('Failed to load data: $errorMsg');
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}

// Future<void> inquireN<T extends Mappable>({
//   required BuildContext context,
//   required String dataUrl,
//   required Map<String, dynamic> body,
//   required Function(List<T> data) onSuccess,
//   required Function(String errorMessage) onError,
//   //Map<String, dynamic>? filters,
// }) async {
//   final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
//   //if (!context.mounted) return;

//   try {
//     loadingOverlay.show(context);
//     String baseUrl = Config.baseApiTestUrl;
//     String url = '${baseUrl}$dataUrl';
//     //String url = dataUrl;
//     final uri = Uri.parse(url);

//     final SecureStorageService _secureStorageService = SecureStorageService(); // Instantiate SecureStorageService
//     final String? authToken = await _secureStorageService.getAccessToken();

//     if (authToken == null) {
//       print('Error: No access token found. User is not authenticated.');
//       throw UnauthorisedException('Please log in to access this data.');
//     }

//   final response = await http.post(
//     uri,
//     headers: {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     },
//     body: jsonEncode(body),
//   );

//     //final List<T> data = await MockApiService.get<T>(url);
//     onSuccess(data);
//   } catch (e) {
//     onError('Failed to load data: $e');
//   } finally {
//     if (loadingOverlay.isShowing) {
//       loadingOverlay.hide();
//     }
//   }
// }

// OLD INQUIRE WORK WITH MOCK API
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
        } else if (key.endsWith('_in')) {
          // New: handle 'in' operator
          filterConditions.add([key.replaceFirst('_in', ''), 'in', value]);
        } else {
          // Default to '=' for other filters
          filterConditions.add([key, '=', value]);
        }
      });

      url += '?filters=${jsonEncode(filterConditions)}';
    }
    final SecureStorageService _secureStorageService =
        SecureStorageService(); // Instantiate SecureStorageService
    final String? accessToken = await _secureStorageService.getAccessToken();

    if (accessToken == null) {
      print('Error: No access token found. User is not authenticated.');
      throw UnauthorisedException('Please log in to access this data.');
    }
    //  Genarailze this later and remove mockapi call
    //     final jsonResponse = await //;
    // List<Bank> banks = parseApiResponse<List<Bank>>(jsonResponse, (
    //   rawData,
    // ) {
    //   final list = rawData as List<dynamic>;
    //   sourceData = DummyData.banks;
    //   return list.map((item) => Bank.fromJson(item)).toList();
    // });
    // data = banks;
    //
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
  required Function(Exception e) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  if (!context.mounted) return;

  try {
    loadingOverlay.show(context);
    String baseUrl = Config.baseApiTestUrl;
    String url = '${baseUrl}dealer/login';

    final uri = Uri.parse(url);
    final storage = SecureStorageService();
    final authToken = await storage.getAccessToken();

    if (authToken == null) {
      throw const UnauthorisedException('Please log in to continue');
    }

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode({'dealerCode': dealerCode, 'pin': pin}),
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      //throw ErrorMapper.fromHttp(response, decoded);
      onError(ErrorMapper.fromHttp(response, decoded));
      return;
    }

    final bool isAuthenticated = decoded['success'] == true;

    // final SecureStorageService _secureStorageService =
    //     SecureStorageService(); // Instantiate SecureStorageService
    // final String? accessToken = await _secureStorageService.getAccessToken();

    // final bool isAuthenticated =
    //     await MockApiService.post(
    //           url,
    //           body: {'dealerCode': dealerCode, 'pin': pin},
    //           accessToken: accessToken,
    //         )
    //         as bool;

    if (isAuthenticated) {
      onSuccess();
    } else {
      onError(UnauthorisedException('Authentication failed.'));
    }
  } catch (e) {
    onError(ErrorMapper.fromError(e));

    // if (e is Exception) {
    //   ErrorMapper.fromError(e);
    //   onError(e);
    // } else {
    //   onError(Exception(e.toString()));
    // }
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
  Function(T rawReceivedData)?
  onReceivedData, // Optional call back based on response (ex-print)
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();
  final LocalStorageService localStorageService = LocalStorageService();
  if (!context.mounted) return;
  try {
    loadingOverlay.show(context);
    String baseUrl = Config.baseUrl;
    String url = '${baseUrl}$dataUrl';
    final SecureStorageService _secureStorageService =
        SecureStorageService(); // Instantiate SecureStorageService
    final String? accessToken = await _secureStorageService.getAccessToken();
    final dynamic apiResponse = await MockApiService.post(
      url,
      body: dataToSave,
      accessToken: accessToken,
    ); // Pass dataToSave directly
    // If onReceivedData callback is provided, we attempt to process the API response.
    if (onReceivedData != null) {
      T? dataForCallback;

      if (apiResponse is T) {
        dataForCallback = apiResponse;
      }
      if (dataForCallback != null) {
        onReceivedData(dataForCallback);
      } else {
        print(
          'Warning: onReceivedData was provided, but API response could not be interpreted as Map<String, dynamic> or a Mappable object. Actual type: ${apiResponse.runtimeType}. Response: $apiResponse',
        );
        // You might want to provide more specific error handling or logging here.
      }
    }
    onSuccess();

    await localStorageService.saveActivity(
      Activity(
        id: const Uuid().v4(),
        user: user?.id,
        title: "Successfully Saved",
        endpoint: dataUrl,
        timestamp: DateTime.now(),
        type: activityType,
        status: StatusType.success,
        metadata: {"data": dataToSave.toMap()},
      ),
    );
  } catch (e) {
    onError(e.toString());
    await localStorageService.saveActivity(
      Activity(
        id: const Uuid().v4(),
        user: user?.id,
        title: "Error Occured",
        endpoint: dataUrl,
        timestamp: DateTime.now(),
        type: activityType,
        status: StatusType.failed,
        metadata: {"data": dataToSave.toMap()},
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
    final SecureStorageService _secureStorageService =
        SecureStorageService(); // Instantiate SecureStorageService
    final String? accessToken = await _secureStorageService.getAccessToken();

    final bool hasPermission =
        await MockApiService.post(
              '${baseUrl}permission/check',
              body: {'screenId': screenId, 'roleIds': roleIds},
              accessToken: accessToken,
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

Future<void> fetchImage({
  required BuildContext context,
  String? ftpPath,
  required String imagePath, // later FTP path
  required Function(File? file) onSuccess,
  required Function(String errorMessage) onError,
}) async {
  final AppLoadingOverlay loadingOverlay = AppLoadingOverlay();

  try {
    loadingOverlay.show(context);

    await Future.delayed(const Duration(seconds: 2));

    final String basePath = ftpPath ?? Config.baseFtp;
    final String fullPath = '$basePath$imagePath';
    final file = File(fullPath);

    if (await file.exists()) {
      onSuccess(file);
    } else {
      throw Exception("Image not found");
    }
  } catch (e) {
    onError('Failed to load image: $e');
  } finally {
    if (loadingOverlay.isShowing) {
      loadingOverlay.hide();
    }
  }
}
