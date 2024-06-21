import 'package:flutter_challenge/models/enums/option_position.dart';
import 'package:flutter_challenge/models/enums/option_type.dart';
import 'package:flutter_challenge/models/graph_constraints.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_state_helpers.dart';

void main() {
  late final List<OptionsContract> contracts;

  setUpAll(() {
    contracts = [
      OptionsContract(
        strikePrice: 100,
        ask: 5,
        bid: 15,
        position: OptionPosition.long,
        type: OptionType.call,
        expiration: DateTime.now(),
      ),
      OptionsContract(
        strikePrice: 200,
        ask: 15,
        bid: 25,
        position: OptionPosition.short,
        type: OptionType.put,
        expiration: DateTime.now(),
      ),
      OptionsContract(
        strikePrice: 300,
        ask: 20,
        bid: 40,
        position: OptionPosition.long,
        type: OptionType.put,
        expiration: DateTime.now(),
      ),
    ];
  });
  group('ContractsStateHelpers', () {
    test('computeConstraints should return correct constraints', () {
      // Act
      final constraints = ContractsStateHelpers.computeConstraints(contracts);

      // Assert
      expect(constraints.minX, equals(100 - Constants.axisMargin));
      expect(constraints.maxX, equals(300 + Constants.axisMargin));
      expect(constraints.minY, equals(-80 - Constants.axisMargin));
      expect(constraints.maxY, equals(190 + Constants.axisMargin));
    });

    test('computeSpots should return correct spots', () {
      final constraints = GraphConstraints(
        minX: 100 - Constants.axisMargin,
        maxX: 300 + Constants.axisMargin,
        minY: 0 - Constants.axisMargin,
        maxY: 30 + Constants.axisMargin,
      );

      // Act
      final spots = ContractsStateHelpers.computeSpots(contracts, constraints);

      // Assert
      expect(spots.length, equals(3));
      expect(spots[0].length, equals(263));
      expect(spots[1].length, equals(263));
      expect(spots[2].length, equals(263));
    });

    test('getGraphDataForContract should return correct graph data', () {
      // Arrange
      final contract = contracts[1];
      final constraints = GraphConstraints(
        minX: 100 - Constants.axisMargin,
        maxX: 300 + Constants.axisMargin,
        minY: 0 - Constants.axisMargin,
        maxY: 30 + Constants.axisMargin,
      );

      // Act
      final graphData =
          ContractsStateHelpers.getGraphDataForContract(contract, constraints);

      // Assert
      expect(graphData.length, equals(263));
      expect(graphData[0].x, equals(70.0));
      expect(graphData[0].y, equals(-110.0));
      expect(graphData[100].x, equals(170.0));
      expect(graphData[100].y, equals(-10.0));
      expect(graphData[200].x, equals(268.0));
      expect(graphData[200].y, equals(20.0));
    });
  });
}
