class ApiException implements Exception {
  final _message;
  final _prefix;
  ApiException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String message])
      : super(message, "Error in Data Fetching: ");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "Bad Client Request: ");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}
