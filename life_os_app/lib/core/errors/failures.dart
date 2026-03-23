import '../network/api_exception.dart';

/// UI-oriented error description derived from API / network failures.
sealed class AppFailure {
  const AppFailure(this.userMessage);

  final String userMessage;

  factory AppFailure.fromObject(Object error) {
    if (error is ApiException) {
      return GenericFailure(error.message);
    }
    return GenericFailure('Something went wrong. Please try again.');
  }
}

final class GenericFailure extends AppFailure {
  const GenericFailure(super.userMessage);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.userMessage = 'Check your connection and try again.']);
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.userMessage = 'Please sign in again.']);
}
