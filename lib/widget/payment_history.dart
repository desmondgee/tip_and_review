import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../currency.dart';

class PaymentHistory extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final SharedPreferences prefs;
  PaymentHistory(this.history, this.prefs);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState(history, prefs);
}

class _PaymentHistoryState extends State<PaymentHistory> {
  //==== Constants ====

  //==== Overrides ====
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;
  _PaymentHistoryState(this.history, this.prefs);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String encodedHistory = prefs.getString("history") ?? "[]";
      history = jsonDecode(encodedHistory).cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          Map payment = history[history.length - index - 1];
          int taxedTotalCents = payment["taxedTotalCents"];
          String formattedTaxedTotal = Currency.formatCents(taxedTotalCents);
          double tipFraction = payment["centipercent"] * 0.01;
          int tipDecimals = tipFraction % 1 < 0.1 ? 0 : 1;
          String formattedTip = tipFraction.toStringAsFixed(tipDecimals) + "\%";
          return ListTile(
              title: Text("Total With Tax was " +
                  formattedTaxedTotal +
                  " and tip was " +
                  formattedTip));
        });
  }
}
