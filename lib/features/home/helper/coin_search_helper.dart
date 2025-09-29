import '../../../data/models/coins_model.dart';

class CoinSearchHelper {
  CoinSearchHelper._();

  static CoinSearchHelper? _instance;
  static CoinSearchHelper get instance {
    _instance ??= CoinSearchHelper._();
    return _instance!;
  }

  List<CoinsModel> _coins = [];
  final Map<String, List<CoinsModel>> _coinsByName = {};
  final Map<String, List<CoinsModel>> _coinsBySymbol = {};

  void initialize(List<CoinsModel> coins) {
    _coins = coins;
    _buildSearchIndex();
  }

  void _buildSearchIndex() {
    _coinsByName.clear();
    _coinsBySymbol.clear();

    for (var coin in _coins) {
      final name = coin.name.toLowerCase();
      final symbol = coin.symbol.toLowerCase();

      for (int i = 1; i <= name.length; i++) {
        final prefix = name.substring(0, i);
        _coinsByName.putIfAbsent(prefix, () => []).add(coin);
      }

      for (int i = 1; i <= symbol.length; i++) {
        final prefix = symbol.substring(0, i);
        _coinsBySymbol.putIfAbsent(prefix, () => []).add(coin);
      }
    }
  }

  List<CoinsModel> search(String query) {
    if (query.isEmpty) return _coins;

    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _coins;

    final Set<CoinsModel> resultSet = {};

    final nameResults = _coinsByName[q] ?? [];
    resultSet.addAll(nameResults);

    final symbolResults = _coinsBySymbol[q] ?? [];
    resultSet.addAll(symbolResults);

    for (var coin in _coins) {
      final name = coin.name.toLowerCase();
      final symbol = coin.symbol.toLowerCase();

      if (name.contains(q) || symbol.contains(q)) {
        resultSet.add(coin);
      }
    }

    return resultSet.toList();
  }

  List<CoinsModel> getAllCoins() {
    return _coins;
  }

  bool get isInitialized => _coins.isNotEmpty;
}
