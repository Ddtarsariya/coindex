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
        child: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, coinState) {
            return BlocBuilder<PortfolioBloc, PortfolioState>(
              builder: (context, portfolioState) {
                // Show loading if coins are loading or portfolio is loading
                if (coinState is CoinLoading ||
                    portfolioState is PortfolioCoinLoading) {
                  return _buildLoadingState();
                }

                // Show error if coins failed to load
                if (coinState is CoinError) {
                  return _buildErrorState(coinState.message);
                }

                // Show portfolio content if coins are loaded
                if (coinState is CoinLoaded) {
                  if (portfolioState is PortfolioCoinLoaded) {
                    return CustomScrollView(
                      slivers: [
                        _buildPortfolioSummary(portfolioState),
                        if (portfolioState.coins.isNotEmpty)
                          _buildPortfolioCoinsList(portfolioState)
                        else
                          _buildEmptyState(),
                      ],
                    );
                  } else if (portfolioState is PortfolioCoinError) {
                    return _buildPortfolioErrorState(portfolioState.message);
                  }
                }

                return const SizedBox.shrink();
              },
            );
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

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load coins: $message',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CoinBloc>().add(FetchCoins());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Portfolio Error: $message',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PortfolioBloc>().add(FetchPortfolio());
            },
            child: const Text('Retry'),
          ),
        ],
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
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocProvider.value(
            value: portfolioBloc,
            child: AddCoinSheetWidget(coins: state.coins),
          ),
        ),
      );
    } else if (state is CoinLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading coins, please wait...'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (state is CoinError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading coins: ${state.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              context.read<CoinBloc>().add(FetchCoins());
            },
          ),
        ),
      );
    } else {
      // If coins haven't been fetched yet, fetch them
      context.read<CoinBloc>().add(FetchCoins());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading coins...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
