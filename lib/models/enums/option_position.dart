/// An enum that representions the option position, long or short
enum OptionPosition {
  long(OptionPositionExtension.longName),
  short(OptionPositionExtension.shortName);

  const OptionPosition(this.name);
  final String name;
}

/// An extension on the OptionPosition enum to add additional functionality for parsing
extension OptionPositionExtension on OptionPosition {
  static const String longName = 'long';
  static const String shortName = 'short';

  static fromString(String name) {
    return switch (name) {
      longName => OptionPosition.long,
      shortName => OptionPosition.short,
      _ => throw Exception('Invalid option position: $name'),
    };
  }
}
