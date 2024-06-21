import 'package:flutter_challenge/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constants ->', () {
    test('Validate axis margin', () {
      expect(Constants.axisMargin, 30);
    });
    test('Validate contract max', () {
      expect(Constants.contractsMaxCount, 4);
    });
    test('Validate colors', () {
      expect(Constants.lineColors.length, 15);
    });
  });
}
