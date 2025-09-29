import '../../features/home/models/portfolio_coin_model.dart';

class CoinsModel {
  final String id;
  final String symbol;
  final String name;

  CoinsModel({required this.id, required this.symbol, required this.name});

  factory CoinsModel.fromJson(Map<String, dynamic> json) {
    return CoinsModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'symbol': symbol, 'name': name};
  }

  PortfolioCoinModel toPortfolioCoinModel(double? quantity) {
    return PortfolioCoinModel(
      id: id,
      symbol: symbol,
      name: name,
      quantity: quantity ?? 0.0,
    );
  }
}

class CoinPriceModel {
  final Map<String, double> price;

  CoinPriceModel({required this.price});

  factory CoinPriceModel.fromJson(Map<String, dynamic> json) {
    return CoinPriceModel(price: json['price']);
  }
}
