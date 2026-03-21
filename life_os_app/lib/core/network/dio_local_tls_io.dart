import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Laragon / local HTTPS often uses certs that don't match IP (`10.0.2.2`) or
/// aren't in the device trust store. Accept only in debug for common local hosts.
void configureLocalDevTls(Dio dio) {
  if (kReleaseMode || kProfileMode) return;

  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return _isLocalDevHost(host);
      };
      return client;
    },
  );
}

bool _isLocalDevHost(String host) {
  if (host == 'life-os.test' ||
      host == 'localhost' ||
      host == '127.0.0.1' ||
      host == '10.0.2.2') {
    return true;
  }
  if (_isIpv4(host)) {
    return host.startsWith('192.168.') ||
        host.startsWith('10.') ||
        host.startsWith('172.');
  }
  return false;
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
