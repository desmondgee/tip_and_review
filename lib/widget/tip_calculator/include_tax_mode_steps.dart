import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/model/calculator_steps.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/widget/tip_calculator/other_info_section.dart';
import 'package:flutterapp/widget/tip_calculator/tip_scroller.dart';
import 'package:provider/provider.dart';

class IncludeTaxModeSteps implements CalculatorSteps {
  Widget step1(BuildContext context) {
    CalculatorModel calculatorModel = Provider.of<CalculatorModel>(
      context,
      listen: false,
    );

    var taxedTotalController = TextEditingController();
    var tipController = FixedExtentScrollController(initialItem: 0);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        taxedTotalController.text =
            calculatorModel.includeTaxPayment.formattedTaxedTotal();
        tipController.jumpToItem(calculatorModel.includeTaxPayment.tipIndex);
      },
    );

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
            onChanged: (value) => calculatorModel.setTaxedTotal(value),
          ),
          TipScroller(
            label: "Tip Percent",
            controller: tipController,
            onChanged: (newIndex) =>
                calculatorModel.setTipPercentIndex(newIndex),
          ),
        ],
      ),
    );
  }

  Widget step2(BuildContext context) {
    return Container(child: Text("STEP 2 PLACEHOLDER"));
  }

  Widget step3(BuildContext context) {
    NotesMixin payment =
        Provider.of<CalculatorModel>(context, listen: false).includeTaxPayment;
    return OtherInfoSection(payment: payment);
  }

  Widget step4(BuildContext context) {
    CalculatorModel model =
        Provider.of<CalculatorModel>(context, listen: false);
    return Section(
      title: "Summary",
      body: Column(
        children: [
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(100)},
            children: [
              TableRow(children: [
                Text(
                  "Tip:",
                  textAlign: TextAlign.right,
                  style: Style.labelStyle,
                ),
                Consumer<CalculatorSummaryModel>(
                  builder: (context, summaryModel, child) => Text(
                    summaryModel.formattedTip,
                    textAlign: TextAlign.right,
                    style: Style.labelStyle,
                  ),
                ),
              ]),
              TableRow(children: [
                Text(
                  "Pay Total:",
                  textAlign: TextAlign.right,
                  style: Style.labelStyle,
                ),
                Consumer<CalculatorSummaryModel>(
                  builder: (context, summaryModel, child) => Text(
                    summaryModel.formattedGrandTotal,
                    textAlign: TextAlign.right,
                    style: Style.labelStyle,
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              print('Received click');
              model.save();
            },
            child: const Text('Save Payment'),
          ),
        ],
      ),
    );
  }
}
