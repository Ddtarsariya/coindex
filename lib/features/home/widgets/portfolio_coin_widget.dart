import 'package:flutter/material.dart';

import '../../../core/constants/app_enums.dart';
import '../models/portfolio_coin_model.dart';

class PortfolioCoinWidget extends StatelessWidget {
  final PortfolioCoinModel coin;
  final VoidCallback? onDelete;

  const PortfolioCoinWidget({super.key, required this.coin, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('portfolio_coin_${coin.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (direction) {
        Future.delayed(const Duration(milliseconds: 100), () {
          onDelete?.call();
        });
        _showDeleteSnackBar(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildCoinAvatar(context),
              const SizedBox(width: 16),

              Expanded(child: _buildCoinInfo(context)),

              _buildPriceInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinAvatar(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          coin.symbol.toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,

            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCoinInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coin.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              coin.symbol.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${coin.quantity.toStringAsFixed(coin.quantity % 1 == 0 ? 0 : 2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (coin.lastUpdated != null &&
            DateTime.now().difference(coin.lastUpdated!).inHours > 24)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  'Price data may be outdated',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getPriceStatusColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getPriceStatusColor(context).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            coin.formattedTotalValue,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getPriceStatusColor(context),
            ),
          ),
        ),
        const SizedBox(height: 6),

        if (coin.currentPrice != null)
          Text(
            '\$${coin.currentPrice!.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),

        if (coin.priceUpdateStatus != PriceUpdateStatus.idle)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  coin.priceUpdateStatus == PriceUpdateStatus.up
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 12,
                  color: _getPriceStatusColor(context),
                ),
                const SizedBox(width: 2),
                Text(
                  coin.priceUpdateStatus == PriceUpdateStatus.up
                      ? 'Up'
                      : 'Down',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getPriceStatusColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getPriceStatusColor(BuildContext context) {
    switch (coin.priceUpdateStatus) {
      case PriceUpdateStatus.up:
        return Colors.green.shade600;
      case PriceUpdateStatus.down:
        return Colors.red.shade600;
      case PriceUpdateStatus.idle:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Coin'),
          content: Text(
            'Are you sure you want to remove ${coin.name} from your portfolio?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coin.name} removed from portfolio'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
