// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'currency.dart';

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
  // TODO - move state variables up here to top.

  //==== Widgets ====

  //==== Helper Functions ====

  int navigationIndex = 0;

  final textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 2,
  );

  final headerStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 22,
    height: 2,
  );

  final wheelTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 16,
    height: 1,
  );

  final tipPercents = <String>[
    "0%",
    "5%",
    "10%",
    "12%",
    "14%",
    "15%",
    "16%",
    "17%",
    "18%",
    "20%",
    "25%",
    "30%",
  ];

  var inputTotalController = TextEditingController();

  FixedExtentScrollController inputTipController =
      FixedExtentScrollController(initialItem: 0);

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  bool _disableSave = false;

  _loadPrefs() async {
    _disableSave = true;
    // prevents unexpected null error from .animateToItem on controller by giving time for the list to render.
    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    // tip index of 5 is default for new user.
    int index = prefs.getInt('tipIndex') ?? 5;
    setState(() {
      inputTipController.animateToItem(index,
          duration: Duration(seconds: 2), curve: Curves.elasticOut);
    });
    _disableSave = false;
  }

  _saveTip() async {
    if (_disableSave) return;
    final prefs = await SharedPreferences.getInstance();
    int index = inputTipController.selectedItem;
    setState(() {
      // TODO - should replace view with spinner until this state is ready.
      prefs.setInt('tipIndex', index);
    });
  }

  bool _isSavable() {
    return inputTotalController.text.isNotEmpty &&
        Currency.parseCents(inputTotalController.text) > 0;
  }

  void _saveToHistory() async {
    // serialize json {"centipercent", "taxedTotalCents"}
    Map<String, dynamic> json = {
      "taxedTotalCents": Currency.parseCents(inputTotalController.text),
      "centipercent":
          (Currency.parsePercent(tipPercents[inputTipController.selectedItem]) *
                  100)
              .round(),
    };
    String jsonString = jsonEncode(json);
    // save to pref
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];
    history.add(jsonString);
    prefs.setStringList("history", history);
    // clear input text
    inputTotalController.clear();
  }

  void _navigationBarHandler(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tip Main Page')),
      body: _pickBody(),
      floatingActionButton: _isSavable()
          ? FloatingActionButton(
              onPressed: () {
                _saveToHistory();
              },
              child: Icon(Icons.bookmarks_outlined),
              backgroundColor: Colors.teal,
              tooltip: "Save Payments To History",
            )
          : null,
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
        onTap: _navigationBarHandler,
      ),
    );
  }

  Widget _pickBody() {
    switch (navigationIndex) {
      case 0:
        return _tipCalculatorBody();
      default:
        return _paymentHistoryBody();
    }
  }

  Widget _tipCalculatorBody() {
    return SingleChildScrollView(
        child: Column(children: [_youPayBlock(), _basedOnBlock()]));
  }

  Iterable<Map<String, dynamic>> history;

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonStrings = prefs.getStringList("history") ?? [];
    Iterable<Map<String, dynamic>> jsonEntries =
        jsonStrings.map((e) => jsonDecode(e));

    setState(() {
      history = jsonEntries;
    });
  }

  Widget _spinner() {
    return Center(
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: CircularProgressIndicator()));
  }

  Widget _paymentHistoryBody() {
    if (history == null) {
      _loadHistory();
      return _spinner();
    }

    // return _spinner();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          // int taxedTotalCents = history.elementAt(index)["taxedTotalCents"];
          // String formattedTaxedTotal = Currency.formatCents(taxedTotalCents);
          return ListTile(title: Text("HELLO"));
        });
  }

  Widget _youPayBlock() {
    int inputCents = Currency.parseCents(inputTotalController.text);
    // can't access selectedItem until controller is attached to view
    // String formattedTipPercent = tipPercents[inputTipController.selectedItem];
    int index =
        inputTipController.hasClients ? inputTipController.selectedItem : 5;
    String formattedTipPercent = tipPercents[index];
    double tipFraction = Currency.parsePercent(formattedTipPercent);
    int tipCents = (inputCents * tipFraction).floor();
    int totalCents = inputCents + tipCents;

    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(children: [
                      Text("You Pay", style: headerStyle),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 140,
                                child: Text(
                                  "Tip Amount:",
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 140,
                                child: Text(
                                  Currency.formatCents(tipCents),
                                  style: textStyle,
                                  textAlign: TextAlign.right,
                                ))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 140,
                                child: Text(
                                  "Total Amount:",
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 140,
                                child: Text(
                                  Currency.formatCents(totalCents),
                                  style: textStyle,
                                  textAlign: TextAlign.right,
                                ))
                          ]),
                    ])))));
  }

  Widget _basedOnBlock() {
    final tipTiles = tipPercents.map(
      (String value) {
        return ListTile(
          title: Text(
            value,
            style: wheelTextStyle,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
    final dividedTipTiles = ListTile.divideTiles(
      context: context,
      tiles: tipTiles,
    ).toList();

    final scrollerVersion3 = SizedBox(
        width: 100,
        height: 150,
        child: CupertinoPicker(
          itemExtent: 44,
          children: dividedTipTiles,
          scrollController: inputTipController,
          onSelectedItemChanged: (newIndex) => _saveTip(),
        ));

    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.all(20.0),
                child: Column(children: [
                  Text("Based On", style: headerStyle),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Text("After Tax Total", style: textStyle),
                          SizedBox(
                              width: 100,
                              child: TextField(
                                  controller: inputTotalController,
                                  keyboardType: TextInputType.number,
                                  // don't need to set any variables b/c controller contains updated value.
                                  onChanged: (value) => setState(() => null),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      String text = Currency.reformatDollars(
                                          newValue.text);
                                      return TextEditingValue(
                                          text: text,
                                          selection: TextSelection.collapsed(
                                              // offset > length safe in chrome but crashes android.
                                              offset: text.length));
                                    })
                                  ],
                                  decoration: InputDecoration(
                                      // tried prefixText but has weird issue where it only shows when field is clicked. however hintText shows when not clicked and clicked until something is typed. So you will see `$$` when clicked but nothing is typed yet.
                                      border: OutlineInputBorder(),
                                      hintText: "\$0.00")))
                        ]),
                        Column(children: [
                          Text("After Tax Tip", style: textStyle),
                          scrollerVersion3
                        ])
                      ]),
                ]))));
  }
}
