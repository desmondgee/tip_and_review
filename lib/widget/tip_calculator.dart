import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../currency.dart';
import '../model/payment.dart';
import '../style.dart';
import 'page_dots.dart';

class TipCalculator extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final PaymentModel paymentModel;
  final SharedPreferences prefs;
  final int pages = 3;
  TipCalculator({this.paymentModel, this.prefs, this.history});

  @override
  TipCalculatorState createState() =>
      TipCalculatorState(paymentModel, prefs, history);
}

class TipCalculatorState extends State<TipCalculator> {
  //==== State Variables ====
  var inputTotalController = TextEditingController();
  var inputTipController = FixedExtentScrollController(initialItem: 0);
  var pageController;
  List<Map<String, dynamic>> history;
  final PaymentModel paymentModel;
  final SharedPreferences prefs;
  int foodRating = 2;
  int pricing = 2;
  int experience = 1;
  int pageIndex = 0;

  //==== Overrides ====
  TipCalculatorState(this.paymentModel, this.prefs, this.history);

  @override
  void initState() {
    super.initState();

    pageController = PageController(
        initialPage: widget.pages * 100); // can't scroll below 0 fix.

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      inputTotalController.text = paymentModel.formattedTaxedTotal();
      inputTipController.jumpToItem(paymentModel.tipPercentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("tip calculator page index - " + pageIndex.toString());

    return Scaffold(
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
        body: Column(children: [
          PageDots(index: pageIndex, length: widget.pages),
          Expanded(
              child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) =>
                      setState(() => pageIndex = value % widget.pages),
                  itemBuilder: (_, i) {
                    switch (i % 3) {
                      case 0:
                        return _page1();
                      case 1:
                        return _page2();
                      default:
                        return _page3();
                    }
                  }))
        ]));
  }

  //==== Pages ====
  Widget _page1() {
    return SingleChildScrollView(
        child: Column(children: [
      Center(child: Text("Tip Calculator Version A", style: Style.headerStyle)),
      _youPayCardBlock(),
      _basedOnCardBlock(),
      _notesCardBlock(),
    ]));
  }

  Widget _page2() {
    return Center(child: Text("Page 2"));
  }

  Widget _page3() {
    return Center(child: Text("Page 3"));
  }

  //==== Card Blocks ====
  Widget _youPayCardBlock() {
    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(children: [
                      Text("You Pay", style: Style.headerStyle),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 140,
                                child: Text(
                                  "Tip Amount:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 140,
                                child: Text(
                                  paymentModel.formattedTipTotal(),
                                  style: Style.labelStyle,
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
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 140,
                                child: Text(
                                  paymentModel.formattedGrandTotal(),
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.right,
                                ))
                          ]),
                    ])))));
  }

  Widget _basedOnCardBlock() {
    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.all(20.0),
                child: Column(children: [
                  Text("Based On", style: Style.headerStyle),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_taxedTotalInput(), _tipScroller()]),
                ]))));
  }

  Widget _notesCardBlock() {
    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.all(20.0),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(children: [
                      Text("Other Info", style: Style.headerStyle),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text(
                                  "Location:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 240,
                                child: TextField(
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.right,
                                ))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110,
                                child: Text(
                                  "Food:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  _foodRatingLabel(),
                                  style: Style.textStyle,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                                width: 180,
                                child: Slider.adaptive(
                                    value: foodRating * 1.0,
                                    onChanged: (newRating) {
                                      setState(
                                          () => foodRating = newRating.round());
                                    },
                                    min: 0,
                                    max: 4,
                                    divisions: 4)),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110,
                                child: Text(
                                  "Pricing:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  _pricingLabel(),
                                  style: Style.textStyle,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                                width: 180,
                                child: Slider.adaptive(
                                    value: pricing * 1.0,
                                    onChanged: (newRating) {
                                      setState(
                                          () => pricing = newRating.round());
                                    },
                                    min: 0,
                                    max: 6,
                                    divisions: 6))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110,
                                child: Text(
                                  "Experience:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  _experienceLabel(),
                                  style: Style.textStyle,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                                width: 180,
                                child: Slider.adaptive(
                                    value: experience * 1.0,
                                    onChanged: (newRating) {
                                      setState(
                                          () => experience = newRating.round());
                                    },
                                    min: 0,
                                    max: 2,
                                    divisions: 2))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text(
                                  "Notes:",
                                  style: Style.labelStyle,
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                width: 240,
                                child: TextField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: null))
                          ]),
                    ])))));
  }

  //==== Card Subwidgets ====
  Widget _taxedTotalInput() {
    return Column(children: [
      Text("After Tax Total", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: inputTotalController,
              keyboardType: TextInputType.number,
              // don't need to set any variables b/c controller contains updated value.
              onChanged: (value) =>
                  setState(() => paymentModel.setTaxedTotal(value)),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String text = Currency.reformatDollars(newValue.text);
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
    ]);
  }

  Widget _tipScroller() {
    final tipTiles = PaymentModel.tipPercents.map(
      (String value) {
        return ListTile(
          title: Text(
            value,
            style: Style.wheelTextStyle,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
    final dividedTipTiles = ListTile.divideTiles(
      context: context,
      tiles: tipTiles,
    ).toList();

    return Column(children: [
      Text("After Tax Tip", style: Style.labelStyle),
      SizedBox(
          width: 100,
          height: 150,
          child: CupertinoPicker(
            itemExtent: 44,
            children: dividedTipTiles,
            scrollController: inputTipController,
            onSelectedItemChanged: (newIndex) => setState(() {
              paymentModel.setTipPercentIndex(newIndex);
            }),
          ))
    ]);
  }

  //==== Helper Functions ====
  bool _isSavable() {
    return inputTotalController.text.isNotEmpty &&
        Currency.parseCents(inputTotalController.text) > 0;
  }

  void _saveToHistory() async {
    Map<String, dynamic> payment = paymentModel.toJson();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      inputTotalController.clear();
      paymentModel.taxedTotalCents = 0;
      history.add(payment);
      prefs.setString("history", jsonEncode(history));
    });
  }

  String _foodRatingLabel() {
    switch (foodRating) {
      case 4:
        return "Amazing";
      case 3:
        return "Very Good";
      case 2:
        return "Good";
      case 1:
        return "Decent";
      default:
        return "Bad";
    }
  }

  String _pricingLabel() {
    switch (pricing) {
      case 6:
        return "\$100+";
      case 5:
        return "\$50 - \$100";
      case 4:
        return "\$30 - \$50";
      case 3:
        return "\$20 - \$30";
      case 2:
        return "\$15 - \$20";
      case 1:
        return "\$10 - \$15";
      default:
        return "\$0 - \$10";
    }
  }

  String _experienceLabel() {
    switch (experience) {
      case 2:
        // return "👍";
        // return "🤩";
        return '😇';
      case 1:
        return "👌";
      // return '🤷';
      default:
        // return "👎";
        // return "🤬";
        return '👿';
    }
  }
}
