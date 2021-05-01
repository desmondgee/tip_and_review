import '../../currency.dart';
import '../payment.dart';

class UTPayment {
  int subtotalCents = 0;
  int taxCents = 0;
  int tipPercentIndex = 5;

  double tipFraction() {
    return Currency.parsePercent(Payment.tipPercents[tipPercentIndex]);
  }

  int tipCents() {
    return (subtotalCents * tipFraction()).floor();
  }

  int grandTotalCents() {
    return subtotalCents + taxCents + tipCents();
  }

  String formattedSubtotal() {
    return Currency.formatCents(subtotalCents);
  }

  String formattedTax() {
    return Currency.formatCents(taxCents);
  }

  String formattedTip() {
    return Currency.formatCents(tipCents());
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents());
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "UTPayment",
      "subtotalCents": subtotalCents,
      "taxCents": taxCents,
      "centipercent":
          Currency.parseCentipercent(Payment.tipPercents[tipPercentIndex]),
    };
  }

  void setSubtotal(String formattedDollars) {
    subtotalCents = Currency.parseCents(formattedDollars);
  }

  void setTax(String formattedDollars) {
    taxCents = Currency.parseCents(formattedDollars);
  }

  void setTipPercentIndex(int newIndex) {
    tipPercentIndex = newIndex;
  }
}
