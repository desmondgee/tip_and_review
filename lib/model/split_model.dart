import 'package:flutter/cupertino.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/tip_mode_model.dart';

class SplitModel extends ChangeNotifier {
  Map<TipMode, List<Split>> lists = {};
  TipModeModel modeModel;
  CalculatorSummaryModel summaryModel;
  int subtotalCents = 0;

  // modeModel is consumed for display steps which includes split step
  // which makes passing that in here safe.
  // todo: add consumer for summaryModel too.
  SplitModel({this.modeModel, this.summaryModel});

  List<Split> get splits => lists[modeModel.mode] ?? [];

  String get formattedRunningSubtotal {
    if (lists[modeModel.mode] == null) {
      return "\$0.00";
    }

    return Currency.formatCents(runningSubtotalCents);
  }

  int get runningSubtotalCents {
    if (lists[modeModel.mode] == null) {
      return 0;
    }

    return lists[modeModel.mode]
        .fold(0, (prev, element) => prev + element.subtotalCents);
  }

  String formattedRemainingSubtotal() {
    return Currency.formatCents(subtotalCents - runningSubtotalCents);
  }

  void deleteSplit(Split split) {
    if (lists[modeModel.mode] == null) {
      return;
    }

    lists[modeModel.mode].remove(split);
    notifyListeners();
  }

  void addSplit(String name, String formattedSubtotal) {
    if (lists[modeModel.mode] == null) {
      lists[modeModel.mode] = [];
    }

    lists[modeModel.mode].add(
      Split(
        name: name,
        subtotalCents: Currency.parseCents(formattedSubtotal),
      ),
    );

    notifyListeners();
  }

  void setSubtotal(String formattedSubtotal) {
    subtotalCents = Currency.parseCents(formattedSubtotal);

    notifyListeners();
  }

  double payMultiplier() {
    if (summaryModel.grandTotalCents == null || subtotalCents == 0) return 1;
    return summaryModel.grandTotalCents() / subtotalCents;
  }

  int runningPayCents() {
    if (lists[modeModel.mode] == null) {
      return 0;
    }

    return lists[modeModel.mode].fold(
      0,
      (prev, element) =>
          prev + (element.subtotalCents * payMultiplier()).floor(),
    );
  }

  int remainingPayCents() {
    return summaryModel.grandTotalCents() - runningPayCents();
  }

  int splitPayCents(Split split) {
    return (split.subtotalCents * payMultiplier()).floor();
  }
}

class Split {
  int subtotalCents;
  String name;

  Split({this.name, this.subtotalCents});

  String get formattedSubtotal => Currency.formatCents(subtotalCents);
}
