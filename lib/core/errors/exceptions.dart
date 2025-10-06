/// Base Exception class
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Server Exception - thrown when API returns an error
class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred']);
}

/// Cache Exception - thrown when local storage fails
class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred']);
}

/// Network Exception - thrown when there's no internet connection
class NetworkException extends AppException {
  NetworkException([super.message = 'No internet connection']);
}

/// Authentication Exception - thrown when auth fails
class AuthException extends AppException {
  AuthException([super.message = 'Authentication failed']);
}

/// Validation Exception - thrown when input validation fails
class ValidationException extends AppException {
  ValidationException([super.message = 'Validation failed']);
}

/// Timeout Exception - thrown when request times out
class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timeout']);
}

/// Not Found Exception - thrown when resource is not found
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found']);
}

/// Unauthorized Exception - thrown when user is not authorized
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized access']);
}

/// Forbidden Exception - thrown when access is forbidden
class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'Access forbidden']);
}
