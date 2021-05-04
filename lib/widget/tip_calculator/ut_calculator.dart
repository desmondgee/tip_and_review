import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/widget/tip_calculator/you_pay_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import '../../model/payment/ut_payment.dart';
import '../../style.dart';
import '../../currency.dart';
import 'calculator_scaffold.dart';

class UTCalculator extends StatefulWidget {
  final UTPayment utPayment;

  UTCalculator({this.utPayment});

  @override
  _UTCalculatorState createState() => _UTCalculatorState();
}

class _UTCalculatorState extends State<UTCalculator> {
  //==== State Variables ====
  var subtotalController = TextEditingController();
  var taxController = TextEditingController();
  var tipController = FixedExtentScrollController(initialItem: 0);

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      subtotalController.text = widget.utPayment.formattedSubtotal();
      taxController.text = widget.utPayment.formattedTax();
      tipController.jumpToItem(widget.utPayment.tipIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
        isSavable: subtotalController.text.isNotEmpty &&
            Currency.parseCents(subtotalController.text) > 0 &&
            taxController.text.isNotEmpty &&
            Currency.parseCents(taxController.text) > 0,
        onSaved: () {
          setState(() {
            subtotalController.clear();
            taxController.clear();
            widget.utPayment.save();
          });
        },
        header: "Pre-Tax Tip",
        body: Column(children: [
          YouPaySection(
              formattedTip: widget.utPayment.formattedTip(),
              formattedGrandTotal: widget.utPayment.formattedGrandTotal()),
          _basedOnSection(),
          OtherInfoSection(payment: widget.utPayment),
        ]));
  }

  //==== Widgets ====
  Widget _basedOnSection() {
    return Section(
        title: "Based On",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(children: [_subtotalField(), _taxField()]),
            TipScroller(
                controller: tipController,
                onChanged: (newIndex) => setState(() {
                      widget.utPayment.setTipPercentIndex(newIndex);
                    }))
          ]),
        ]));
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
}
