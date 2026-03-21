import '../../app/config/app_config.dart';

String resolveApiBaseUrl() {
  const fromEnv = String.fromEnvironment('LIFE_OS_API_BASE_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  return AppConfig.apiPublicBaseUrl;
}

Map<String, String> apiExtraHeaders() => const {};
