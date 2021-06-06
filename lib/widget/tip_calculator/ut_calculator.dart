import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/widget/tip_calculator/you_pay_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import '../../model/payment/ut_payment.dart';
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
        header: "Before Tax",
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
            Column(children: [
              CurrencyField(
                label: "Subtotal",
                controller: subtotalController,
                onChanged: (value) =>
                    setState(() => widget.utPayment.setSubtotal(value)),
              ),
              CurrencyField(
                label: "Tax",
                controller: taxController,
                onChanged: (value) =>
                    setState(() => widget.utPayment.setTax(value)),
              )
            ]),
            TipScroller(
                controller: tipController,
                onChanged: (newIndex) => setState(() {
                      widget.utPayment.setTipPercentIndex(newIndex);
                    }))
          ]),
        ]));
  }
}
