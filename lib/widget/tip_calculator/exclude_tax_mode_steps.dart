import 'package:flutter/cupertino.dart';
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

class ExcludeTaxModeSteps implements CalculatorSteps {
  Widget step1(BuildContext context) {
    CalculatorModel calculatorModel = Provider.of<CalculatorModel>(
      context,
      listen: false,
    );

    var subtotalController = TextEditingController();
    var taxController = TextEditingController();
    var tipController = FixedExtentScrollController(initialItem: 0);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        Provider.of<ActionButtonModel>(
          context,
          listen: false,
        ).clear();

        subtotalController.text =
            calculatorModel.excludeTaxPayment.formattedSubtotal();
        taxController.text = calculatorModel.excludeTaxPayment.formattedTax();
        tipController.jumpToItem(calculatorModel.excludeTaxPayment.tipIndex);
      },
    );

    return Section(
      title: "Please Enter",
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                CurrencyField(
                  label: "Subtotal",
                  controller: subtotalController,
                  onChanged: (value) => calculatorModel.setSubtotal(value),
                ),
                CurrencyField(
                  label: "Tax",
                  controller: taxController,
                  onChanged: (value) => calculatorModel.setTax(value),
                )
              ]),
              TipScroller(
                  label: "Tip Percent",
                  controller: tipController,
                  onChanged: (newIndex) =>
                      calculatorModel.setTipPercentIndex(newIndex))
            ],
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
        Provider.of<CalculatorModel>(context, listen: false).excludeTaxPayment;
    return OtherInfoSection(payment: payment);
  }

  Widget step4(BuildContext context) => SummaryStep.widget(context);
}
