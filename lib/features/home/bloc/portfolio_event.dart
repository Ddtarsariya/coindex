import '../models/portfolio_coin_model.dart';

abstract class PortfolioEvent {
  const PortfolioEvent();

  List<Object?> get props => [];
}

class FetchPortfolio extends PortfolioEvent {}

class AddCoin extends PortfolioEvent {
  final PortfolioCoinModel coin;

  const AddCoin({required this.coin});

  @override
  List<Object?> get props => [coin];
}

class UpdateCoin extends PortfolioEvent {
  final PortfolioCoinModel coin;
  final String quantity;

  const UpdateCoin({required this.coin, required this.quantity});

  @override
  List<Object?> get props => [coin, quantity];
}

class DeleteCoin extends PortfolioEvent {
  final String id;

  const DeleteCoin({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdatePortfolioPrices extends PortfolioEvent {
  final Map<String, double> prices;

  const UpdatePortfolioPrices({required this.prices});

  @override
  List<Object?> get props => [prices];
}

class RefreshPortfolioPrices extends PortfolioEvent {}
