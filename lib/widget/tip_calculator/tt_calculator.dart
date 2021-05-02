import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widget/other_info_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import 'package:flutterapp/widget/tip_calculator/you_pay_section.dart';
import '../../model/payment/tt_payment.dart';
import '../../style.dart';
import '../../currency.dart';
import '../section.dart';
import 'calculator_scaffold.dart';

class TTCalculator extends StatefulWidget {
  final TTPayment ttPayment;

  TTCalculator({this.ttPayment});

  @override
  _TTCalculatorState createState() => _TTCalculatorState();
}

class _TTCalculatorState extends State<TTCalculator> {
  //==== State Variables ====
  var taxedTotalController = TextEditingController();
  var tipController = FixedExtentScrollController(initialItem: 0);

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      taxedTotalController.text = widget.ttPayment.formattedTaxedTotal();
      tipController.jumpToItem(widget.ttPayment.tipIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
        isSavable: taxedTotalController.text.isNotEmpty &&
            Currency.parseCents(taxedTotalController.text) > 0,
        onSaved: () {
          setState(() {
            taxedTotalController.clear();
            widget.ttPayment.save();
          });
        },
        header: "Post-Tax Tip Calculator",
        body: Column(children: [
          YouPaySection(
              formattedTip: widget.ttPayment.formattedTip(),
              formattedGrandTotal: widget.ttPayment.formattedGrandTotal()),
          _basedOnSection(),
          OtherInfoSection(
            payment: widget.ttPayment,
          ),
        ]));
  }

  //==== Widgets ====
  Widget _basedOnSection() {
    return Section(
      title: "Based On",
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _taxedTotalField(),
        TipScroller(
            controller: tipController,
            onChanged: (newIndex) => setState(() {
                  widget.ttPayment.setTipPercentIndex(newIndex);
                }))
      ]),
    );
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
}
