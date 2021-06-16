import 'package:flutter/cupertino.dart';
import 'package:flutterapp/model/tip_mode_model.dart';

class CalculatorSummaryModel extends ChangeNotifier {
  final Map<TipMode, CalculatorSummary> summaries = {};
  final TipModeModel modeModel;

  CalculatorSummaryModel({this.modeModel});

  CalculatorSummary summary() {
    if (summaries[modeModel.mode] == null) {
      summaries[modeModel.mode] = CalculatorSummary();
    }

    return summaries[modeModel.mode];
  }

  int grandTotalCents() {
    return summary().grandTotalCents;
  }

  int tipCents() {
    return summary().tipCents;
  }

  void setTipCents(int newTipCents) {
    summary().tipCents = newTipCents;
    notifyListeners();
  }

  void setGrandTotalCents(int newGrandTotalCents) {
    summary().grandTotalCents = newGrandTotalCents;
    notifyListeners();
  }

  bool get savable {
    return summary().grandTotalCents > 0;
  }
}

class CalculatorSummary {
  int grandTotalCents = 0;
  int tipCents = 0;
}
