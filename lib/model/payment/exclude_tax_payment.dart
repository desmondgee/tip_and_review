import 'package:flutterapp/model/payment/history_mixin.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../currency.dart';
import '../payment.dart';

class ExcludeTaxPayment with NotesMixin, HistoryMixin {
  int subtotalCents = 0;
  int taxCents = 0;
  int tipIndex = 5;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;

  ExcludeTaxPayment({this.history, this.prefs});

  double tipFraction() {
    return Currency.parsePercent(Payment.tipPercents[tipIndex]);
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
    var json = {
      "type": "ExcludeTaxPayment",
      "datetime": DateTime.now().millisecondsSinceEpoch,
      "subtotalCents": subtotalCents,
      "taxCents": taxCents,
      "grandTotalCents": grandTotalCents(),
      "tipCents": tipCents(),
    };
    json.addAll(notesJson());
    return json;
  }

  void setSubtotal(String formattedDollars) {
    subtotalCents = Currency.parseCents(formattedDollars);
  }

  void setTax(String formattedDollars) {
    taxCents = Currency.parseCents(formattedDollars);
  }

  void setTipPercentIndex(int newIndex) {
    tipIndex = newIndex;
  }

  void save() {
    saveToHistory(toJson());
    subtotalCents = 0;
    taxCents = 0;
    clearNotes();
  }

  void clear() {
    subtotalCents = 0;
    taxCents = 0;
    clearNotes();
  }
}
