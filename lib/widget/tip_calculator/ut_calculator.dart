import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/widget/tip_calculator/you_pay_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import '../../model/payment/exclude_tax_payment.dart';
import '../../currency.dart';
import 'calculator_scaffold.dart';

class UTCalculator extends StatefulWidget {
  final ExcludeTaxPayment excludeTaxPayment;

  UTCalculator({this.excludeTaxPayment});

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
      subtotalController.text = widget.excludeTaxPayment.formattedSubtotal();
      taxController.text = widget.excludeTaxPayment.formattedTax();
      tipController.jumpToItem(widget.excludeTaxPayment.tipIndex);
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
          widget.excludeTaxPayment.save();
        });
      },
      header: "Before Tax",
      step1: Column(
        children: [
          YouPaySection(
            formattedTip: widget.excludeTaxPayment.formattedTip(),
            formattedGrandTotal: widget.excludeTaxPayment.formattedGrandTotal(),
          ),
          _basedOnSection(),
        ],
      ),
      step2: Container(),
      step3: OtherInfoSection(payment: widget.excludeTaxPayment),
      step4: Container(),
    );
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
                    setState(() => widget.excludeTaxPayment.setSubtotal(value)),
              ),
              CurrencyField(
                label: "Tax",
                controller: taxController,
                onChanged: (value) =>
                    setState(() => widget.excludeTaxPayment.setTax(value)),
              )
            ]),
            TipScroller(
                label: "Tip Percent",
                controller: tipController,
                onChanged: (newIndex) => setState(() {
                      widget.excludeTaxPayment.setTipPercentIndex(newIndex);
                    }))
          ]),
        ]));
  }
}
