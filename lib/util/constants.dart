import 'package:flutter/material.dart';

/// Defines a class to hold constant values used in the app
class Constants {
  /// Defines the marin to give the graph axis around the data
  static const double axisMargin = 30;

  /// Hard coded maximum number of contracts allowed based on the assignment, can be updated
  /// Cannot be greater than 15 due to the number of colors defined
  static const int contractsMaxCount = 4;

  /// Defines the constant line colors to use in the graph, maximum 15 lines
  static List<Color> get lineColors => [
        Colors.blue[300]!,
        Colors.red[300]!,
        Colors.green[300]!,
        Colors.purple[300]!,
        Colors.orange[300]!,
        Colors.yellow[300]!,
        Colors.teal[300]!,
        Colors.pink[300]!,
        Colors.cyan[300]!,
        Colors.amber[300]!,
        Colors.indigo[300]!,
        Colors.lime[300]!,
        Colors.brown[300]!,
        Colors.grey[300]!,
        Colors.deepPurple[300]!,
      ];
}
