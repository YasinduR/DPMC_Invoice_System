/// Exceptions
class AppException implements Exception {
  final String _message;
  final String _prefix;

  AppException(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix$_message";
  }

  String getMessage() => _message;

  
}


class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

// Invalid api request or network issue
class FetchDataException extends AppException {
  FetchDataException(String message)
      : super(message, "Error During Communication: ");
}