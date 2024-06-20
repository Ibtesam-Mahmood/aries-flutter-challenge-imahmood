import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_challenge/models/graph_constraints.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/constants.dart';

/// A helper class for the ContractsState and Bloc
class ContractsStateHelpers {
  /// Computes the min/max constraints for the X and Y Axis graph
  /// First, retreives the max/min X value by finding the smallest/largest strike price
  /// Next, retreives the max/min Y value by finding the max profit/loss for each contract at the edge of the X Axis
  /// Finally, adds a margin to each constraint and returns
  static GraphConstraints computeConstraints(List<OptionsContract> contracts) {
    // Compute min/max values for the X Axis
    final double minX = contracts.fold(
        double.infinity,
        (double prev, contract) =>
            contract.strikePrice < prev ? contract.strikePrice : prev);
    final double maxX = contracts.fold(
        double.negativeInfinity,
        (double prev, contract) =>
            contract.strikePrice > prev ? contract.strikePrice : prev);

    // Compute min/max values for the Y Axis by using the edge values of the X Axis
    final double maxY = contracts.fold(
      double.negativeInfinity,
      (double prev, contract) {
        final maxXProfitLoss = contract.calculateProfitLoss(maxX);
        final minXProfitLoss = contract.calculateProfitLoss(minX);
        final maxProfitLoss = max(maxXProfitLoss, minXProfitLoss);

        return maxProfitLoss > prev ? maxProfitLoss : prev;
      },
    );
    final double minY = contracts.fold(
      double.infinity,
      (double prev, contract) {
        final maxXProfitLoss = contract.calculateProfitLoss(maxX);
        final minXProfitLoss = contract.calculateProfitLoss(minX);
        final minProfitLoss = min(maxXProfitLoss, minXProfitLoss);

        return minProfitLoss < prev ? minProfitLoss : prev;
      },
    );

    // Add a margin to each constraint and return
    return GraphConstraints(
      minX: minX - Constants.axisMargin,
      maxX: maxX + Constants.axisMargin,
      minY: minY - Constants.axisMargin,
      maxY: maxY + Constants.axisMargin,
    );
  }

  /// Computes the spots for each contract
  static List<List<FlSpot>> computeSpots(
          List<OptionsContract> contracts, GraphConstraints constraints) =>
      contracts
          .map((contract) => getGraphDataForContract(contract, constraints))
          .toList();

  /// Retreives a list of FLSpots to create a line on the chart for the contract
  static List<FlSpot> getGraphDataForContract(
      OptionsContract contract, GraphConstraints constraints) {
    // Get the contract break even point and the max profit/loss values for the graph
    double breakEvenPoint = contract.getBreakEvenPoint();

    // Generate the data for the graph
    List<FlSpot> data = [];
    bool breakEvenPointAdded = false;
    bool maxPointAdded = false;
    for (double price = constraints.minX;
        price <= constraints.maxX;
        price += 1) {
      // Add the break even point to the graph at the correct position
      if (price >= breakEvenPoint && !breakEvenPointAdded) {
        data.add(FlSpot(breakEvenPoint, 0));
        breakEvenPointAdded = true;
      }

      // Add the max profit/loss point to the graph at the correct position
      if (price >= contract.strikePrice && !maxPointAdded) {
        data.add(FlSpot(contract.strikePrice, contract.premiumProfit));
        maxPointAdded = true;
      }

      // Calculate the profit/loss for the contract at the given price
      double profitLoss = contract.calculateProfitLoss(price);
      data.add(FlSpot(price, profitLoss));
    }

    // Return the data for the graph
    return data;
  }
}
