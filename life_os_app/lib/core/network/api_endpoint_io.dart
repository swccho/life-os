import 'dart:io';

import '../../app/config/app_config.dart';

String resolveApiBaseUrl() {
  const fromEnv = String.fromEnvironment('LIFE_OS_API_BASE_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  return AppConfig.apiPublicBaseUrl;
}

/// When the URL host is an IP, send [AppConfig.apiVirtualHost] as `Host` so
/// virtual-host routing (e.g. Laragon) still matches production hostname.
Map<String, String> apiExtraHeaders() {
  if (!Platform.isAndroid) return const {};
  final uri = Uri.parse(resolveApiBaseUrl());
  final host = uri.host;
  final useVhost = host == '10.0.2.2' || _isIpv4(host);
  if (useVhost) {
    return {'Host': AppConfig.apiVirtualHost};
  }
  return const {};
}

bool _isIpv4(String host) {
  final parts = host.split('.');
  if (parts.length != 4) return false;
  for (final p in parts) {
    final n = int.tryParse(p);
    if (n == null || n < 0 || n > 255) return false;
  }
  return true;
}
