import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';

// Service for fetching cryptocurrency prices
class PriceService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// Fetch current prices for multiple coins
  static Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) return {};

    try {
      final response = await _dio.get(
        ApiEndpoints.coinPrice,
        queryParameters: {'ids': coinIds.join(','), 'vs_currencies': 'usd'},
      );

      if (response.statusCode == HttpStatusCodes.ok) {
        final Map<String, dynamic> data = response.data;
        final Map<String, double> prices = {};

        data.forEach((coinId, coinData) {
          if (coinData is Map<String, dynamic> && coinData['usd'] != null) {
            prices[coinId] = (coinData['usd'] as num).toDouble();
          }
        });

        return prices;
      } else {
        throw Exception('Failed to fetch prices: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception(
              'Connection timeout. Please check your internet connection.',
            );
          case DioExceptionType.sendTimeout:
            throw Exception('Request timeout. Please try again.');
          case DioExceptionType.receiveTimeout:
            throw Exception('Response timeout. Please try again.');
          case DioExceptionType.badResponse:
            throw Exception('Server error: ${e.response?.statusCode}');
          case DioExceptionType.cancel:
            throw Exception('Request cancelled');
          case DioExceptionType.connectionError:
            throw Exception(
              'No internet connection. Please check your network.',
            );
          default:
            throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Error fetching prices: $e');
    }
  }
}
