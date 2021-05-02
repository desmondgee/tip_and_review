import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryMixin {
  List<Map<String, dynamic>> get history;
  SharedPreferences get prefs;

  void saveToHistory(Map<String, dynamic> json) {
    history.add(json);
    prefs.setString("history", jsonEncode(history));
  }
}
