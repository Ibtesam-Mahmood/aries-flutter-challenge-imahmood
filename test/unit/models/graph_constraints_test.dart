import 'package:flutter_challenge/models/graph_constraints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphConstraints ->', () {
    group('Normalize ->', () {
      test('Round up', () {
        expect(GraphConstraints.normalize(17), equals(20));
      });
      test('Round down', () {
        expect(GraphConstraints.normalize(13), equals(10));
      });
      test('Round up for .5', () {
        expect(GraphConstraints.normalize(15), equals(20));
      });
    });
    test('Zero constructor', () {
      final constraints = GraphConstraints.zero();
      expect(constraints.minX, equals(0));
      expect(constraints.maxX, equals(0));
      expect(constraints.minY, equals(0));
      expect(constraints.maxY, equals(0));
    });
    test('Constructor', () {
      final constraints = GraphConstraints(
        minX: 13,
        maxX: 17,
        minY: 23,
        maxY: 27,
      );
      expect(constraints.minX, equals(10));
      expect(constraints.maxX, equals(20));
      expect(constraints.minY, equals(20));
      expect(constraints.maxY, equals(30));
    });
  });
}
