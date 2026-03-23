import 'api_exception.dart';

/// Laravel `{ success, message, data, meta? }` envelope.
abstract final class ApiResponseParser {
  static void ensureSuccess(Map<String, dynamic> body) {
    final success = body['success'] as bool?;
    if (success == false) {
      throw ApiException.fromErrorBody(body);
    }
  }

  static PageMeta? parseMeta(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final current = raw['current_page'];
    final last = raw['last_page'];
    final per = raw['per_page'];
    final total = raw['total'];
    if (current is! num ||
        last is! num ||
        per is! num ||
        total is! num) {
      return null;
    }
    return PageMeta(
      currentPage: current.toInt(),
      lastPage: last.toInt(),
      perPage: per.toInt(),
      total: total.toInt(),
    );
  }
}

class PageMeta {
  const PageMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
}
