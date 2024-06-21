import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/components/modals/add_option_modal.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';

/// Button to add more options contracts
class AddOptionButton extends StatelessWidget {
  const AddOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Show the add option modal there are less than the max number of contracts
          final contactsCounts =
              context.read<ContractsBloc>().state.contracts.length;
          if (contactsCounts < Constants.contractsMaxCount) {
            AddOptionModal.show(context);
          }
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Add Option',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
