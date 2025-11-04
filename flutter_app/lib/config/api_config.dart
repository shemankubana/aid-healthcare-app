// lib/config/api_config.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const int _port = 8000;

  // Automatically detect correct host based on platform
  static String getHost() {
    if (kIsWeb) return 'localhost'; // For Flutter web
    try {
      if (Platform.isAndroid) return '10.0.2.2'; // Android Emulator
      if (Platform.isIOS) return '127.0.0.1';   // iOS Simulator
      // Other platforms (desktop, etc.)
      return '127.0.0.1';
    } catch (e) {
      return '127.0.0.1';
    }
  }

  static String get baseUrl => 'http://${getHost()}:$_port/api';
}
