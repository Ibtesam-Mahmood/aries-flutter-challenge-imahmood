import 'package:flutter_challenge/models/enums/option_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionType ->', () {
    test('Call enum name is statically set', () {
      expect(OptionType.call.name, equals(OptionTypeExtension.callName));
    });
    test('Put enum name is statically set', () {
      expect(OptionType.put.name, equals(OptionTypeExtension.putName));
    });
  });

  group('OptionTypeExtension ->', () {
    test('fromString returns Call for "Call"', () {
      expect(OptionTypeExtension.fromString(OptionTypeExtension.callName),
          equals(OptionType.call));
    });

    test('fromString returns Put for "Put"', () {
      expect(OptionTypeExtension.fromString(OptionTypeExtension.putName),
          equals(OptionType.put));
    });

    test('fromString throws exception for invalid name', () {
      expect(() => OptionTypeExtension.fromString('Invalid'),
          throwsA(isA<Exception>()));
    });
  });
}
