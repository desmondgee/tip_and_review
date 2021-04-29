import 'package:flutter/cupertino.dart';
import '../currency.dart';

class PaymentModel with ChangeNotifier {
  static final tipPercents = <String>[
    "0%",
    "5%",
    "10%",
    "12%",
    "14%",
    "15%",
    "16%",
    "17%",
    "18%",
    "20%",
    "25%",
    "30%",
  ];

  // Totals are defined as follows:
  // subtotal = item costs + any special taxes or fees
  // taxedTotal = subtotal + tax
  // grandTotal = subtotal + tax + tip

  int taxedTotalCents = 0;
  int tipPercentIndex = 5;

  double tipFraction() {
    return Currency.parsePercent(tipPercents[tipPercentIndex]);
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

  String formattedTipTotal() {
    return Currency.formatCents(tipCents());
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents());
  }

  Map<String, dynamic> toJson() {
    return {
      "taxedTotalCents": taxedTotalCents,
      "centipercent": Currency.parseCentipercent(tipPercents[tipPercentIndex]),
    };
  }

  void setTaxedTotal(String formattedDollars) {
    taxedTotalCents = Currency.parseCents(formattedDollars);
  }

  void setTipPercentIndex(int newIndex) {
    tipPercentIndex = newIndex;
  }
}
