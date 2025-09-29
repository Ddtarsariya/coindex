import 'package:coindex/features/home/helper/coin_search_helper.dart';
import 'package:flutter/material.dart';

import '../../../data/models/coins_model.dart';
import 'coin_tile_widget.dart';

class SearchableFieldWidget extends StatefulWidget {
  final Function(CoinsModel) onSelect;
  final List<CoinsModel> allCoins;

  const SearchableFieldWidget({
    super.key,
    required this.onSelect,
    required this.allCoins,
  });

  @override
  State<SearchableFieldWidget> createState() => _SearchableFieldWidgetState();
}

class _SearchableFieldWidgetState extends State<SearchableFieldWidget> {
  List<CoinsModel> _filteredCoins = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredCoins = widget.allCoins;
      } else {
        _filteredCoins = CoinSearchHelper.instance.search(query);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredCoins = widget.allCoins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search coins...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          onChanged: _onSearchChanged,
        ),

        const SizedBox(height: 8),

        // Results count
        if (_isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredCoins.length} result${_filteredCoins.length == 1 ? '' : 's'} found',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Results list
        if (_isSearching)
          _filteredCoins.isEmpty && _isSearching
              ? _buildNoResults()
              : SizedBox(
                  height: 140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = _filteredCoins[index];
                      return CoinTileWidget(
                        coin: coin,
                        onTap: () {
                          widget.onSelect(coin);
                          _clearSearch();
                          _searchController.text = coin.name;
                        },
                      );
                    },
                  ),
                ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 16),
          Text(
            'No coins found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with a different term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
