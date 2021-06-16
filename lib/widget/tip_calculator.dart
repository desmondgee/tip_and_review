import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/model/calculator_step_model.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/tip_mode_model.dart';
import 'package:provider/provider.dart';

class TipCalculator extends StatefulWidget {
  @override
  TipCalculatorState createState() => TipCalculatorState();
}

class TipCalculatorState extends State<TipCalculator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.credit_card),
                SizedBox(width: 5),
                Consumer2<CalculatorSummaryModel, TipModeModel>(
                  builder: (context, summaryModel, modeModel, child) => Text(
                    Currency.formatCents(
                      summaryModel.grandTotalCents(),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Icon(Icons.room_service),
                SizedBox(width: 5),
                Consumer2<CalculatorSummaryModel, TipModeModel>(
                  builder: (context, summaryModel, _, child) => Text(
                    Currency.formatCents(
                      summaryModel.tipCents(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("Tip Mode: "),
                Consumer<TipModeModel>(
                    builder: (context, modeModel, child) =>
                        DropdownButton<String>(
                            value: modeModel.label,
                            icon: const Icon(Icons.sync_outlined),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String newValue) {
                              Provider.of<CalculatorStepModel>(
                                context,
                                listen: false,
                              ).setStep(0);
                              modeModel.setLabel(newValue);
                            },
                            items: modeModel.dropdownItems))
              ],
            ),
          ],
        ),
        SizedBox(
          height: 74,
          child: Consumer3<CalculatorStepModel, CalculatorSummaryModel,
              TipModeModel>(
            builder: (context, stepModel, summaryModel, modeModel, child) =>
                Stepper(
              type: StepperType.horizontal,
              currentStep: stepModel.step,
              // Remove continue/cancel buttons
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Container();
              },
              onStepTapped: (int step) {
                stepModel.setStep(step);
              },
              steps: <Step>[
                Step(
                  title: const Text('Tip'),
                  state: summaryModel.savable
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: stepModel.step == 0,
                  content: SizedBox(height: 10),
                ),
                Step(
                  title: Text('Split'),
                  subtitle: const Text('Optional'),
                  state: summaryModel.savable
                      ? StepState.indexed
                      : StepState.disabled,
                  isActive: stepModel.step == 1,
                  content: SizedBox(height: 10),
                ),
                Step(
                  title: Text('Info'),
                  subtitle: const Text('Optional'),
                  isActive: stepModel.step == 2,
                  content: SizedBox(height: 10),
                ),
                Step(
                  title: Text('Save'),
                  subtitle: const Text('Optional'),
                  state: summaryModel.savable
                      ? StepState.indexed
                      : StepState.disabled,
                  isActive: stepModel.step == 3,
                  content: SizedBox(height: 10),
                ),
              ],
            ),
          ),
        ),
        Consumer2<CalculatorStepModel, TipModeModel>(
          builder: (context, stepModel, modeModel, child) {
            switch (stepModel.step) {
              case 1:
                return modeModel.widgets.step2(context);
              case 2:
                return modeModel.widgets.step3(context);
              case 3:
                return modeModel.widgets.step4(context);
              default:
                return modeModel.widgets.step1(context);
            }
          },
        ),
      ],
    );
  }
}
