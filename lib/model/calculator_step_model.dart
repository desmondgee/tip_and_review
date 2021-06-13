import 'package:flutter/cupertino.dart';

class CalculatorStepModel extends ChangeNotifier {
  int step = 0;

  void setStep(int newStep) {
    step = newStep;
    notifyListeners();
  }
}
