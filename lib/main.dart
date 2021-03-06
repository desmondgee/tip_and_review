// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/action_button_model.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/widget/payment_history.dart';
import 'package:flutterapp/widget/tip_calculator.dart';
import 'package:provider/provider.dart';
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
        prefsLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!prefsLoaded) return _spinner();

    var calculatorModel =
        CalculatorModel(history: history, prefs: prefs, context: context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => calculatorModel),
        ChangeNotifierProvider(create: (context) => calculatorModel.modeModel),
        ChangeNotifierProvider(
            create: (context) => calculatorModel.summaryModel),
        ChangeNotifierProvider(create: (context) => calculatorModel.stepModel),
        ChangeNotifierProvider(create: (context) => calculatorModel.splitModel),
        ChangeNotifierProvider(create: (context) => ActionButtonModel()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(navigationTitles[navigationIndex])),
        body: navigationIndex == 0
            ? TipCalculator()
            : PaymentHistory(history, prefs),
        backgroundColor: Style.backgroundColor,
        floatingActionButton: Consumer<ActionButtonModel>(
          builder: (context, buttonModel, _) => AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.easeInOutBack,
            child: buttonModel.widget,
          ),
        ),
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
              Dismissible(
                  key: ValueKey<int>(0),
                  child: ListTile(
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
                  )),
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
