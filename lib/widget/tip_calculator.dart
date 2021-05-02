import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment/m_payment.dart';
import 'package:flutterapp/model/payment/tt_payment.dart';
import 'package:flutterapp/model/payment/ut_payment.dart';
import 'package:flutterapp/widget/tip_calculator/m_calculator.dart';
import 'package:flutterapp/widget/tip_calculator/tt_calculator.dart';
import 'package:flutterapp/widget/tip_calculator/ut_calculator.dart';
import 'page_dots.dart';

class TipCalculator extends StatefulWidget {
  final TTPayment ttPayment;
  final UTPayment utPayment;
  final MPayment mPayment;
  final int pages = 3;
  TipCalculator({this.ttPayment, this.utPayment, this.mPayment});

  @override
  TipCalculatorState createState() => TipCalculatorState();
}

class TipCalculatorState extends State<TipCalculator> {
  //==== State Variables ====
  var pageController;
  int pageIndex = 0;

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    pageController = PageController(
        initialPage: widget.pages * 100); // can't scroll below 0 fix.
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PageDots(index: pageIndex, length: widget.pages),
      Expanded(
          child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) =>
                  setState(() => pageIndex = value % widget.pages),
              itemBuilder: (_, i) {
                switch (i % 3) {
                  case 0:
                    return TTCalculator(ttPayment: widget.ttPayment);
                  case 1:
                    return UTCalculator(utPayment: widget.utPayment);
                  default:
                    return MCalculator(mPayment: widget.mPayment);
                }
              }))
    ]);
  }
}
