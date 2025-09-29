import 'package:coindex/features/home/bloc/portfolio_event.dart';
import 'package:coindex/features/home/bloc/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/services/price_service.dart';
import '../../../core/utils/shared_preferences_manager.dart';
import '../models/portfolio_coin_model.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(PortfolioCoinInitial()) {
    on<AddCoin>(_onAddCoin);
    on<UpdateCoin>(_onUpdateCoin);
    on<DeleteCoin>(_onDeleteCoin);
    on<FetchPortfolio>(_onFetchPortfolio);
    on<UpdatePortfolioPrices>(_onUpdatePortfolioPrices);
    on<RefreshPortfolioPrices>(_onRefreshPortfolioPrices);
  }

  Future<void> _onAddCoin(AddCoin event, Emitter<PortfolioState> emit) async {
    emit(PortfolioCoinLoading());
    try {
      final prefs = SharedPreferencesManager.instance;
      final portfolioCoins = prefs.getJsonOrDefault(
        PreferenceKeys.coinPortfolio,
        {},
      );

      // Check if coin already exists in portfolio
      PortfolioCoinModel finalCoin;
      if (portfolioCoins.containsKey(event.coin.id)) {
        // Coin exists - add quantities together
        final existingCoin = PortfolioCoinModel.fromJson(
          portfolioCoins[event.coin.id],
        );
        finalCoin = existingCoin.copyWith(
          quantity: existingCoin.quantity + event.coin.quantity,
        );
      } else {
        // New coin - use as is
        finalCoin = event.coin;
      }

      // Save the updated coin
      portfolioCoins[event.coin.id] = finalCoin.toJson();
      await prefs.setJson(PreferenceKeys.coinPortfolio, portfolioCoins);

      // Fetch price for the coin
      final prices = await PriceService.fetchPrices([event.coin.id]);
      final updatedCoin = prices.containsKey(event.coin.id)
          ? finalCoin.withPrice(prices[event.coin.id]!, PriceUpdateStatus.idle)
          : finalCoin;

      // Update with price data
      portfolioCoins[event.coin.id] = updatedCoin.toJson();
      await prefs.setJson(PreferenceKeys.coinPortfolio, portfolioCoins);

      final coins = portfolioCoins.values
          .map((e) => PortfolioCoinModel.fromJson(e))
          .toList();

      emit(
        PortfolioCoinLoaded(
          coins: coins,
          totalPortfolioValue: _calculateTotalValue(coins),
        ),
      );
    } catch (e) {
      emit(PortfolioCoinError('Error: $e'));
    }
  }

  Future<void> _onUpdateCoin(
    UpdateCoin event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioCoinLoading());
    try {
      final prefs = SharedPreferencesManager.instance;
      final portfolioCoins = prefs.getJsonOrDefault(
        PreferenceKeys.coinPortfolio,
        {},
      );
      portfolioCoins[event.coin.id] = event.coin.toJson();
      await prefs.setJson(PreferenceKeys.coinPortfolio, portfolioCoins);

      final coins = portfolioCoins.values
          .map((e) => PortfolioCoinModel.fromJson(e))
          .toList();

      emit(
        PortfolioCoinLoaded(
          coins: coins,
          totalPortfolioValue: _calculateTotalValue(coins),
        ),
      );
    } catch (e) {
      emit(PortfolioCoinError('Error: $e'));
    }
  }

  Future<void> _onDeleteCoin(
    DeleteCoin event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioCoinLoading());
    try {
      final prefs = SharedPreferencesManager.instance;
      final portfolioCoins = prefs.getJsonOrDefault(
        PreferenceKeys.coinPortfolio,
        {},
      );
      portfolioCoins.remove(event.id);
      await prefs.setJson(PreferenceKeys.coinPortfolio, portfolioCoins);

      final coins = portfolioCoins.values
          .map((e) => PortfolioCoinModel.fromJson(e))
          .toList();

      emit(
        PortfolioCoinLoaded(
          coins: coins,
          totalPortfolioValue: _calculateTotalValue(coins),
        ),
      );
    } catch (e) {
      emit(PortfolioCoinError('Error: $e'));
    }
  }

  Future<void> _onFetchPortfolio(
    FetchPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioCoinLoading());
    try {
      final prefs = SharedPreferencesManager.instance;
      final portfolioCoins = prefs.getJsonOrDefault(
        PreferenceKeys.coinPortfolio,
        {},
      );

      final coins = portfolioCoins.values
          .map((e) => PortfolioCoinModel.fromJson(e))
          .toList();

      // Fetch prices for all coins
      if (coins.isNotEmpty) {
        final coinIds = coins.map((coin) => coin.id).toList();
        final prices = await PriceService.fetchPrices(coinIds);

        // Update coins with current prices
        final updatedCoins = coins.map((coin) {
          if (prices.containsKey(coin.id)) {
            final priceUpdateStatus = prices[coin.id]! > coin.currentPrice!
                ? PriceUpdateStatus.up
                : prices[coin.id]! < coin.currentPrice!
                ? PriceUpdateStatus.down
                : PriceUpdateStatus.idle;
            return coin.withPrice(prices[coin.id]!, priceUpdateStatus);
          }
          return coin;
        }).toList();

        // Save updated prices
        final updatedPortfolio = <String, Map<String, dynamic>>{};
        for (final coin in updatedCoins) {
          updatedPortfolio[coin.id] = coin.toJson();
        }
        await prefs.setJson(PreferenceKeys.coinPortfolio, updatedPortfolio);

        emit(
          PortfolioCoinLoaded(
            coins: updatedCoins,
            totalPortfolioValue: _calculateTotalValue(updatedCoins),
          ),
        );
      } else {
        emit(PortfolioCoinLoaded(coins: coins, totalPortfolioValue: 0.0));
      }
    } catch (e) {
      emit(PortfolioCoinError('Error: $e'));
    }
  }

  Future<void> _onUpdatePortfolioPrices(
    UpdatePortfolioPrices event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioCoinLoaded) return;

    final currentState = state as PortfolioCoinLoaded;
    final updatedCoins = currentState.coins.map((coin) {
      if (event.prices.containsKey(coin.id)) {
        return coin.withPrice(event.prices[coin.id]!, PriceUpdateStatus.idle);
      }
      return coin;
    }).toList();

    // Save updated prices
    final prefs = SharedPreferencesManager.instance;
    final updatedPortfolio = <String, Map<String, dynamic>>{};
    for (final coin in updatedCoins) {
      updatedPortfolio[coin.id] = coin.toJson();
    }
    await prefs.setJson(PreferenceKeys.coinPortfolio, updatedPortfolio);

    emit(
      PortfolioCoinLoaded(
        coins: updatedCoins,
        totalPortfolioValue: _calculateTotalValue(updatedCoins),
      ),
    );
  }

  Future<void> _onRefreshPortfolioPrices(
    RefreshPortfolioPrices event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioCoinLoaded) {
      add(FetchPortfolio());
      return;
    }

    final currentState = state as PortfolioCoinLoaded;

    if (currentState.coins.isEmpty) {
      return;
    }

    final coinIds = currentState.coins.map((coin) => coin.id).toList();

    try {
      final prices = await PriceService.fetchPrices(coinIds);
      add(UpdatePortfolioPrices(prices: prices));
    } catch (e) {
      // current state
    }
  }

  // Calculate total portfolio value
  double _calculateTotalValue(List<PortfolioCoinModel> coins) {
    return coins.fold(0.0, (total, coin) => total + (coin.totalValue ?? 0.0));
  }
}
