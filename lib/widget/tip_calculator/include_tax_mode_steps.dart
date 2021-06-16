import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/action_button_model.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/model/calculator_steps.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/factory/split_step.dart';
import 'package:flutterapp/widget/factory/summary_step.dart';
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
        Provider.of<ActionButtonModel>(
          context,
          listen: false,
        ).clear();

        var formattedTaxTotal =
            calculatorModel.includeTaxPayment.formattedTaxedTotal();
        if (formattedTaxTotal != "\$0.00") {
          taxedTotalController.text = formattedTaxTotal;
        }
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

  Widget step2(BuildContext context) => SplitStep.widget(context);

  Widget step3(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ActionButtonModel>(
        context,
        listen: false,
      ).clear();
    });

    NotesMixin payment =
        Provider.of<CalculatorModel>(context, listen: false).includeTaxPayment;
    return OtherInfoSection(payment: payment);
  }

  Widget step4(BuildContext context) => SummaryStep.widget(context);
}
