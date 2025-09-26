/// Exceptions
/// NEW Exception Types are currently used in only login page other types of exceptions later and used them too
/// or Remove this and Go with Default Exception
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

// Invalid Login Credential
class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

// Exception Type: Account Locked (used in dealer selection)
class AccountLockedException extends AppException {
  AccountLockedException(String message) : super(message, "Account Locked: ");
}

// Invalid api request or network issue
class FetchDataException extends AppException {
  FetchDataException(String message)
    : super(message, "Error During Communication: ");
}
