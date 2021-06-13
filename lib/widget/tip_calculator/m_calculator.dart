import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import '../../model/payment/custom_payment.dart';
import '../../currency.dart';
import 'calculator_scaffold.dart';

class MCalculator extends StatefulWidget {
  final CustomPayment customPayment;

  MCalculator({this.customPayment});

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
      grandTotalController.text = widget.customPayment.formattedGrandTotal();
      tipController.text = widget.customPayment.formattedTip();
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
          widget.customPayment.save();
        });
      },
      header: "Custom",
      step1: Column(
        children: [
          _basedOnSection(),
        ],
      ),
      step2: Container(),
      step3: OtherInfoSection(payment: widget.customPayment),
      step4: Container(),
    );
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
                  setState(() => widget.customPayment.setGrandTotal(value)),
            ),
            CurrencyField(
              label: "Tip",
              controller: tipController,
              onChanged: (value) =>
                  setState(() => widget.customPayment.setTip(value)),
            )
          ]),
        ]));
  }
}
