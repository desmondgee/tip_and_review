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
import 'package:provider/provider.dart';

class CustomModeSteps implements CalculatorSteps {
  Widget step1(BuildContext context) {
    CalculatorModel calculatorModel = Provider.of<CalculatorModel>(
      context,
      listen: false,
    );

    var grandTotalController = TextEditingController();
    var tipController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        grandTotalController.text =
            calculatorModel.customPayment.formattedGrandTotal();
        tipController.text = calculatorModel.customPayment.formattedTip();
      },
    );

    return Section(
      title: "Payment",
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CurrencyField(
                label: "Total",
                controller: grandTotalController,
                onChanged: (value) => calculatorModel.setGrandTotal(value),
              ),
              CurrencyField(
                label: "Tip",
                controller: tipController,
                onChanged: (value) => calculatorModel.setTip(value),
              )
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
        Provider.of<CalculatorModel>(context, listen: false).customPayment;
    return OtherInfoSection(payment: payment);
  }

  Widget step4(BuildContext context) => SummaryStep.widget(context);
}
