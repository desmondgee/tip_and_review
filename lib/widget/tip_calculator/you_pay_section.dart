import 'package:flutter/cupertino.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/style.dart';

class YouPaySection extends StatefulWidget {
  final String formattedTip;
  final String formattedGrandTotal;

  YouPaySection({this.formattedTip, this.formattedGrandTotal});

  @override
  _YouPaySectionState createState() => _YouPaySectionState();
}

class _YouPaySectionState extends State<YouPaySection> {
  @override
  Widget build(BuildContext context) {
    return Section(
        title: "You Pay",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
                width: 140,
                child: Text(
                  "Tip Amount:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 140,
                child: Text(
                  widget.formattedTip,
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
                width: 140,
                child: Text(
                  "Total Amount:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 140,
                child: Text(
                  widget.formattedGrandTotal,
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
        ]));
  }
}
