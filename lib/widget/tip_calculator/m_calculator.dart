import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/section.dart';
import '../../model/payment/m_payment.dart';
import '../../style.dart';
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_tipInput(), _grandTotalInput()]),
        ]));
  }

  Widget _grandTotalInput() {
    return Column(children: [
      Text("Total", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: grandTotalController,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => widget.mPayment.setGrandTotal(value)),
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

  Widget _tipInput() {
    return Column(children: [
      Text("Tip", style: Style.labelStyle),
      SizedBox(
          width: 100,
          child: TextField(
              controller: tipController,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => widget.mPayment.setTip(value)),
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
