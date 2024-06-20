import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';
import 'package:flutter_challenge/util/state/contracts_state.dart';

typedef OptionContractTileState = ({OptionsContract contract, bool selected});

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
    return selected ? getInverseColor(context) : getBaseColor(context);
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
        contract: bloc.state.contracts[index],
        selected: (bloc.state is SelectedContractsState) &&
            (bloc.state as SelectedContractsState).selectedIndex == index
      ),
    );

    final selected = state.selected;
    final contract = state.contract;

    // Set the color based on the selected state
    final surfaceColor = getSurfaceColor(context, selected);
    final textColor = getTextColor(context, selected);

    return Card(
      color: surfaceColor,
      child: InkWell(
        onTap: () {
          final bloc = context.read<ContractsBloc>();
          return switch (selected) {
            false => bloc.add(SelectContractEvent(index)),
            true => bloc.add(const UnselectContractEvent()),
          };
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: selected
                ? Border.all(
                    color: textColor,
                    width: 4,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
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
