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

  OptionsContract({
    required this.strikePrice,
    required this.type,
    required this.bid,
    required this.ask,
    required this.position,
    required this.expiration,
  });

  /// Parses an options contract from a map
  factory OptionsContract.fromJson(Map<String, dynamic> json) {
    try {
      return OptionsContract(
        strikePrice: json['strike_price'],
        type: OptionTypeExtension.fromString(json['type']),
        bid: json['bid'],
        ask: json['ask'],
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
