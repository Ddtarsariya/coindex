/// API endpoints configuration
class ApiEndpoints {
  ApiEndpoints._();

  // Base API configuration
  static const String apiVersion = 'v3';
  static const String baseApiUrl = 'https://api.coingecko.com/api';
  static const String baseApiPath = '$baseApiUrl/$apiVersion';

  // coins endpoints
  static const String coins = '$baseApiPath/coins/list';
  static const String coinPrice = '$baseApiPath/simple/price';
}

// HTTP status codes commonly used in the API
class HttpStatusCodes {
  HttpStatusCodes._();

  // Success
  static const int ok = 200;
}
