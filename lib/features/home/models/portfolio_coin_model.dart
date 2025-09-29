import '../../../core/constants/app_enums.dart';

class PortfolioCoinModel {
  final String id;
  final String symbol;
  final String name;
  final double quantity;
  final double? currentPrice;
  final double? totalValue;
  final DateTime? lastUpdated;
  final PriceUpdateStatus priceUpdateStatus;

  PortfolioCoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    this.currentPrice,
    this.totalValue,
    this.lastUpdated,
    this.priceUpdateStatus = PriceUpdateStatus.idle,
  });

  /// Create a copy with updated price information
  PortfolioCoinModel copyWith({
    String? id,
    String? symbol,
    String? name,
    double? quantity,
    double? currentPrice,
    double? totalValue,
    DateTime? lastUpdated,
    PriceUpdateStatus? priceUpdateStatus,
  }) {
    return PortfolioCoinModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      currentPrice: currentPrice ?? this.currentPrice,
      totalValue: totalValue ?? this.totalValue,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      priceUpdateStatus: priceUpdateStatus ?? this.priceUpdateStatus,
    );
  }

  /// Calculate total value based on current price and quantity
  PortfolioCoinModel withPrice(
    double price,
    PriceUpdateStatus priceUpdateStatus,
  ) {
    return copyWith(
      currentPrice: price,
      totalValue: quantity * price,
      lastUpdated: DateTime.now(),
      priceUpdateStatus: priceUpdateStatus,
    );
  }

  factory PortfolioCoinModel.fromJson(Map<String, dynamic> json) {
    return PortfolioCoinModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      currentPrice: json['currentPrice']?.toDouble(),
      totalValue: json['totalValue']?.toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'currentPrice': currentPrice,
      'totalValue': totalValue,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Get formatted total value
  String get formattedTotalValue {
    if (totalValue == null) return 'N/A';
    return '\$${totalValue!.toStringAsFixed(2)}';
  }

  /// Get formatted current price
  String get formattedCurrentPrice {
    if (currentPrice == null) return 'N/A';
    return '\$${currentPrice!.toStringAsFixed(2)}';
  }
}
