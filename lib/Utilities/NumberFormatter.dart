class NumberFormatter {
  static String formatHumanReadable(num number) {
    const suffixes = [
      {'value': 1e18, 'suffix': 'Qi'}, // Quintillion
      {'value': 1e15, 'suffix': 'Q'},  // Quadrillion
      {'value': 1e12, 'suffix': 'T'},  // Trillion
      {'value': 1e9,  'suffix': 'B'},  // Billion
      {'value': 1e6,  'suffix': 'M'},  // Million
      {'value': 1e3,  'suffix': 'K'},  // Thousand
    ];

    for (final item in suffixes) {
      final value = item['value'] as double;
      final suffix = item['suffix'] as String;

      if (number >= value) {
        return _format(number / value, suffix);
      }
    }

    return number.toString(); // Dưới 1000 thì không rút gọn
  }

  static String _format(double value, String suffix) {
    String formatted = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
    return '$formatted$suffix';
  }
}
