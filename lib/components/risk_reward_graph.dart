import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/models/enums/enums.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_state.dart';

/// The risk reward graph displays a LineChart with the profit/loss of each contract
/// The X Axis is the price of the underlying asset at expiration
/// While the Y Axis is the profit/loss of the contract
/// It is adapted so that it can display up to 15 contracts at once
/// Additionally contracts can be selected to display the break even point and max profit/loss
class RiskRewardGraph extends StatelessWidget {
  const RiskRewardGraph({super.key});

  /// Retreives a list of LineChartBarData to create a line on the chart for each contract
  List<LineChartBarData> getLines(List<OptionsContract> data,
      List<List<FlSpot>> spotData, int? selectedIndex) {
    return List.generate(data.length,
            (i) => getLineByIndex(data[i], spotData[i], i, selectedIndex))
        .toList()
        .where((d) => d != null)
        .cast<LineChartBarData>()
        .toList();
  }

  /// Retreives a LineChartBarData line for a contract at a specific index
  LineChartBarData? getLineByIndex(OptionsContract contract,
      List<FlSpot> graphData, int index, int? selectedIndex) {
    final selected = index == selectedIndex;

    if (selectedIndex != null && !selected) {
      return null;
    }

    return LineChartBarData(
      spots: graphData,
      isCurved: true,
      // Fade the line if there is a selection and the index is not the selected index
      color: Constants.lineColors[index]
          .withOpacity((selectedIndex ?? index) == index ? 1 : 0.2),
      barWidth: 3,
      dotData: FlDotData(
        show: selected,
        // Show the dot at the break even point and the min/max point
        checkToShowDot: (spot, barData) =>
            spot.y == 0 || spot.x == contract.strikePrice,
      ),
      belowBarData: BarAreaData(
        show: selected,
        gradient: LinearGradient(
          colors: [
            Constants.lineColors[index].withOpacity(0.3),
            Colors.transparent
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  /// Retreives a list of extra horizontal/vertial lines to add to the graph
  /// There is a vertical line at the strike price and a horizontal line at the break even point
  /// If the selectedIndex is null, then no line is added
  ExtraLinesData? getExtraLinesData(
      List<OptionsContract> contracts, int? selectedIndex) {
    if (selectedIndex == null) {
      return null;
    }

    // Get the selected contract
    final contract = contracts[selectedIndex];
    final isLong = contract.position == OptionPosition.long;
    final profitLoss = contract.premiumProfit.toStringAsFixed(2);
    final breakEvenPoint = contract.getBreakEvenPoint().toStringAsFixed(2);

    return ExtraLinesData(
      verticalLines: [
        VerticalLine(
          x: contract.strikePrice,
          color: Constants.lineColors[selectedIndex].withOpacity(0.7),
          strokeWidth: 2,
          dashArray: [3, 3],
          label: VerticalLineLabel(
            labelResolver: (line) =>
                'Max ${isLong ? 'Loss' : 'Profit'}: \$$profitLoss',
            show: true,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(left: 10),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        )
      ],
      horizontalLines: [
        HorizontalLine(
          y: 0,
          color: Constants.lineColors[selectedIndex].withOpacity(0.7),
          strokeWidth: 2,
          dashArray: [3, 3],
          label: HorizontalLineLabel(
            labelResolver: (line) => 'Break Even Point: \$$breakEvenPoint',
            show: true,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(right: 10),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract the state
    final state = context.watch<ContractsBloc>().state;
    final contracts = state.contracts;
    final constraints = state.constraints;
    final spotData = state.spots;
    final selectedIndex = switch (state) {
      SelectedContractsState _ => (state).selectedIndex,
      _ => null,
    };

    // List of LineChartBarData objects for each contract
    final List<LineChartBarData> lines =
        getLines(contracts, spotData, selectedIndex);

    // Disabled AxisTitle for the right and top side of the graph
    const AxisTitles disabledAxisTitle =
        AxisTitles(sideTitles: SideTitles(showTitles: false));

    // Create the line chart
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LineChart(
        LineChartData(
          // Define the data for the graph
          lineBarsData: lines,

          // Define the Axis titles for each side of the graph
          // Disable the top and right side of the graph
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, interval: 10, reservedSize: 40)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, interval: 10, reservedSize: 25)),
            rightTitles: disabledAxisTitle,
            topTitles: disabledAxisTitle,
          ),

          // Draw the strike price lines and the break even point line
          extraLinesData: getExtraLinesData(contracts, selectedIndex),

          // Define the range of the graph
          maxX: constraints.maxX,
          minX: constraints.minX,
          maxY: constraints.maxY,
          minY: constraints.minY,

          // Style the touch indicator to display the price and profit/loss
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white,
              getTooltipItems: (List<LineBarSpot> lineBarsSpots) {
                return lineBarsSpots.map((lineBarSpot) {
                  final price = lineBarSpot.x;
                  final value = lineBarSpot.y;

                  return LineTooltipItem(
                      '⬤ ',
                      TextStyle(
                        color: Constants.lineColors[lineBarSpot.barIndex],
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${price.toStringAsFixed(2)}\n',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${value >= 0 ? '+' : '-'}\$${value.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: value > 0 ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]);
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
