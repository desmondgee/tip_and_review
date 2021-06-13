import 'package:flutterapp/model/payment/history_mixin.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../currency.dart';

class CustomPayment with NotesMixin, HistoryMixin {
  int tipCents = 0;
  int grandTotalCents = 0;
  int tipIndex = 5;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;

  CustomPayment({this.history, this.prefs});

  String formattedTip() {
    return Currency.formatCents(tipCents);
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents);
  }

  Map<String, dynamic> toJson() {
    var json = {
      "type": "CustomPayment",
      "datetime": DateTime.now().millisecondsSinceEpoch,
      "grandTotalCents": grandTotalCents,
      "tipCents": tipCents
    };
    json.addAll(notesJson());
    return json;
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
    clearNotes();
  }

  void clear() {
    grandTotalCents = 0;
    tipCents = 0;
    clearNotes();
  }
}
