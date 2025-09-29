import 'package:coindex/data/models/coins_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_endpoints.dart';
import '../helper/coin_search_helper.dart';
import 'coin_event.dart';
import 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc() : super(CoinInitial()) {
    on<FetchCoins>(_onFetchCoins);
  }

  Future<void> _onFetchCoins(FetchCoins event, Emitter<CoinState> emit) async {
    emit(CoinLoading());
    try {
      final response = await Dio().get(ApiEndpoints.coins);

      if (response.statusCode == HttpStatusCodes.ok) {
        final List<dynamic> data = response.data;
        final coins = data.map((e) => CoinsModel.fromJson(e)).toList();

        // Initialize search helper with coins
        CoinSearchHelper.instance.initialize(coins);

        emit(CoinLoaded(coins));
      } else {
        emit(CoinError('Failed to load coins: ${response.statusCode}'));
      }
    } catch (e) {
      emit(CoinError('Error: $e'));
    }
  }
}
