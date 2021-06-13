import 'package:flutter/cupertino.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/model/calculator_steps.dart';
import 'package:flutterapp/widget/currency_field.dart';
import 'package:flutterapp/widget/section.dart';
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

  Widget step2(BuildContext context) {
    return Container();
  }

  Widget step3(BuildContext context) {
    return Container();
  }

  Widget step4(BuildContext context) {
    return Container();
  }
}
