import '../../../data/models/coins_model.dart';

class CoinState {
  const CoinState();

  List<Object?> get props => [];
}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<CoinsModel> coins;

  const CoinLoaded(this.coins);

  @override
  List<Object?> get props => [coins];
}

class CoinError extends CoinState {
  final String message;

  const CoinError(this.message);

  @override
  List<Object?> get props => [message];
}

class CoinPriceLoading extends CoinState {}

class CoinPriceLoaded extends CoinState {
  final List<CoinPriceModel> coins;

  const CoinPriceLoaded(this.coins);

  @override
  List<Object?> get props => [coins];
}

class CoinPriceError extends CoinState {
  final String message;

  const CoinPriceError(this.message);

  @override
  List<Object?> get props => [message];
}
