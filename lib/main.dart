// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment/m_payment.dart';
import 'package:flutterapp/model/payment/tt_payment.dart';
import 'package:flutterapp/model/payment/ut_payment.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/widget/payment_history.dart';
import 'package:flutterapp/widget/tip_calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return tipApp();
  }
}

MaterialApp tipApp() {
  return MaterialApp(
    title: 'Tip App',
    theme: ThemeData(
      primaryColor: Color.fromRGBO(192, 169, 112, 1),
    ),
    home: TipMain(),
  );
}

class TipMain extends StatefulWidget {
  @override
  _TipMainState createState() => _TipMainState();
}

class _TipMainState extends State<TipMain> {
  //==== State Variables ====
  int previousTipIndex;
  int navigationIndex = 0;
  List<Map<String, dynamic>> history;
  bool prefsLoaded = false;
  SharedPreferences prefs;

  var ttPayment;
  var utPayment;
  var mPayment;

  var navigationTitles = ["Tip Calculator", "Payment History"];

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      String encodedHistory = prefs.getString("history") ?? "[]";
      setState(() {
        history = jsonDecode(encodedHistory).cast<Map<String, dynamic>>();
        ttPayment = TTPayment(history: history, prefs: prefs);
        utPayment = UTPayment(history: history, prefs: prefs);
        mPayment = MPayment(history: history, prefs: prefs);
        prefsLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!prefsLoaded) return _spinner();

    Widget body = navigationIndex == 0
        ? TipCalculator(
            ttPayment: ttPayment, utPayment: utPayment, mPayment: mPayment)
        : PaymentHistory(history, prefs);

    return Scaffold(
      appBar: AppBar(title: Text(navigationTitles[navigationIndex])),
      body: body,
      backgroundColor: Style.backgroundColor,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Tip & Review',
                  style: Style.headerStyle,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate_outlined),
              title: Text('Tip Calculator'),
              onTap: () {
                // Update the state of the app
                setState(() {
                  navigationIndex = 0;
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Payment History'),
              onTap: () {
                // Update the state of the app
                setState(() {
                  navigationIndex = 1;
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //==== Widgets ====
  Widget _spinner() {
    return Center(
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: CircularProgressIndicator()));
  }
}
