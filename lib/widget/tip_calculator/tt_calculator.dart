import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/payment/tt_payment.dart';
import '../../model/payment.dart';
import '../../style.dart';
import '../../currency.dart';
import '../section.dart';
import 'calculator_scaffold.dart';

class TTCalculator extends StatefulWidget {
  final TTPayment ttPayment;
  final SharedPreferences prefs;
  final List<Map<String, dynamic>> history;

  TTCalculator({this.ttPayment, this.prefs, this.history});

  @override
  _TTCalculatorState createState() => _TTCalculatorState();
}

class _TTCalculatorState extends State<TTCalculator> {
  //==== State Variables ====
  var taxedTotalController = TextEditingController();
  var inputTipController = FixedExtentScrollController(initialItem: 0);

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      taxedTotalController.text = widget.ttPayment.formattedTaxedTotal();
      inputTipController.jumpToItem(widget.ttPayment.tipPercentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
        isSavable: taxedTotalController.text.isNotEmpty &&
            Currency.parseCents(taxedTotalController.text) > 0,
        onSave: _saveToHistory,
        header: "Tip Calculator Version A",
        body: Column(children: [
          _youPaySection(),
          _basedOnSection(),
          _notesSection(),
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
                  widget.ttPayment.formattedTip(),
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
                  widget.ttPayment.formattedGrandTotal(),
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
        ]));
  }

  Widget _basedOnSection() {
    return Section(
      title: "Based On",
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_taxedTotalField(), _tipScroller()]),
    );
  }

  Widget _notesSection() {
    return Section(
        title: "Other Info",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  widget.ttPayment.foodRatingLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.ttPayment.foodRating * 1.0,
                    onChanged: (newRating) {
                      setState(() =>
                          widget.ttPayment.foodRating = newRating.round());
                    },
                    min: 0,
                    max: 4,
                    divisions: 4)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  widget.ttPayment.pricingLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.ttPayment.pricing * 1.0,
                    onChanged: (newRating) {
                      setState(
                          () => widget.ttPayment.pricing = newRating.round());
                    },
                    min: 0,
                    max: 6,
                    divisions: 6))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  widget.ttPayment.experienceLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.ttPayment.experience * 1.0,
                    onChanged: (newRating) {
                      setState(() =>
                          widget.ttPayment.experience = newRating.round());
                    },
                    min: 0,
                    max: 2,
                    divisions: 2))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
        ]));
  }

  Widget _taxedTotalField() {
    return Column(children: [
      Text("After Tax Total", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: taxedTotalController,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => widget.ttPayment.setTaxedTotal(value)),
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
              widget.ttPayment.setTipPercentIndex(newIndex);
            }),
          ))
    ]);
  }

  //==== Functions ====
  void _saveToHistory() {
    Map<String, dynamic> payment = widget.ttPayment.toJson();
    setState(() {
      taxedTotalController.clear();
      widget.ttPayment.taxedTotalCents = 0;
      widget.history.add(payment);
      widget.prefs.setString("history", jsonEncode(widget.history));
    });
  }
}
