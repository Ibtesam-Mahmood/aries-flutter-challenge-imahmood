import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';
import 'package:flutter_challenge/util/state/contracts_state.dart';

/// This Bloc manages the state and events related to a list of contracts.
/// It can be provided to a BlocProvider to be used by widgets in the widget tree.
class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  /// Creates a new ContractsBloc instance and initializes it with the initial state.
  ContractsBloc() : super(ContractsState.initial()) {
    /// Registers event handlers for each type of ContractsEvent.
    on<SetContractEvent>(_setContract);
    on<AddContractEvent>(_addContract);
    on<RemoveContractEvent>(_removeContract);
    on<EditContractEvent>(_editContract);
    on<SelectContractEvent>(_selectContract);
    on<UnselectContractEvent>(_unselectContract);
  }

  /// Handles the SetContractsEvent by setting the contracts list to the provided list.
  void _setContract(SetContractEvent event, Emitter<ContractsState> emit) {
    // Only add the first [Constants.contractsMaxCount] contracts
    final newList = event.contracts
        .sublist(0, min(event.contracts.length, Constants.contractsMaxCount));

    emit(state.copyWith(contracts: newList));
  }

  /// Handles the AddContractEvent by adding the new contract to the state.
  void _addContract(AddContractEvent event, Emitter<ContractsState> emit) {
    // Do not add more contracts if the max count has been reached
    if (state.contracts.length >= Constants.contractsMaxCount) {
      return;
    }

    emit(state.copyWith(contracts: [...state.contracts, event.contract]));
  }

  /// Handles the RemoveContractEvent by removing it by index from the state.
  void _removeContract(
      RemoveContractEvent event, Emitter<ContractsState> emit) {
    // Do not remove contracts if the index is out of bounds
    if (event.index >= state.contracts.length) {
      return;
    }

    final newContracts = [...state.contracts]..removeAt(event.index);
    emit(state.copyWith(contracts: newContracts));
  }

  /// Handles the EditContractEvent by updating the contract at the provided index.
  void _editContract(EditContractEvent event, Emitter<ContractsState> emit) {
    // Do not remove contracts if the index is out of bounds
    if (event.index >= state.contracts.length) {
      return;
    }

    // Update the contract at the provided index
    final newContracts = [...state.contracts];
    newContracts[event.index] = event.contract;

    // Update the state with the new contracts
    emit(state.copyWith(contracts: newContracts));
  }

  /// Handles the SelectContractEvent by selecting a contract at the provided index.
  void _selectContract(
      SelectContractEvent event, Emitter<ContractsState> emit) {
    emit(
      SelectedContractsState(
        contracts: [...state.contracts],
        selectedIndex: event.index,
        constraints: state.constraints,
        spots: state.spots,
      ),
    );
  }

  /// Handles the UnselectContractEvent by unselecting any currently selected contract.
  void _unselectContract(
      UnselectContractEvent event, Emitter<ContractsState> emit) {
    emit(
      ContractsState(
        contracts: [...state.contracts],
        constraints: state.constraints,
        spots: state.spots,
      ),
    );
  }
}
