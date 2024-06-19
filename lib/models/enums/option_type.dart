/// The type of the options contract
/// Determines if the option is a call or put
enum OptionType {
  call(OptionTypeExtension.callName),
  put(OptionTypeExtension.putName);

  const OptionType(this.name);
  final String name;
}

/// An extension on the OptionType enum to add additional functionality for parsing
extension OptionTypeExtension on OptionType {
  static const String callName = 'Call';
  static const String putName = 'Put';

  static fromString(String name) {
    return switch (name) {
      callName => OptionType.call,
      putName => OptionType.put,
      _ => throw Exception('Invalid option type: $name'),
    };
  }
}
