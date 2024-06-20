import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/options_contract.dart';

class OptionContractTile extends StatelessWidget {
  final OptionsContract contract;
  final int index;
  final bool selected;

  const OptionContractTile({
    super.key,
    required this.contract,
    required this.index,
    required this.selected,
  });

  Color getBaseColor(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerLow;
  }

  Color getInverseColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  Color getSurfaceColor(BuildContext context) {
    return selected ? getInverseColor(context) : getBaseColor(context);
  }

  Color getTextColor(BuildContext context) {
    return selected ? getBaseColor(context) : getInverseColor(context);
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = getSurfaceColor(context);
    final textColor = getTextColor(context);

    return Card(
      color: surfaceColor,
      child: InkWell(
        onTap: () {
          // TODO: Select index
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
