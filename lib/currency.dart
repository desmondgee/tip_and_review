class Currency {
  // Converts a formatted dollar value such as `$12.50` into a cents integer as `1250`
  // Trims trailing digits to become less than `$10,000`. i.e. `$1,234,567.89` becomes `123456` cents. This is to stop addition number input when value is too high already for input box.
  static int parseCents(String formattedDollars) {
    String strCents = formattedDollars.splitMapJoin((RegExp(r'[0-9]')),
        onNonMatch: (n) => '');

    int cents = strCents == '' ? 0 : int.parse(strCents);
    if (cents > 999999) {
      cents = (cents * 0.1).floor();
    }
    return cents;
  }

  static String formatCents(int cents) {
    double dollars = cents / 100;
    return '\$' + dollars.toStringAsFixed(2);
  }

  static String reformatDollars(String formattedDollars) {
    return formatCents(parseCents(formattedDollars));
  }

  // Converts a formatted percent such as `12.5%` into a multipliable double such as `0.125`
  static double parsePercent(String formattedPercent) {
    String numbers =
        RegExp(r'[0-9]+\.?[0-9]*').stringMatch(formattedPercent) ?? '0';
    return double.parse(numbers) * 0.01;
  }

  // Converts a multiplicable double such as `0.125` into a formatted percent such as `12.5%`
  static String formatPercent(double fraction, {int trailing: 0}) {
    return (fraction * 100).toStringAsFixed(trailing) + "%";
  }
}
