import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/config/app_config.dart';
import 'package:myapp/errors/app_exceptions.dart';
import 'package:myapp/errors/error_mapper.dart';
import 'package:myapp/mappers/mappable.dart';
import 'package:myapp/mappers/mapper_registry.dart';
import 'package:myapp/models/login_response_model.dart';
import 'package:myapp/models/security_qna_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/api_logger.dart';
import 'package:myapp/services/secure_storage_services.dart';

class ApiService {
  final SecureStorageService _storage = SecureStorageService();

  // -----------------------------------
  // BASE CONFIG
  // -----------------------------------
  final String baseUrl = Config.baseApiTestUrl;

  Uri _buildUri(String path) => Uri.parse('$baseUrl$path');

  // -----------------------------------
  // ENDPOINTS
  // -----------------------------------
  static const String loginUrl = 'user/login';
  static const String changePasswordUrl = 'user/changepassword';
  static const String requestPasswordResetUrl = 'user/request-password-reset';
  static const String resetPasswordUrl = 'user/reset-password';
  static const String setPasswordUrl = 'user/set-password';
  static const String renewPasswordUrl = 'user/renew-password';
  static const String verifyOtpUrl = 'user/verify-otp';
  static const String refreshTokenUrl = 'user/refresh-token';

  // -----------------------------------
  // CORE REQUEST METHODS
  // -----------------------------------

  Future<Map<String, dynamic>> _post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final uri = _buildUri(url);
    final token = await _storage.getAccessToken();

    final logFile = await ApiLogger.logRequest(
      url: uri.toString(),
      body: body,
    );

    if (token == null) {
      throw const UnauthorisedException('Please log in to continue');
    }

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    await ApiLogger.logResponse(
      file: logFile,
      statusCode: response.statusCode,
      response: response.body,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _postPublic(
    String url,
    Map<String, dynamic> body,
  ) async {
    final uri = _buildUri(url);

    final logFile = await ApiLogger.logRequest(
      url: uri.toString(),
      body: body,
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    await ApiLogger.logResponse(
      file: logFile,
      statusCode: response.statusCode,
      response: response.body,
    );

    return _handleResponse(response);
  }

  // -----------------------------------
  // RESPONSE HANDLER (COMMON LOGIC)
  // -----------------------------------
  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Invalid server response');
    }

    if (response.statusCode != 200) {
      throw ErrorMapper.fromHttp(response, decoded);
    }

    if (decoded['success'] != true) {
      throw ApiException(
        decoded['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }

  // -----------------------------------
  // GENERIC FETCH METHODS
  // -----------------------------------

  Future<List<T>> fetchList<T extends Mappable>({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final decoded = await _post(url, body);
    final data = decoded['data'];

    if (data is! List) {
      throw const ApiException('Expected list response');
    }

    return data
        .map<T>((e) => MapperRegistry.fromMap<T>(e))
        .toList();
  }

  Future<Map<String, dynamic>> fetchData({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final decoded = await _post(url, body);
    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Expected object response');
    }

    return data;
  }

  // -----------------------------------
  // AUTH METHODS
  // -----------------------------------

  Future<LoginResponse> login({
    required String username,
    required String password,
    String mode = '',
  }) async {
    final decoded = await _postPublic(loginUrl, {
      'username': username,
      'password': password,
      'mode': mode,
    });

    final data = decoded['data'] as Map<String, dynamic>;
    return LoginResponse.fromMap(data);
  }

  Future<Map<String, String>> refreshToken(String refreshToken) async {
    final decoded = await _postPublic(refreshTokenUrl, {
      'refreshToken': refreshToken,
    });

    final data = decoded['data'] as Map<String, dynamic>;

    return {
      'accessToken': data['accessToken'] as String,
      'refreshToken': data['refreshToken'] as String,
    };
  }

  Future<void> changePassword({
  required String username,
  required String oldPassword,
  required String newPassword,
}) async {
  await _post(changePasswordUrl, {
    'username': username,
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  });
}

Future<String> requestPasswordReset({
  required String username,
}) async {
  final decoded = await _post(requestPasswordResetUrl, {
    'username': username,
  });

  return decoded['message'] as String;
}

Future<bool> resetPassword({
  required String username,
  required String token,
  required String newPassword,
}) async {
  final decoded = await _post(resetPasswordUrl, {
    'username': username,
    'token': token,
    'newPassword': newPassword,
  });

  // depends on backend
  return decoded['success'] ?? true;
}

Future<User> setPassword({
  required String username,
  required String newPassword,
  required SecurityQuestionAnswer securityQandA,
}) async {
  final decoded = await _post(setPasswordUrl, {
    'username': username,
    'newPassword': newPassword,
    'securityQuestion': securityQandA.question,
    'securityAnswer': securityQandA.answer,
  });

  final data = decoded['data'] as Map<String, dynamic>;
  return MapperRegistry.fromMap<User>(data);
}

Future<User> renewPassword({
  required String username,
  required String newPassword,
}) async {
  final decoded = await _post(renewPasswordUrl, {
    'username': username,
    'newPassword': newPassword,
  });

  final data = decoded['data'] as Map<String, dynamic>;
  return MapperRegistry.fromMap<User>(data);
}

Future<String> verifyOtp({
  required String username,
  required String token,
}) async {
  final decoded = await _post(verifyOtpUrl, {
    'username': username,
    'token': token,
  });

  return decoded['message'] as String;
}

Future<bool> hasScreenPermission({
  required String userId,
  required String screenId,
}) async {
  final decoded = await _post('user/has-permission', {
    'userId': userId,
    'screenId': screenId,
  });

  final data = decoded['data'];

  if (data is! Map<String, dynamic>) {
    throw const ApiException('Expected object response for permission');
  }

  final hasPermission = data['hasPermission'];

  if (hasPermission is! bool) {
    throw const ApiException(
      'Invalid permission response type',
    );
  }

  return hasPermission;
}



  // -----------------------------------
  // DEALER METHODS
  // -----------------------------------

  Future<void> dealerLogin({
    required String dealerCode,
    required String pin,
  }) async {
    await _post('dealer/login', {
      'dealerCode': dealerCode,
      'pin': pin,
    });
  }
}
