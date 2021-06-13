import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment/include_tax_payment.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import '../../currency.dart';
import '../section.dart';
import 'calculator_scaffold.dart';

class TTCalculator extends StatefulWidget {
  final IncludeTaxPayment includeTaxPayment;
  final void Function() refreshPage;

  TTCalculator({this.includeTaxPayment, this.refreshPage});

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

    print("TTCalculator initState");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      taxedTotalController.text =
          widget.includeTaxPayment.formattedTaxedTotal();
      print("Jumping to: " + widget.includeTaxPayment.tipIndex.toString());
      tipController.jumpToItem(widget.includeTaxPayment.tipIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("TTCalculator build");
    return CalculatorScaffold(
      isSavable: taxedTotalController.text.isNotEmpty &&
          Currency.parseCents(taxedTotalController.text) > 0,
      onSaved: () {
        setState(
          () {
            taxedTotalController.clear();
            widget.includeTaxPayment.save();
          },
        );
      },
      header: "After Tax",
      step1: Column(
        children: [
          // YouPaySection(
          //   formattedTip: widget.includeTaxPayment.formattedTip(),
          //   formattedGrandTotal: widget.includeTaxPayment.formattedGrandTotal(),
          // ),
          _basedOnSection(),
        ],
      ),
      step2: Container(),
      step3: OtherInfoSection(
        payment: widget.includeTaxPayment,
      ),
      step4: Container(),
    );
  }

  //==== Widgets ====
  Widget _basedOnSection() {
    return Section(
      title: "Please Enter",
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencyField(
            label: "Total with Tax",
            labelGap: 20,
            controller: taxedTotalController,
            onChanged: (value) {
              widget.includeTaxPayment.setTaxedTotal(value);
              widget.refreshPage();
            },
          ),
          TipScroller(
            label: "Tip Percent",
            controller: tipController,
            onChanged: (newIndex) {
              widget.includeTaxPayment.setTipPercentIndex(newIndex);
              widget.refreshPage();
            },
          ),
        ],
      ),
    );
  }
}
