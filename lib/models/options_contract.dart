import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_challenge/models/enums/option_position.dart';
import 'package:flutter_challenge/models/enums/option_type.dart';

/// A class that represents an options contract
class OptionsContract extends Equatable {
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

  const OptionsContract({
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

  /// Calculates the profit/loss at the expiry price
  /// If the option is a call its assumed that the exoiry price is larger than the strike price
  /// If the option is a put its assumed that the expiry price is smaller than the strike price
  /// If the option is a long then the premium is subtracted from the profit/loss
  /// If the option is a short then the premium is added to the profit/loss
  double calculateProfitLoss(double priceAtExpiry) {
    // Change in price relative to the strike price
    // Call: expiry price - strike price
    // Put: strike price - expiry price
    double delta = type == OptionType.call
        ? priceAtExpiry - strikePrice
        : strikePrice - priceAtExpiry;

    // The max change in profit/loss is zero
    delta = max(0, delta);

    return switch (position) {
      OptionPosition.long => delta - premium,
      OptionPosition.short => premium - delta,
    };
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

  @override
  List<Object?> get props =>
      [strikePrice, type, bid, ask, position, expiration];
}

extension OptionsContractListExtension on List<OptionsContract> {
  /// Parses a list of options contracts from a list of maps
  static List<OptionsContract> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => OptionsContract.fromJson(json)).toList();
  }
}
