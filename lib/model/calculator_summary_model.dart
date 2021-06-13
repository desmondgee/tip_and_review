import 'package:flutter/cupertino.dart';

class CalculatorSummaryModel extends ChangeNotifier {
  String formattedGrandTotal = "\$0.00";
  String formattedTip = "\$0.00";

  void update({newFormattedGrandTotal, newFormattedTip}) {
    formattedGrandTotal = newFormattedGrandTotal;
    formattedTip = newFormattedTip;
    notifyListeners();
  }

  bool get savable {
    return formattedGrandTotal != "\$0.00";
  }
}
