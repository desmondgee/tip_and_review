import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/calculator_steps.dart';
import 'package:flutterapp/widget/tip_calculator/custom_mode_steps.dart';
import 'package:flutterapp/widget/tip_calculator/exclude_tax_mode_steps.dart';
import 'package:flutterapp/widget/tip_calculator/include_tax_mode_steps.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TipMode { include_tax, exclude_tax, custom }

class TipModeModel extends ChangeNotifier {
  TipMode mode;
  final SharedPreferences prefs;

  final labels = <String>['Include Tax', 'Exclude Tax', 'Custom'];
  List<DropdownMenuItem<String>> dropdownItems;

  TipModeModel({this.prefs}) {
    switch (prefs.getString("tip_mode")) {
      case "exclude_tax":
        mode = TipMode.exclude_tax;
        break;
      case "custom":
        mode = TipMode.custom;
        break;
      default:
        mode = TipMode.include_tax;
    }

    dropdownItems = labels
        .asMap()
        .entries
        .map<DropdownMenuItem<String>>((MapEntry<int, String> entry) {
      return DropdownMenuItem<String>(
          value: entry.value, child: Text(entry.value));
    }).toList();
  }

  CalculatorSteps get widgets {
    switch (mode) {
      case TipMode.exclude_tax:
        return ExcludeTaxModeSteps();
      case TipMode.custom:
        return CustomModeSteps();
      default:
        return IncludeTaxModeSteps();
    }
  }

  String get label {
    switch (mode) {
      case TipMode.exclude_tax:
        return "Exclude Tax";
      case TipMode.custom:
        return "Custom";
      default:
        return "Include Tax";
    }
  }

  void setLabel(newLabel) {
    switch (newLabel) {
      case "Include Tax":
        setTipMode(TipMode.include_tax);
        return;
      case "Exclude Tax":
        setTipMode(TipMode.exclude_tax);
        return;
      case "Custom":
        setTipMode(TipMode.custom);
        return;
    }
  }

  void setTipMode(TipMode newTipMode) {
    mode = newTipMode;
    String tipModeString;

    switch (newTipMode) {
      case TipMode.exclude_tax:
        tipModeString = "exclude_tax";
        break;
      case TipMode.custom:
        tipModeString = "custom";
        break;
      default:
        tipModeString = "include_tax";
    }

    prefs.setString("tip_mode", tipModeString);

    notifyListeners();
  }
}
