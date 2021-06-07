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

var dropdownLabels = <String>['Include Tax', 'Exclude Tax', 'Custom'];
var dropdownItems = dropdownLabels
    .asMap()
    .entries
    .map<DropdownMenuItem<String>>((MapEntry<int, String> entry) {
  return DropdownMenuItem<String>(value: entry.value, child: Text(entry.value));
}).toList();

class TipCalculatorState extends State<TipCalculator> {
  //==== State Variables ====
  PageController pageController;
  int pageIndex = 0;

  //==== Overrides ====
  @override
  void initState() {
    super.initState();

    pageController = PageController(
        initialPage: widget.pages *
            100); // can't scroll below page 0, so for looped back/forward swiping, just start at a high page number.
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("Tip Mode: "),
        DropdownButton<String>(
            value: dropdownLabels[pageIndex],
            icon: const Icon(Icons.sync_outlined),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                pageIndex = dropdownLabels.indexOf(newValue);
                pageController.jumpToPage(pageIndex);
              });
            },
            items: dropdownItems)
      ]),
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
