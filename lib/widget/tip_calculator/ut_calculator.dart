import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/payment/ut_payment.dart';
import '../../model/payment.dart';
import '../../style.dart';
import '../../currency.dart';
import '../section.dart';
import 'calculator_scaffold.dart';

class UTCalculator extends StatefulWidget {
  final UTPayment utPayment;
  final SharedPreferences prefs;
  List<Map<String, dynamic>> history;

  UTCalculator({this.utPayment, this.prefs, this.history});

  @override
  _UTCalculatorState createState() => _UTCalculatorState();
}

class _UTCalculatorState extends State<UTCalculator> {
  //==== State Variables ====
  var subtotalController = TextEditingController();
  var taxController = TextEditingController();
  var inputTipController = FixedExtentScrollController(initialItem: 0);

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      subtotalController.text = widget.utPayment.formattedSubtotal();
      taxController.text = widget.utPayment.formattedTax();
      inputTipController.jumpToItem(widget.utPayment.tipPercentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
        isSavable: true,
        onSave: () => null,
        header: "Tip Calculator Version A",
        body: Column(children: [
          _youPaySection(),
          _basedOnSection(),
        ]));
  }

  //==== Widgets ====
  Widget _youPaySection() {
    return Section(
        title: "You Pay",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                  widget.utPayment.formattedTip(),
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                  widget.utPayment.formattedGrandTotal(),
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
        ]));
  }

  Widget _basedOnSection() {
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
                      children: [
                        Column(children: [_subtotalField(), _taxField()]),
                        _tipScroller()
                      ]),
                ]))));
  }

  Widget _subtotalField() {
    return Column(children: [
      Text("Subtotal", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: subtotalController,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => widget.utPayment.setSubtotal(value)),
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

  Widget _taxField() {
    return Column(children: [
      Text("Tax", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: taxController,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => widget.utPayment.setTax(value)),
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
    final tipTiles = Payment.tipPercents.map(
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
              widget.utPayment.setTipPercentIndex(newIndex);
            }),
          ))
    ]);
  }

  //==== Functions ====
  void _saveToHistory() {
    Map<String, dynamic> payment = widget.utPayment.toJson();
    setState(() {
      subtotalController.clear();
      taxController.clear();
      widget.utPayment.subtotalCents = 0;
      widget.utPayment.taxCents = 0;
      widget.history.add(payment);
      widget.prefs.setString("history", jsonEncode(widget.history));
    });
  }
}
