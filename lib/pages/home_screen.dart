import 'package:flutter/material.dart';
import 'package:flutter_challenge/components/risk_reward_graph.dart';
import 'package:flutter_challenge/components/stock_options_grid.dart';

/// Main page of the application displays the graph along with the options contracts
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ibte's Options Profit Calculator"),
      ),
      body: const Column(
        children: [
          StockOptionsGrid(),
          Expanded(child: RiskRewardGraph()),
        ],
      ),
    );
  }
}
