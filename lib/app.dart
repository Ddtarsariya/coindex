import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/home/bloc/coin_bloc.dart';
import 'features/home/bloc/portfolio_bloc.dart';
import 'features/home/screens/home_screen.dart';
import 'features/splash/screens/splash_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        HomeScreen.routeName: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CoinBloc()),
            BlocProvider(create: (_) => PortfolioBloc()),
          ],
          child: const HomeScreen(),
        ),
      },
    );
  }
}
