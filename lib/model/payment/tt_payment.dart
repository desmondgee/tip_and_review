import 'package:flutterapp/model/payment/notes_mixin.dart';

import '../../currency.dart';
import '../payment.dart';

class TTPayment with NotesMixin {
  int taxedTotalCents = 0;
  int tipPercentIndex = 5;

  double tipFraction() {
    return Currency.parsePercent(Payment.tipPercents[tipPercentIndex]);
  }

  int tipCents() {
    return (taxedTotalCents * tipFraction()).floor();
  }

  int grandTotalCents() {
    return taxedTotalCents + tipCents();
  }

  String formattedTaxedTotal() {
    return Currency.formatCents(taxedTotalCents);
  }

  String formattedTip() {
    return Currency.formatCents(tipCents());
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents());
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "TTPayment",
      "taxedTotalCents": taxedTotalCents,
      "centipercent":
          Currency.parseCentipercent(Payment.tipPercents[tipPercentIndex]),
    };
  }

  void setTaxedTotal(String formattedDollars) {
    taxedTotalCents = Currency.parseCents(formattedDollars);
  }

  void setTipPercentIndex(int newIndex) {
    tipPercentIndex = newIndex;
  }
}
