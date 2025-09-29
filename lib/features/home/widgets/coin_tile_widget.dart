import 'package:flutter/material.dart';

import '../../../data/models/coins_model.dart';

class CoinTileWidget extends StatelessWidget {
  final CoinsModel coin;
  final Function() onTap;
  const CoinTileWidget({super.key, required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(coin.symbol.toUpperCase())),
      title: Text(coin.name),
      subtitle: Text(coin.symbol.toUpperCase()),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
