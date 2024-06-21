import 'package:flutter/material.dart';
import 'package:flutter_challenge/components/contract_grid/option_contract_tile.dart';
import 'package:flutter_challenge/util/constants.dart';

/// Creates a grid of [OptionContracTile] which displays the details of the options contracts
/// Uses the [Constants.contractsMaxCount] to determine the number of tiles to display
/// Always displays the max number of tiles, even if there are less contracts
/// The remaining tiles will either be blank or display an add button
class StockOptionsGrid extends StatelessWidget {
  /// The height of the grid
  static const double height = 300;

  const StockOptionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            const Text('Tap on a contract for more details'),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                // Always show the max number of tiles
                itemCount: Constants.contractsMaxCount,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return OptionContractTile(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
