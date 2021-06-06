import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import 'package:flutterapp/widget/tip_calculator/you_pay_section.dart';
import '../../model/payment/tt_payment.dart';
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
        header: "After Tax",
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
        CurrencyField(
          label: "After Tax Total",
          controller: taxedTotalController,
          onChanged: (value) =>
              setState(() => widget.ttPayment.setTaxedTotal(value)),
        ),
        TipScroller(
            controller: tipController,
            onChanged: (newIndex) => setState(() {
                  widget.ttPayment.setTipPercentIndex(newIndex);
                }))
      ]),
    );
  }
}
