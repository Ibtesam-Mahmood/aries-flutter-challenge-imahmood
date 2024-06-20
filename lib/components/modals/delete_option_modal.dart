import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';

class DeleteOptionModal extends StatelessWidget {
  /// The index of the contract to delete
  final int index;

  /// The bloc to add the delete event to
  final ContractsBloc bloc;

  const DeleteOptionModal({super.key, required this.bloc, required this.index});

  static Future<void> show(BuildContext context, int index) async {
    final bloc = context.read<ContractsBloc>();

    await showDialog(
      context: context,
      builder: (context) => DeleteOptionModal(
        bloc: bloc,
        index: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Option Contract?'),
      content: const SingleChildScrollView(
        child: Text(
            'Once you delete this contract you cannot recover it. However, you will be able to add an additional contract. do you want to proceed?'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            bloc.add(RemoveContractEvent(index));
          },
        ),
        TextButton(
          child: Text(
            'Delete',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onPressed: () {
            bloc.add(RemoveContractEvent(index));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
