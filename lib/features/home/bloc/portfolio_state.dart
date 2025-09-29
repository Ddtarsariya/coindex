import '../models/portfolio_coin_model.dart';

class PortfolioState {
  final List<String> ids;
  const PortfolioState({this.ids = const []});

  List<Object?> get props => [ids];
}

class PortfolioCoinInitial extends PortfolioState {}

class PortfolioCoinLoading extends PortfolioState {}

class PortfolioCoinLoaded extends PortfolioState {
  final List<PortfolioCoinModel> coins;
  final double totalPortfolioValue;

  const PortfolioCoinLoaded({
    required this.coins,
    this.totalPortfolioValue = 0.0,
  });

  @override
  List<Object?> get props => [coins, totalPortfolioValue];

  /// Get formatted total portfolio value
  String get formattedTotalValue {
    return '\$${totalPortfolioValue.toStringAsFixed(2)}';
  }
}

class PortfolioCoinError extends PortfolioState {
  final String message;

  const PortfolioCoinError(this.message);

  @override
  List<Object?> get props => [message];
}
