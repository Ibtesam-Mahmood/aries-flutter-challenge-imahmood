/// Sized Box Constraints for the graph
/// Normalizes the contraints to the closest 10th
class GraphConstraints {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  GraphConstraints({
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
  })  : minX = normalize(minX),
        maxX = normalize(maxX),
        minY = normalize(minY),
        maxY = normalize(maxY);

  /// Rounds the value to the nearest 10th
  static double normalize(double value) {
    return (value / 10).round() * 10.0;
  }

  factory GraphConstraints.zero() => GraphConstraints(
        minX: 0,
        maxX: 0,
        minY: 0,
        maxY: 0,
      );
}
