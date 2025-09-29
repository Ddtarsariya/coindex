abstract class CoinEvent {
  const CoinEvent();

  List<Object?> get props => [];
}

class FetchCoins extends CoinEvent {}

class FetchCoinPrice extends CoinEvent {
  final List<String> ids;

  const FetchCoinPrice({required this.ids});

  @override
  List<Object?> get props => [ids];
}
