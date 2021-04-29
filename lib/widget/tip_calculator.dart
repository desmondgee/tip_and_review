import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../currency.dart';
import '../model/payment.dart';

class TipCalculator extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final PaymentModel paymentModel;
  TipCalculator(this.paymentModel, this.history);

  @override
  TipCalculatorState createState() => TipCalculatorState(paymentModel, history);
}

class TipCalculatorState extends State<TipCalculator> {
  //==== State Variables ====
  // can i remove this boolean? maybe animateToItem has this built-in and doesn't trigger changes.
  bool _disableSave = true;
  var inputTotalController = TextEditingController();
  var inputTipController = FixedExtentScrollController(initialItem: 0);
  List<Map<String, dynamic>> history;
  final PaymentModel paymentModel;

  //==== Constants ====
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

  //==== Overrides ====
  TipCalculatorState(this.paymentModel, this.history);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      inputTotalController.text = paymentModel.formattedTaxedTotal();
      inputTipController.jumpToItem(paymentModel.tipPercentIndex);
      // final prefs = await SharedPreferences.getInstance();
      // // tip index of 5 is default for new user.
      // int index = prefs.getInt('tipIndex') ?? 5;
      // setState(() {
      //   inputTipController.animateToItem(index,
      //       duration: Duration(seconds: 2), curve: Curves.elasticOut);
      // });
      // _disableSave = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
            child: Column(children: [_youPayBlock(), _basedOnBlock()])));
  }

  //---- Sections ----
  Widget _youPayBlock() {
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
                                  paymentModel.formattedTipTotal(),
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
                                  paymentModel.formattedGrandTotal(),
                                  style: textStyle,
                                  textAlign: TextAlign.right,
                                ))
                          ]),
                    ])))));
  }

  Widget _basedOnBlock() {
    final tipTiles = PaymentModel.tipPercents.map(
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
          onSelectedItemChanged: (newIndex) => setState(() {
            paymentModel.setTipPercentIndex(newIndex);
          }),
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
                                  onChanged: (value) => setState(
                                      () => paymentModel.setTaxedTotal(value)),
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
}
