/// App-wide API configuration for the LifeOS Laravel backend.
///
/// Default target is **production**. For local development, run with:
/// `flutter run --dart-define=LIFE_OS_API_BASE_URL=https://your-local-host/api`
abstract final class AppConfig {
  /// Public API base (Dio [BaseOptions.baseUrl]); includes `/api` prefix.
  static const String apiPublicBaseUrl = 'https://life.os.thethemeai.com/api';

  /// HTTP `Host` header when the request URL uses an IP (e.g. Android emulator
  /// `10.0.2.2` or a LAN IP) so the server still routes to this vhost.
  static const String apiVirtualHost = 'life.os.thethemeai.com';

  /// When true, feature repositories may use local mock data instead of the API.
  static const bool useMockData = bool.fromEnvironment(
    'LIFE_OS_USE_MOCK_DATA',
    defaultValue: false,
  );
}
