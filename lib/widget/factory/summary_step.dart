import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/model/action_button_model.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:provider/provider.dart';

class SummaryStep {
  static Widget widget(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ActionButtonModel>(
        context,
        listen: false,
      ).clear();
    });

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
                    Currency.formatCents(summaryModel.tipCents()),
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
                    Currency.formatCents(summaryModel.grandTotalCents()),
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
