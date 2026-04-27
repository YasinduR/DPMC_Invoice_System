import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:myapp/errors/app_exceptions.dart';

class ErrorMapper {
  static AppException fromHttp(
    http.Response response,
    dynamic decoded,
  ) {
    final code = response.statusCode;

    switch (code) {
      case 400:
        return ValidationException(decoded['message'] ?? 'Bad request');

      case 401:
        return UnauthorisedException(decoded['message'] ?? 'Session expired. Please login again');

      case 403:
        return const ForbiddenException();

      case 404:
        return const NotFoundException();
      
      case 405:
        return const MethodNotAllowedException();
      
      case 423:
        return const AccountLockedException();

      case 422:
        return ValidationException(decoded['message'] ?? 'Validation failed');

      case 500:
      case 502:
      case 503:
        return const ServerException();

      default:
        return ApiException(
          decoded['message'] ?? 'Unexpected error',
          statusCode: code,
        );
    }
  }

  static AppException fromError(Object error) {
    if (error is SocketException) return const NetworkException();
    if (error is TimeoutException) return const TimeoutException();
    
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('socketexception') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('network is unreachable')) {
      return const NetworkException();
    }
    if (error is AppException) return error;
    return ApiException(error.toString());
  }
}