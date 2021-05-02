import 'package:flutterapp/model/payment/history_mixin.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../currency.dart';
import '../payment.dart';

class TTPayment with NotesMixin, HistoryMixin {
  int taxedTotalCents = 0;
  int tipIndex = 5;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;

  TTPayment({this.history, this.prefs}) {
    tipIndex = prefs.getInt("tip_index") ?? 5;
  }

  double tipFraction() {
    return Currency.parsePercent(Payment.tipPercents[tipIndex]);
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
      "grandTotalCents": grandTotalCents(),
      "tipCents": tipCents(),
    };
  }

  void setTaxedTotal(String formattedDollars) {
    taxedTotalCents = Currency.parseCents(formattedDollars);
  }

  void setTipPercentIndex(int newIndex) {
    tipIndex = newIndex;
    prefs.setInt("tip_index", newIndex);
  }

  void save() {
    saveToHistory(toJson());
    taxedTotalCents = 0;
  }
}
