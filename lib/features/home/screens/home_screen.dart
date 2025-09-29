import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/coin_bloc.dart';
import '../bloc/coin_event.dart';
import '../bloc/coin_state.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart';
import '../bloc/portfolio_state.dart';
import '../widgets/add_coin_sheet_widget.dart';
import '../widgets/portfolio_coin_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoinBloc>().add(FetchCoins());
    context.read<PortfolioBloc>().add(FetchPortfolio());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCoinSheet(context),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PortfolioBloc>().add(RefreshPortfolioPrices());
        },
        child: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, state) {
            if (state is PortfolioCoinLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PortfolioCoinLoaded) {
              return CustomScrollView(
                slivers: [
                  _buildPortfolioSummary(state),
                  if (state.coins.isNotEmpty)
                    _buildPortfolioCoinsList(state)
                  else
                    _buildEmptyState(),
                ],
              );
            } else if (state is PortfolioCoinError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ---------Widgets----------

  Widget _buildPortfolioSummary(PortfolioCoinLoaded state) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              'Total Portfolio Value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              state.formattedTotalValue,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCoinsList(PortfolioCoinLoaded state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final coin = state.coins[index];
        return PortfolioCoinWidget(
          coin: coin,
          onDelete: () {
            context.read<PortfolioBloc>().add(DeleteCoin(id: coin.id));
          },
        );
      }, childCount: state.coins.length),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wallet_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'No coins in portfolio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Tap + to add your first coin',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- Functions --------

  Future<void> _showAddCoinSheet(BuildContext context) async {
    final coinBloc = context.read<CoinBloc>();
    final portfolioBloc = context.read<PortfolioBloc>();
    final state = coinBloc.state;

    if (state is CoinLoaded) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BlocProvider.value(
          value: portfolioBloc,
          child: AddCoinSheetWidget(coins: state.coins),
        ),
      );
    }
  }
}
