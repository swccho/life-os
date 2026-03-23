/// Thrown when an API call fails with a user-facing message.
class ApiException implements Exception {
  ApiException(
    this.message, {
    this.statusCode,
    this.kind = ApiFailureKind.unknown,
  });

  final String message;
  final int? statusCode;
  final ApiFailureKind kind;

  factory ApiException.fromErrorBody(Map<String, dynamic> body) {
    final msg = body['message'] as String? ?? 'Request failed';
    final errors = body['errors'];
    String resolved = msg;
    if (errors is Map<String, dynamic> && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        final v = first.first;
        if (v is String && v.isNotEmpty) resolved = v;
      }
    }
    return ApiException(resolved, kind: ApiFailureKind.validation);
  }

  ApiException copyWith({
    String? message,
    int? statusCode,
    ApiFailureKind? kind,
  }) {
    return ApiException(
      message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      kind: kind ?? this.kind,
    );
  }

  @override
  String toString() => message;
}

enum ApiFailureKind {
  network,
  timeout,
  unauthorized,
  validation,
  conflict,
  server,
  unknown,
}
