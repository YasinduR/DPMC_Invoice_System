/// Exceptions
/// NEW Exception Types are currently used in only login page other types of exceptions later and used them too
/// or Remove this and Go with Default Exception
// class AppException implements Exception {
//   final String _message;
//   final String _prefix;

//   AppException(this._message, this._prefix);

//   @override
//   String toString() {
//     return "$_prefix$_message";
//   }

//   String getMessage() => _message;
// }

// // Invalid Login Credential
// class UnauthorisedException extends AppException {
//   UnauthorisedException(String message) : super(message, "Unauthorised: ");
// }

// // Exception Type: Account Locked (used in dealer selection)
// class AccountLockedException extends AppException {
//   AccountLockedException(String message) : super(message, "Account Locked: ");
// }

// // Invalid api request or network issue
// class FetchDataException extends AppException {
//   FetchDataException(String message)
//     : super(message, "Error During Communication: ");
// }

// // class FetchLocationException extends AppException {
// //   FetchLocationException(String message) : super(message, "Location Not Found: ");
// // }

// class FetchLocationException extends AppException {
//   const FetchLocationException([
//     String message = 'Location not found',
//   ]) : super(message, prefix: 'LOCATION: ');
// }

abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});
 // String get getMessage => message;

  @override
  String toString() => message;

}


class NetworkException extends AppException {
  const NetworkException() : super('No internet connection');
}

class TimeoutException extends AppException {
  const TimeoutException() : super('Request timed out');
}

// class UnauthorisedException extends AppException {
//   const UnauthorisedException(String s)
//       : super('Session expired. Please login again', statusCode: 401);
// }

class UnauthorisedException extends AppException {
  const UnauthorisedException([String? message])
      : super(
          message ?? 'Session expired. Please login again',
          statusCode: 401,
        );
}

class AccountLockedException extends AppException {
    const AccountLockedException([String? message])
      : super(
          message ?? 'This account is locked. Please contact support.',
          statusCode: 423,
        );
}

class ForbiddenException extends AppException {
  const ForbiddenException()
      : super('Access denied', statusCode: 403);
}

class ServerException extends AppException {
  const ServerException()
      : super('Server error. Please try later', statusCode: 500);
}

class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode});
}

class NotFoundException extends AppException {
  const NotFoundException() : super('Resource not found', statusCode: 404);
}
class MethodNotAllowedException extends AppException {
  const MethodNotAllowedException()
      : super('Method not allowed', statusCode: 405);
}


class ValidationException extends AppException {
  const ValidationException(String message)
      : super(message, statusCode: 422);
}

class FetchDataException extends AppException {
  const FetchDataException([
    String message = 'Error communicating with server',
  ]) : super(message);
}

class FetchLocationException extends AppException {
  const FetchLocationException([
    String message = 'Location not found',
  ]) : super(message);
}
