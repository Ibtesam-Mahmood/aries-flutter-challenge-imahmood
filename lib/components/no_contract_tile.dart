import 'package:flutter/material.dart';

/// A simple widget to display when there is no contract data for the index
class NoContractTile extends StatelessWidget {
  const NoContractTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              width: 2,
              style: BorderStyle.solid),
        ),
      ),
    );
  }
}
