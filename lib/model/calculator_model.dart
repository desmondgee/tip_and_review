import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/calculator_step_model.dart';
import 'package:flutterapp/model/calculator_summary_model.dart';
import 'package:flutterapp/model/split_model.dart';
import 'package:flutterapp/model/tip_mode_model.dart';
import 'package:flutterapp/model/payment/custom_payment.dart';
import 'package:flutterapp/model/payment/include_tax_payment.dart';
import 'package:flutterapp/model/payment/exclude_tax_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorModel extends ChangeNotifier {
  IncludeTaxPayment includeTaxPayment;
  ExcludeTaxPayment excludeTaxPayment;
  CustomPayment customPayment;
  CalculatorSummaryModel summaryModel;
  CalculatorStepModel stepModel = CalculatorStepModel();
  TipModeModel modeModel;
  SplitModel splitModel;
  List<Map<String, dynamic>> history;
  SharedPreferences prefs;
  BuildContext context;

  CalculatorModel({this.history, this.prefs, this.context}) {
    modeModel = TipModeModel(prefs: prefs);
    summaryModel = CalculatorSummaryModel(modeModel: modeModel);
    splitModel = SplitModel(modeModel: modeModel, summaryModel: summaryModel);
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
    summaryModel.setGrandTotalCents(excludeTaxPayment.grandTotalCents());
    summaryModel.setTipCents(excludeTaxPayment.tipCents());
  }

  void setTax(String formattedDollars) {
    excludeTaxPayment.setTax(formattedDollars);
    summaryModel.setGrandTotalCents(excludeTaxPayment.grandTotalCents());
    summaryModel.setTipCents(excludeTaxPayment.tipCents());
  }

  void setTaxedTotal(String formattedDollars) {
    includeTaxPayment.setTaxedTotal(formattedDollars);
    summaryModel.setGrandTotalCents(includeTaxPayment.grandTotalCents());
    summaryModel.setTipCents(includeTaxPayment.tipCents());
  }

  void setTipPercentIndex(int newIndex) {
    switch (modeModel.mode) {
      case TipMode.include_tax:
        includeTaxPayment.setTipPercentIndex(newIndex);
        summaryModel.setGrandTotalCents(includeTaxPayment.grandTotalCents());
        summaryModel.setTipCents(includeTaxPayment.tipCents());
        break;
      case TipMode.exclude_tax:
        excludeTaxPayment.setTipPercentIndex(newIndex);
        summaryModel.setGrandTotalCents(excludeTaxPayment.grandTotalCents());
        summaryModel.setTipCents(excludeTaxPayment.tipCents());
        break;
      case TipMode.custom:
        break;
    }
  }

  void setGrandTotal(String formattedDollars) {
    customPayment.setGrandTotal(formattedDollars);
    summaryModel.setGrandTotalCents(customPayment.grandTotalCents);
    summaryModel.setTipCents(customPayment.tipCents);
  }

  void setTip(String formattedDollars) {
    customPayment.setTip(formattedDollars);
    summaryModel.setGrandTotalCents(customPayment.grandTotalCents);
    summaryModel.setTipCents(customPayment.tipCents);
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
