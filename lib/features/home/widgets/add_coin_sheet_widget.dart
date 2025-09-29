import 'package:coindex/features/home/bloc/portfolio_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/coins_model.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_state.dart';
import 'searchable_field_widget.dart';

class AddCoinSheetWidget extends StatefulWidget {
  final List<CoinsModel> coins;

  const AddCoinSheetWidget({super.key, required this.coins});

  @override
  State<AddCoinSheetWidget> createState() => _AddCoinSheetWidgetState();
}

class _AddCoinSheetWidgetState extends State<AddCoinSheetWidget> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  CoinsModel? _selectedCoin;
  bool _isValid = false;
  bool _isExistingCoin = false;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid =
          _selectedCoin != null &&
          _quantityController.text.isNotEmpty &&
          double.tryParse(_quantityController.text) != null &&
          double.parse(_quantityController.text) > 0;
    });
  }

  void _onCoinSelected(CoinsModel coin) {
    setState(() {
      _selectedCoin = coin;
      _searchController.text = coin.name;
      _isExistingCoin = _checkIfCoinExists(coin.id);
    });
    _validateForm();
  }

  bool _checkIfCoinExists(String coinId) {
    // Check if coin already exists in current portfolio
    final portfolioBloc = context.read<PortfolioBloc>();
    final state = portfolioBloc.state;

    if (state is PortfolioCoinLoaded) {
      return state.coins.any((coin) => coin.id == coinId);
    }
    return false;
  }

  void _addCoin() {
    if (_isValid) {
      context.read<PortfolioBloc>().add(
        AddCoin(
          coin: _selectedCoin!.toPortfolioCoinModel(
            double.parse(_quantityController.text),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add Coin to Portfolio',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Coin Selection Section
                  _buildSectionLabel('Select Coin', Icons.search),
                  const SizedBox(height: AppTheme.spacing8),
                  SearchableFieldWidget(
                    allCoins: widget.coins,
                    onSelect: _onCoinSelected,
                  ),

                  const SizedBox(height: AppTheme.spacing8),

                  // Selected Coin Display
                  if (_selectedCoin != null) ...[
                    _buildSelectedCoinCard(),
                    const SizedBox(height: AppTheme.spacing24),
                  ],

                  // Quantity Section
                  _buildSectionLabel('Quantity', Icons.numbers),
                  const SizedBox(height: AppTheme.spacing8),
                  _buildQuantityField(),

                  const SizedBox(height: AppTheme.spacing32),

                  // Add Button
                  _buildAddButton(),

                  const SizedBox(height: AppTheme.spacing24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------widgets--------

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppTheme.spacing8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCoinCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 20,
            child: Text(
              _selectedCoin!.symbol.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCoin!.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _selectedCoin!.symbol.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                if (_isExistingCoin)
                  Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacing4),
                    child: Text(
                      'Already in portfolio',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            _isExistingCoin ? Icons.update : Icons.check_circle,
            color: _isExistingCoin
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Enter quantity (e.g., 0.5)',
            prefixIcon: const Icon(Icons.numbers),
            suffixIcon: _quantityController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _quantityController.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Enter the amount of ${_selectedCoin?.symbol.toUpperCase() ?? 'coins'} you want to add',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _isValid ? _addCoin : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isValid
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        foregroundColor: _isValid
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.outline,
        elevation: _isValid ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(
        _isValid
            ? (_isExistingCoin ? Icons.update : Icons.add_circle)
            : Icons.add_circle_outline,
        size: 24,
      ),
      label: Text(
        _isValid
            ? (_isExistingCoin ? 'Update Portfolio' : 'Add to Portfolio')
            : 'Select Coin & Enter Quantity',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
