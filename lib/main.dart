// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

// Converts a formatted dollar value such as `$12.50` into a cents integer as `1250`
// Trims trailing digits to become less than `$10,000`. i.e. `$1,234,567.89` becomes `123456` cents. This is to stop addition number input when value is too high already for input box.
int parseCents(String formattedDollars) {
  String strCents =
      formattedDollars.splitMapJoin((RegExp(r'[0-9]')), onNonMatch: (n) => '');

  int cents = strCents == '' ? 0 : int.parse(strCents);
  if (cents > 999999) {
    cents = (cents * 0.1).floor();
  }
  return cents;
}

// TODO: Add comma separators.
String formatCents(int cents) {
  double dollars = cents / 100;
  return '\$' + dollars.toStringAsFixed(2);
}

String reformatDollars(String formattedDollars) {
  return formatCents(parseCents(formattedDollars));
}

// Converts a formatted percent such as `12.5%` into a multipliable double such as `0.125`
double parsePercent(String formattedPercent) {
  String numbers =
      RegExp(r'[0-9]+\.?[0-9]*').stringMatch(formattedPercent) ?? '0';
  return double.parse(numbers) * 0.01;
}

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

  int _tipValue = 15;

  var inputTotalController = TextEditingController();

  int selectedIndex = 5;
  FixedExtentScrollController inputTipController;

  @override
  void initState() {
    inputTipController =
        FixedExtentScrollController(initialItem: selectedIndex);
    super.initState();
    _loadPrefs();
  }

  bool _disableSave = false;

  _loadPrefs() async {
    _disableSave = true;
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('tipIndex');
    if (index != null) {
      setState(() {
        selectedIndex = index;
        // inputTipController.jumpToItem(index);
      });
    }
    _disableSave = false;
  }

  _saveTip() async {
    if (_disableSave) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int index = inputTipController.selectedItem;
      prefs.setInt('tipIndex', index);
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tip Main Page')),
      body: SingleChildScrollView(
          child: Column(children: [_youPayBlock(), _basedOnBlock()])),
    );
  }

  Widget _youPayBlock() {
    int inputCents = parseCents(inputTotalController.text);
    // can't access selectedItem until controller is attached to view
    // String formattedTipPercent = tipPercents[inputTipController.selectedItem];
    String formattedTipPercent = tipPercents[selectedIndex];
    double tipFraction = parsePercent(formattedTipPercent);
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
                                  formatCents(tipCents),
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
                                  formatCents(totalCents),
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

    final scrollerVersion1 = SizedBox(
        width: 100,
        height: 100,
        child: ListWheelScrollView(
          itemExtent: 44,
          children: dividedTipTiles,
          useMagnifier: true,
          magnification: 1,
          diameterRatio: 4,
        ));

    final scrollerVersion2 = SizedBox(
        width: 100,
        height: 200,
        child: NumberPicker(
            value: _tipValue,
            minValue: 0,
            maxValue: 100,
            onChanged: (value) => setState(() => _tipValue = value)));

    // inputTipController =
    //     FixedExtentScrollController(initialItem: selectedIndex);
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
                                  // onChanged: (value) =>
                                  //     setState(() => inputTotal = value),
                                  // don't need to set any variables b/c controller contains updated value.
                                  onChanged: (value) => setState(() => null),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      String text =
                                          reformatDollars(newValue.text);
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

MaterialApp exampleApp() {
  return MaterialApp(
    title: 'Startup Name Generator',
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
    home: RandomWords(),
  );
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListWheelScrollView(
              itemExtent: 84,
              children: divided,
              useMagnifier: true,
              magnification: 1,
              diameterRatio: 1.5,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }
}
