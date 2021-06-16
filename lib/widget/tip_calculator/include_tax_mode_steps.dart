import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/model/action_button_model.dart';
import 'package:flutterapp/model/calculator_model.dart';
import 'package:flutterapp/model/calculator_steps.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:flutterapp/model/split_model.dart';
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

  Widget step2(BuildContext context) {
    var subtotalController = TextEditingController();
    var splitSubtotalController = TextEditingController();
    var splitNameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ActionButtonModel>(
        context,
        listen: false,
      ).setWidget(FloatingActionButton(
        onPressed: () {
          splitSubtotalController.clear();
          splitNameController.clear();

          SplitModel splitModel =
              Provider.of<SplitModel>(context, listen: false);

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('New Split'),
              content: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: splitNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Person's Name",
                      ),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: splitSubtotalController,
                      keyboardType: TextInputType.number,
                      onTap: () => splitSubtotalController.selection =
                          TextSelection.collapsed(
                              offset: splitSubtotalController.text.length),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) {
                            String text =
                                Currency.reformatDollars(newValue.text);
                            return TextEditingValue(
                              text: text,
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        )
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Cost of Items",
                        hintText: splitModel.formattedRemainingSubtotal() +
                            " remaining",
                      ),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    SizedBox(height: 20),
                    Text("(" +
                        splitModel.formattedRemainingSubtotal() +
                        " unaccounted)"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Add');
                    splitModel.addSplit(
                        splitNameController.text, splitSubtotalController.text);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ));
    });

    return Column(
      children: [
        Section(
          title: "",
          verticalPadding: 10.0,
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Please Enter Item Subtotal:",
                    style: Style.labelStyle,
                  ),
                  CurrencyField(
                    label: "",
                    controller: subtotalController,
                    onChanged: (value) =>
                        Provider.of<SplitModel>(context, listen: false)
                            .setSubtotal(value),
                  )
                ],
              ),
            ],
          ),
        ),
        Section(
          title: "",
          verticalPadding: 10.0,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Splits",
                textAlign: TextAlign.left,
                style: Style.labelStyle,
              ),
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 90, maxHeight: 200),
                child: Consumer<SplitModel>(
                  builder: (context, splitModel, _) => Scrollbar(
                    isAlwaysShown: true,
                    child: ListView(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      children: splitModel.splits
                          .map(
                            (Split split) => ListTile(
                              leading: Icon(Icons.person),
                              title: Text(split.name),
                              subtitle:
                                  Text("subtotal " + split.formattedSubtotal),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(Currency.formatCents(
                                      splitModel.splitPayCents(split))),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () =>
                                        splitModel.deleteSplit(split),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Divider(),
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FixedColumnWidth(100),
                },
                children: [
                  TableRow(
                    children: [
                      Text("Paid:",
                          textAlign: TextAlign.right, style: Style.labelStyle),
                      Consumer<SplitModel>(
                        builder: (context, splitModel, _) => Text(
                          Currency.formatCents(splitModel.runningPayCents()),
                          textAlign: TextAlign.right,
                          style: Style.labelStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        "Remaining:",
                        textAlign: TextAlign.right,
                        style: Style.labelStyle,
                      ),
                      Consumer<SplitModel>(
                        builder: (context, splitModel, _) => Text(
                          Currency.formatCents(splitModel.remainingPayCents()),
                          textAlign: TextAlign.right,
                          style: splitModel.remainingPayCents() > 0
                              ? Style.redLabelStyle
                              : Style.labelStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

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

  Widget step4(BuildContext context) {
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
