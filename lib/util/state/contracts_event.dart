import 'package:equatable/equatable.dart';
import 'package:flutter_challenge/models/options_contract.dart';

/// Bloc event class, all bloc events within this application are extended from this class
/// When an event is passed to the bloc, the bloc will react to the event and update the state accordingly
/// All required data for the event is passed in the constructor
sealed class ContractsEvent extends Equatable {
  const ContractsEvent();

  @override
  List<Object> get props => [];
}

/// Will update the list of contracts within the state to the ones passed within the event
class SetContractEvent extends ContractsEvent {
  final List<OptionsContract> contracts;

  const SetContractEvent(this.contracts);

  @override
  List<Object> get props => [contracts];
}

/// Event to add a new contract to the list of contracts
/// Will fail if there are already a max number of contracts in the list
class AddContractEvent extends ContractsEvent {
  final OptionsContract contract;

  const AddContractEvent(this.contract);

  @override
  List<Object> get props => [contract];
}

/// Event to remove a contract from the list of contracts by index.
/// Will fail if the index is out of bounds
class RemoveContractEvent extends ContractsEvent {
  final int index;

  const RemoveContractEvent(this.index);

  @override
  List<Object> get props => [index];
}

/// Updates a contract at a specific index.
/// Will fail if the index is out of bounds
class EditContractEvent extends ContractsEvent {
  final int index;
  final OptionsContract contract;

  const EditContractEvent(this.contract, this.index);

  @override
  List<Object> get props => [index, contract];
}

/// Event to select a contract by index
class SelectContractEvent extends ContractsEvent {
  final int index;

  const SelectContractEvent(this.index);

  @override
  List<Object> get props => [index];
}

/// Event to unselect a contract
class UnselectContractEvent extends ContractsEvent {
  const UnselectContractEvent();
}
