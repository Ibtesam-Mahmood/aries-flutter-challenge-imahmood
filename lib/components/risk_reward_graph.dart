import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/enums/enums.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/constants.dart';

class RiskRewardGraph extends StatelessWidget {
  final List<OptionsContract> data;

  const RiskRewardGraph({super.key, required this.data});

  // Constants for the graph, computed from the data
  double get minY {
    final minXValue = minX;
    double value = data.fold(null, (double? prev, contract) {
          return prev == null || contract.calculateProfitLoss(minXValue) < prev
              ? contract.calculateProfitLoss(minXValue)
              : prev;
        })! -
        Constants.axisMargin;
    return (value / 10).toInt() * 10.0;
  }

  double get maxY {
    final maxXValue = maxX;
    double value = data.fold(null, (double? prev, contract) {
          return prev == null || contract.calculateProfitLoss(maxXValue) > prev
              ? contract.calculateProfitLoss(maxXValue)
              : prev;
        })! +
        Constants.axisMargin;
    return (value / 10).toInt() * 10.0;
  }

  double get maxX {
    // Find the smallest strike price and add the axisMargin
    return data.fold(null, (double? prev, contract) {
          return prev == null || contract.strikePrice > prev
              ? contract.strikePrice
              : prev;
        })! +
        Constants.axisMargin;
  }

  double get minX {
    // Find the smallest strike price and subtract the axisMargin
    return data.fold(null, (double? prev, contract) {
          return prev == null || contract.strikePrice < prev
              ? contract.strikePrice
              : prev;
        })! -
        Constants.axisMargin;
  }

  /// Retreives a list of VerticalLine objects for each contract's strike price
  List<VerticalLine> getStrikePriceLines() {
    return List.generate(data.length, (i) => i)
        .map((i) => VerticalLine(
              x: data[i].strikePrice,
              color: Constants.lineColors[i],
              strokeWidth: 2,
              dashArray: [3, 3],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // List of LineChartBarData objects for each contract
    final List<LineChartBarData> lines = getLines();

    // Disabled AxisTitle for the right and top side of the graph
    const AxisTitles disabledAxisTitle =
        AxisTitles(sideTitles: SideTitles(showTitles: false));

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
                    showTitles: true, interval: 5, reservedSize: 25)),
            rightTitles: disabledAxisTitle,
            topTitles: disabledAxisTitle,
          ),

          // Draw the stirke price lines on the graph
          // TODO: along with the break even points, enable this when the line is toggled
          extraLinesData: ExtraLinesData(verticalLines: [
            VerticalLine(
              x: data[0].strikePrice,
              color: Constants.lineColors[0],
              strokeWidth: 2,
              dashArray: [3, 3],
              label: VerticalLineLabel(
                labelResolver: (line) =>
                    'Max ${data[0].position == OptionPosition.long ? 'Loss' : 'Profit'}: \$${data[0].premiumProfit.toStringAsFixed(2)}',
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(left: 10),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
          ], horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.white.withOpacity(0.5),
              strokeWidth: 2,
              dashArray: [3, 3],
              label: HorizontalLineLabel(
                labelResolver: (line) =>
                    'Break Even Point: \$${data[0].getBreakEvenPoint().toStringAsFixed(2)}',
                show: true,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(right: 10),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
          ]),

          // Define the range of the graph
          maxX: maxX,
          minX: minX,
          maxY: maxY,
          minY: minY,

          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  final value = lineBarSpot.y;

                  return LineTooltipItem(
                    '${value >= 0 ? '+' : '-'} \$${value.abs().toStringAsFixed(2)}',
                    TextStyle(
                      color: value > 0 ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> getLines() {
    return List.generate(data.length, (i) => i).map(getLineByIndex).toList();
  }

  LineChartBarData getLineByIndex(int index) {
    final OptionsContract contract = data[index];
    return LineChartBarData(
      spots: getGraphData(contract),
      isCurved: true,
      color: Constants.lineColors[index],
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        // Show the dot at the break even point and the min/max point
        checkToShowDot: (spot, barData) =>
            spot.y == 0 || spot.x == contract.strikePrice,
      ),
      belowBarData: BarAreaData(
        show: true,
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

  List<FlSpot> getGraphData(OptionsContract contract) {
    // Get the contract break even point and the max profit/loss values for the graph
    double breakEvenPoint = contract.getBreakEvenPoint();

    // Generate the data for the graph
    List<FlSpot> data = [];
    bool breakEvenPointAdded = false;
    bool maxPointAdded = false;
    for (double price = minX; price <= maxX; price += 1) {
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
