import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import '../../model/payment/m_payment.dart';
import '../../currency.dart';
import 'calculator_scaffold.dart';

class MCalculator extends StatefulWidget {
  final MPayment mPayment;

  MCalculator({this.mPayment});

  @override
  _MCalculatorState createState() => _MCalculatorState();
}

class _MCalculatorState extends State<MCalculator> {
  //==== State Variables ====
  var grandTotalController = TextEditingController();
  var tipController = TextEditingController();

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      grandTotalController.text = widget.mPayment.formattedGrandTotal();
      tipController.text = widget.mPayment.formattedTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
        isSavable: grandTotalController.text.isNotEmpty &&
            Currency.parseCents(grandTotalController.text) > 0 &&
            tipController.text.isNotEmpty &&
            Currency.parseCents(tipController.text) > 0,
        onSaved: () {
          setState(() {
            grandTotalController.clear();
            tipController.clear();
            widget.mPayment.save();
          });
        },
        header: "Custom Tip",
        body: Column(children: [
          _basedOnSection(),
          OtherInfoSection(payment: widget.mPayment),
        ]));
  }

  //==== Widgets ====
  Widget _basedOnSection() {
    return Section(
        title: "Payment",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CurrencyField(
              label: "Total",
              controller: grandTotalController,
              onChanged: (value) =>
                  setState(() => widget.mPayment.setGrandTotal(value)),
            ),
            CurrencyField(
              label: "Tip",
              controller: tipController,
              onChanged: (value) =>
                  setState(() => widget.mPayment.setTip(value)),
            )
          ]),
        ]));
  }
}
