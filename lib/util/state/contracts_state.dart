import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_challenge/models/graph_constraints.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/state/contracts_state_helpers.dart';

/// The base state of the application
class ContractsState extends Equatable {
  /// List of contracts, cannot be more than the maximum number of contracts
  final List<OptionsContract> contracts;

  /// The constraints for the graph
  /// Computed each time the contracts are updated
  final GraphConstraints constraints;

  /// The list of spots for each line in the graph
  /// Each index is associated with a contract
  /// Computed each time the contracts are updated
  final List<List<FlSpot>> spots;

  const ContractsState({
    required this.contracts,
    required this.constraints,
    required this.spots,
  });

  /// Everytime this method is used to update the contracts, the constraints and spots are recomputed
  ContractsState copyWith({List<OptionsContract>? contracts}) {
    final constraints = contracts == null
        ? null
        : ContractsStateHelpers.computeConstraints(contracts);
    final spots = contracts == null
        ? null
        : ContractsStateHelpers.computeSpots(contracts, constraints!);

    return ContractsState(
      contracts: contracts ?? this.contracts,
      constraints: constraints ?? this.constraints,
      spots: spots ?? this.spots,
    );
  }

  factory ContractsState.initial() {
    return ContractsState(
      contracts: const [],
      constraints: GraphConstraints.zero(),
      spots: const [],
    );
  }

  @override
  List<Object?> get props => [contracts, constraints, ...spots];
}

/// A state that holds the selected index of a contract
/// This is triggered when a contract is selected
class SelectedContractsState extends ContractsState {
  final int selectedIndex;

  const SelectedContractsState({
    required this.selectedIndex,
    required super.contracts,
    required super.constraints,
    required super.spots,
  });

  @override
  SelectedContractsState copyWith({
    List<OptionsContract>? contracts,
    int? selectedIndex,
  }) {
    // Update the constraints and spots though the parent
    final parent = super.copyWith(contracts: contracts);

    return SelectedContractsState(
      contracts: parent.contracts,
      constraints: parent.constraints,
      spots: parent.spots,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [contracts, selectedIndex];
}
