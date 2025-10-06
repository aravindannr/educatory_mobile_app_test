import 'package:equatable/equatable.dart';

/// Base Failure class (used in repositories)
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server Failure
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Authentication Failure
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Validation Failure
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Timeout Failure
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Not Found Failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Unauthorized Failure
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Forbidden Failure
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Access forbidden']);
}
