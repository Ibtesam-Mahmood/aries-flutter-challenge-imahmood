import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/components/add_more_button.dart';
import 'package:flutter_challenge/components/no_contract_tile.dart';
import 'package:flutter_challenge/components/option_contract_tile.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_state.dart';

class StockOptionsGrid extends StatelessWidget {
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
              child: BlocSelector<ContractsBloc, ContractsState, int>(
                  selector: (ContractsState state) => state.contracts.length,
                  builder: (context, int contractCount) {
                    return GridView.builder(
                      itemCount: Constants.contractsMaxCount,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        // Build an add more button as the last tile
                        if (index == contractCount) {
                          return AddOptionButton(
                            onPressed: () {
                              // TODO: Add more options
                            },
                          );
                        }

                        // Any proceeding tiles should be a blank container
                        if (index > contractCount) {
                          return const NoContractTile();
                        }

                        // Otherwise, show the options contract tile
                        return OptionContractTile(index: index);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
