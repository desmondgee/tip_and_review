import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment.dart';
import 'package:flutterapp/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Center(
        child: SizedBox(
            width: 500,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: history.length,
                itemBuilder: (BuildContext context, int index) {
                  Payment payment =
                      Payment.fromJson(history[history.length - index - 1]);
                  String text = "Paid ${payment.formattedGrandTotal()}";

                  if (payment.location != null)
                    text += " to ${payment.location}";

                  return ListTile(
                    title: Text(payment.formattedDateTime()),
                    subtitle: Text(text),
                    onTap: () => _showMyDialog(payment),
                  );
                })));
  }

  _showMyDialog(Payment payment) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(payment.formattedDateTime()),
          content: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Table(
                      children: [
                        TableRow(children: [
                          Text("Tip Amount", style: Style.labelStyle),
                          Text(payment.formattedTip(), style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Post-Tax Tip Percent", style: Style.labelStyle),
                          Text(payment.formattedTipPercent(),
                              style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Total Paid Amount", style: Style.labelStyle),
                          Text(payment.formattedGrandTotal(),
                              style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Location", style: Style.labelStyle),
                          Text(payment.location ?? "", style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Food Rating", style: Style.labelStyle),
                          Text(payment.foodRatingLabel() ?? "",
                              style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Pricing", style: Style.labelStyle),
                          Text(payment.pricingLabel() ?? "",
                              style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Experience", style: Style.labelStyle),
                          Text(payment.experienceLabel() ?? "",
                              style: Style.labelStyle)
                        ]),
                        TableRow(children: [
                          Text("Notes", style: Style.labelStyle),
                          Text(payment.notes ?? "", style: Style.labelStyle)
                        ]),
                      ],
                    )
                  ],
                ),
              )),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
