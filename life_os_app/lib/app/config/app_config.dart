/// App-wide API configuration for Laravel (Laragon / Valet).
///
/// **Android emulator:** The app resolves the API via [apiPublicBaseUrl] on most
/// platforms, but on Android it uses `https://10.0.2.2/api` plus a `Host` header
/// so Laragon still routes to `life-os.test` (see [apiVirtualHost]).
///
/// **Physical Android device:** run with
/// `flutter run --dart-define=LIFE_OS_API_BASE_URL=https://YOUR_LAN_IP/api`
/// (same `Host` header is added when the URL host is an IPv4 address).
abstract final class AppConfig {
  /// URL when the OS resolves `life-os.test` (desktop, iOS simulator, browser).
  static const String apiPublicBaseUrl = 'https://life-os.test/api';

  /// Virtual host name Laragon uses for this project (SNI / HTTP Host).
  static const String apiVirtualHost = 'life-os.test';
}
