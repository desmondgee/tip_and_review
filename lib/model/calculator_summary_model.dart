import 'package:flutter/cupertino.dart';
import 'package:flutterapp/currency.dart';

class CalculatorSummaryModel extends ChangeNotifier {
  int grandTotalCents = 0;
  int tipCents = 0;

  String get formattedGrandTotal => Currency.formatCents(grandTotalCents);
  String get formattedTip => Currency.formatCents(tipCents);

  void update({newFormattedGrandTotal, newFormattedTip}) {
    grandTotalCents = Currency.parseCents(newFormattedGrandTotal);
    tipCents = Currency.parseCents(newFormattedTip);
    notifyListeners();
  }

  bool get savable {
    return formattedGrandTotal != "\$0.00";
  }
}
