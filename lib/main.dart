// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment.dart';
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
      primaryColor: Colors.greenAccent,
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
  PaymentModel paymentModel = PaymentModel();

  //==== Overrides ====
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      String encodedHistory = prefs.getString("history") ?? "[]";
      setState(() {
        history = jsonDecode(encodedHistory).cast<Map<String, dynamic>>();
        prefsLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!prefsLoaded) return _spinner();

    Widget body = navigationIndex == 0
        ? TipCalculator(
            paymentModel: paymentModel, prefs: prefs, history: history)
        : PaymentHistory(history, prefs);

    return Scaffold(
      appBar: AppBar(title: Text('Tip Main Page')),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Tip Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Payment History',
          ),
        ],
        currentIndex: navigationIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() {
          navigationIndex = index;
        }),
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
