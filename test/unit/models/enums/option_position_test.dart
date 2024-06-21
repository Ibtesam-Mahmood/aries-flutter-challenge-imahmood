import 'package:flutter_challenge/models/enums/option_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionPosition ->', () {
    test('Long enum name is statically set', () {
      expect(
          OptionPosition.long.name, equals(OptionPositionExtension.longName));
    });
    test('Short enum name is statically set', () {
      expect(
          OptionPosition.short.name, equals(OptionPositionExtension.shortName));
    });
  });

  group('OptionPositionExtension ->', () {
    test('fromString returns Long for "Long"', () {
      expect(
          OptionPositionExtension.fromString(OptionPositionExtension.longName),
          equals(OptionPosition.long));
    });

    test('fromString returns Short for "Short"', () {
      expect(
          OptionPositionExtension.fromString(OptionPositionExtension.shortName),
          equals(OptionPosition.short));
    });

    test('fromString throws exception for invalid name', () {
      expect(() => OptionPositionExtension.fromString('Invalid'),
          throwsA(isA<Exception>()));
    });
  });
}
