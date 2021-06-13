import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/calculator_step_model.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/tip_mode_model.dart';
import 'package:flutterapp/model/payment/custom_payment.dart';
import 'package:flutterapp/model/payment/include_tax_payment.dart';
import 'package:flutterapp/model/payment/exclude_tax_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorModel extends ChangeNotifier {
  IncludeTaxPayment includeTaxPayment;
  ExcludeTaxPayment excludeTaxPayment;
  CustomPayment customPayment;
  CalculatorSummaryModel summaryModel = CalculatorSummaryModel();
  CalculatorStepModel stepModel = CalculatorStepModel();
  TipModeModel modeModel;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;
  BuildContext context;

  CalculatorModel({this.history, this.prefs, this.context}) {
    modeModel = TipModeModel(prefs: prefs);
    includeTaxPayment = IncludeTaxPayment(history: history, prefs: prefs);
    excludeTaxPayment = ExcludeTaxPayment(history: history, prefs: prefs);
    customPayment = CustomPayment(history: history, prefs: prefs);
  }

  String get formattedTip {
    switch (modeModel.mode) {
      case TipMode.include_tax:
        return includeTaxPayment.formattedTip();
      case TipMode.exclude_tax:
        return excludeTaxPayment.formattedTip();
      case TipMode.custom:
        return customPayment.formattedTip();
    }
    return "";
  }

  String get formattedGrandTotal {
    switch (modeModel.mode) {
      case TipMode.include_tax:
        return includeTaxPayment.formattedGrandTotal();
      case TipMode.exclude_tax:
        return excludeTaxPayment.formattedGrandTotal();
      case TipMode.custom:
        return customPayment.formattedGrandTotal();
    }
    return "";
  }

  void setTipMode(TipMode newTipMode) {
    modeModel.mode = newTipMode;
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

    modeModel.notifyListeners();
  }

  void setSubtotal(String formattedDollars) {
    excludeTaxPayment.setSubtotal(formattedDollars);
    summaryModel.update(
        newFormattedGrandTotal: excludeTaxPayment.formattedGrandTotal(),
        newFormattedTip: excludeTaxPayment.formattedTip());
  }

  void setTax(String formattedDollars) {
    excludeTaxPayment.setTax(formattedDollars);
    summaryModel.update(
        newFormattedGrandTotal: excludeTaxPayment.formattedGrandTotal(),
        newFormattedTip: excludeTaxPayment.formattedTip());
  }

  void setTaxedTotal(String formattedDollars) {
    includeTaxPayment.setTaxedTotal(formattedDollars);
    summaryModel.update(
        newFormattedGrandTotal: includeTaxPayment.formattedGrandTotal(),
        newFormattedTip: includeTaxPayment.formattedTip());
  }

  void setTipPercentIndex(int newIndex) {
    switch (modeModel.mode) {
      case TipMode.include_tax:
        includeTaxPayment.setTipPercentIndex(newIndex);
        summaryModel.update(
            newFormattedGrandTotal: includeTaxPayment.formattedGrandTotal(),
            newFormattedTip: includeTaxPayment.formattedTip());
        break;
      case TipMode.exclude_tax:
        excludeTaxPayment.setTipPercentIndex(newIndex);
        summaryModel.update(
            newFormattedGrandTotal: excludeTaxPayment.formattedGrandTotal(),
            newFormattedTip: excludeTaxPayment.formattedTip());
        break;
      case TipMode.custom:
        break;
    }
  }

  void setGrandTotal(String formattedDollars) {
    customPayment.setGrandTotal(formattedDollars);
    summaryModel.update(
        newFormattedGrandTotal: customPayment.formattedGrandTotal(),
        newFormattedTip: customPayment.formattedTip());
  }

  void setTip(String formattedDollars) {
    customPayment.setTip(formattedDollars);
    summaryModel.update(
        newFormattedGrandTotal: customPayment.formattedGrandTotal(),
        newFormattedTip: customPayment.formattedTip());
  }

  void save() {
    Map<String, dynamic> json;
    switch (modeModel.mode) {
      case TipMode.include_tax:
        json = includeTaxPayment.toJson();
        break;
      case TipMode.exclude_tax:
        json = excludeTaxPayment.toJson();
        break;
      case TipMode.custom:
        json = customPayment.toJson();
        break;
    }

    history.add(json);
    prefs.setString("history", jsonEncode(history));

    includeTaxPayment.clear();
    excludeTaxPayment.clear();
    customPayment.clear();

    stepModel.setStep(0);

    final snackBar = SnackBar(content: Text("Payment saved to history"));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
