import 'package:flutter_challenge/models/enums/option_position.dart';
import 'package:flutter_challenge/models/enums/option_type.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionsContract ->', () {
    // Test properties
    test('props returns correct properties', () {
      final contract = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      expect(
        contract.props,
        [
          100.0,
          OptionType.call,
          2.0,
          3.0,
          OptionPosition.long,
          contract.expiration,
        ],
      );
    });

    test('fromJson returns parse', () {
      final contract = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      final json = {
        'strike_price': 100.0,
        'type': 'Call',
        'bid': 2.0,
        'ask': 3.0,
        'long_short': 'Long',
        'expiration_date': contract.expiration.toIso8601String(),
      };
      expect(OptionsContract.fromJson(json), contract);
    });

    // Test premium calculation
    test('premium is the average of bid and ask', () {
      final contract = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      expect(contract.premium, 2.5);
    });

    // Test premium profit calculation
    test('premiumProfit is premium for short and -premium for long', () {
      final contractLong = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      final contractShort = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.short,
        expiration: DateTime.now(),
      );
      expect(contractLong.premiumProfit, -2.5);
      expect(contractShort.premiumProfit, 2.5);
    });

    // Test break even point calculation
    test('getBreakEvenPoint for call option', () {
      final contract = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.call,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      expect(contract.getBreakEvenPoint(), 102.5);
    });

    test('getBreakEvenPoint for put option', () {
      final contract = OptionsContract(
        strikePrice: 100.0,
        type: OptionType.put,
        bid: 2.0,
        ask: 3.0,
        position: OptionPosition.long,
        expiration: DateTime.now(),
      );
      expect(contract.getBreakEvenPoint(), 97.5);
    });

    group('calculateProfitLoss ->', () {
      // Test profit loss calculation for call option
      test('calculateProfitLoss for call option', () {
        final contractLong = OptionsContract(
          strikePrice: 100.0,
          type: OptionType.call,
          bid: 2.0,
          ask: 3.0,
          position: OptionPosition.long,
          expiration: DateTime.now(),
        );
        final contractShort = OptionsContract(
          strikePrice: 100.0,
          type: OptionType.call,
          bid: 2.0,
          ask: 3.0,
          position: OptionPosition.short,
          expiration: DateTime.now(),
        );
        expect(contractLong.calculateProfitLoss(105.0), 2.5);
        expect(contractShort.calculateProfitLoss(105.0), -2.5);
      });

      // Test profit loss calculation for put option
      test('calculateProfitLoss for put option', () {
        final contractLong = OptionsContract(
          strikePrice: 100.0,
          type: OptionType.put,
          bid: 2.0,
          ask: 3.0,
          position: OptionPosition.long,
          expiration: DateTime.now(),
        );
        final contractShort = OptionsContract(
          strikePrice: 100.0,
          type: OptionType.put,
          bid: 2.0,
          ask: 3.0,
          position: OptionPosition.short,
          expiration: DateTime.now(),
        );
        expect(contractLong.calculateProfitLoss(95.0), 2.5);
        expect(contractShort.calculateProfitLoss(95.0), -2.5);
      });
    });
  });
}
