import 'package:flutterapp/model/payment/history_mixin.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../currency.dart';

class MPayment with NotesMixin, HistoryMixin {
  int tipCents = 0;
  int grandTotalCents = 0;
  int tipIndex = 5;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;

  MPayment({this.history, this.prefs});

  String formattedTip() {
    return Currency.formatCents(tipCents);
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents);
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "MPayment",
      "datetime": DateTime.now().millisecondsSinceEpoch,
      "grandTotalCents": grandTotalCents,
      "tipCents": tipCents
    };
  }

  void setGrandTotal(String formattedDollars) {
    grandTotalCents = Currency.parseCents(formattedDollars);
  }

  void setTip(String formattedDollars) {
    tipCents = Currency.parseCents(formattedDollars);
  }

  void save() {
    saveToHistory(toJson());
    grandTotalCents = 0;
    tipCents = 0;
  }
}
