import 'package:flutter/material.dart';
import 'package:flutter_challenge/components/add_more_button.dart';
import 'package:flutter_challenge/components/no_contract_tile.dart';
import 'package:flutter_challenge/components/option_contract_tile.dart';
import 'package:flutter_challenge/components/risk_reward_graph.dart';
import 'package:flutter_challenge/models/options_contract.dart';

/// Main page of the application displays the graph along with the 4 options contracts
class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> optionsData;

  const HomePage({super.key, required this.optionsData});

  @override
  Widget build(BuildContext context) {
    final contracts = [
      OptionsContractListExtension.fromJsonList(optionsData)[0],
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ibte's Options Profit Calculator"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  const Text('Tap on a contract for more details'),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 4, // Display 4 contracts for now
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        // Build an add more button as the last tile
                        if (index == contracts.length) {
                          return AddOptionButton(
                            onPressed: () {
                              // TODO: Add more options
                            },
                          );
                        }

                        // Any proceeding tiles should be a blank container
                        if (index > contracts.length) {
                          return const NoContractTile();
                        }

                        // Otherwise, show the options contract tile
                        return OptionContractTile(
                          contract: contracts[index],
                          index: index,
                          selected: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: RiskRewardGraph(data: contracts)),
        ],
      ),
    );
  }
}
