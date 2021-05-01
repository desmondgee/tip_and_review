import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/payment/m_payment.dart';
import '../../model/payment.dart';
import '../../style.dart';
import '../../currency.dart';

class MCalculator extends StatefulWidget {
  final MPayment mPayment;
  final SharedPreferences prefs;
  List<Map<String, dynamic>> history;

  MCalculator({this.mPayment, this.prefs, this.history});

  @override
  _MCalculatorState createState() => _MCalculatorState();
}

class _MCalculatorState extends State<MCalculator> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
