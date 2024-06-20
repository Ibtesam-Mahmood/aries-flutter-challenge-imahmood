import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/components/contract_grid/add_more_button.dart';
import 'package:flutter_challenge/components/contract_grid/no_contract_tile.dart';
import 'package:flutter_challenge/components/modals/delete_option_modal.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';
import 'package:flutter_challenge/util/state/contracts_state.dart';

typedef OptionContractTileState = ({
  int count,
  OptionsContract? contract,
  bool selected
});

/// Options Contract tile displays the details of an options contract at the given index
/// If the index is greater than the number of contracts, it will display an add button or a blank tile
class OptionContractTile extends StatelessWidget {
  final int index;

  const OptionContractTile({
    super.key,
    required this.index,
  });

  Color getBaseColor(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerLow;
  }

  Color getInverseColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  Color getSurfaceColor(BuildContext context, bool selected) {
    return selected ? Constants.lineColors[index] : getBaseColor(context);
  }

  Color getTextColor(BuildContext context, bool selected) {
    return selected ? getBaseColor(context) : getInverseColor(context);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the state from the bloc
    final OptionContractTileState state =
        context.select<ContractsBloc, OptionContractTileState>(
      (bloc) => (
        count: bloc.state.contracts.length,
        contract: bloc.state.contracts.length <= index
            ? null
            : bloc.state.contracts[index],
        selected: (bloc.state is SelectedContractsState) &&
            (bloc.state as SelectedContractsState).selectedIndex == index
      ),
    );

    final selected = state.selected;
    final contract = state.contract;

    // If the contract is null, that means that the index is greater than the number of contracts
    // Show an add button or a blank tile
    if (contract == null) {
      if (index == state.count) {
        // Show the add button
        return AddOptionButton(onPressed: () {
          // Open add option modal
        });
      }

      // Show a blank tile
      return const NoContractTile();
    }

    // Set the color based on the selected state
    final surfaceColor = getSurfaceColor(context, selected);
    final textColor = getTextColor(context, selected);

    return Card(
      child: InkWell(
        onTap: () {
          final bloc = context.read<ContractsBloc>();
          return switch (selected) {
            false => bloc.add(SelectContractEvent(index)),
            true => bloc.add(const UnselectContractEvent()),
          };
        },
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: surfaceColor,
            border: Border.all(
              color: selected
                  ? getInverseColor(context)
                  : Constants.lineColors[index],
              width: 3.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    // Launch the delete modal
                    DeleteOptionModal.show(context, index);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                contract.position.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Type: ${contract.type.name}',
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Premium: \$${contract.premium.toStringAsFixed(2)}',
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Strike Price: \$${contract.strikePrice.toStringAsFixed(2)}',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
