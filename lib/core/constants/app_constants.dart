/// Application-wide constants for the Parameter Manager System
///
/// This file contains all static configuration values used throughout the app,
/// following the specification requirements for the heating system parameter management.

class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // 🌐 API Configuration
  static const String apiBaseUrl = 'https://api.parameter-manager.com';
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
}
