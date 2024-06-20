import 'dart:math';

import 'package:flutter_challenge/models/enums/option_position.dart';
import 'package:flutter_challenge/models/enums/option_type.dart';

/// A class that represents an options contract
class OptionsContract {
  final double strikePrice;
  final OptionType type;
  final double bid;
  final double ask;
  final OptionPosition position;
  final DateTime expiration;

  /// Assume the premium for the option contract is the average of the bid and ask
  double get premium => (bid + ask) / 2;

  /// The profit from the premium within the contract. Long positions are negative
  double get premiumProfit =>
      position == OptionPosition.short ? premium : -premium;

  OptionsContract({
    required this.strikePrice,
    required this.type,
    required this.bid,
    required this.ask,
    required this.position,
    required this.expiration,
  });

  /// Calulates the break even point for the options contract
  double getBreakEvenPoint() {
    return switch (type) {
      OptionType.call => premium + strikePrice,
      OptionType.put => strikePrice - premium,
    };
  }

  /// Calculates the x value to show for the max profit/loss point
  double getMaxPoint() {
    return strikePrice + (position == OptionPosition.long ? -1 : 1) * 5;
  }

  // TODO: Document this method
  double calculateProfitLoss(double priceAtExpiry) {
    // Change in price relative to the strike price
    // Call: expiry price - strike price
    // Put: strike price - expiry price
    double delta = type == OptionType.call
        ? priceAtExpiry - strikePrice
        : strikePrice - priceAtExpiry;

    // The max change in profit/loss is zero
    delta = max(0, delta);

    switch (position) {
      case OptionPosition.long:
        return delta - premium;

      // OptionPosition.short
      default:
        return premium - delta;
    }
  }

  /// Parses an options contract from a map
  factory OptionsContract.fromJson(Map<String, dynamic> json) {
    try {
      return OptionsContract(
        strikePrice: json['strike_price'].toDouble(),
        type: OptionTypeExtension.fromString(json['type']),
        bid: json['bid'].toDouble(),
        ask: json['ask'].toDouble(),
        position: OptionPositionExtension.fromString(json['long_short']),
        expiration: DateTime.parse(json['expiration_date']),
      );
    } catch (e) {
      throw Exception('Invalid options contract: $json');
    }
  }
}

extension OptionsContractListExtension on List<OptionsContract> {
  /// Parses a list of options contracts from a list of maps
  static List<OptionsContract> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => OptionsContract.fromJson(json)).toList();
  }
}
