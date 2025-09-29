import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';

// Service for fetching cryptocurrency prices
class PriceService {
  static final Dio _dio = Dio();

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
      throw Exception('Error fetching prices: $e');
    }
  }
}
