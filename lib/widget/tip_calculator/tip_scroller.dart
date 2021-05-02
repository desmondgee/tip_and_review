import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/model/payment.dart';

class TipScroller extends StatefulWidget {
  final FixedExtentScrollController controller;
  final Function onChanged; // takes one argument, an integer for the new index.

  TipScroller({this.controller, this.onChanged});

  @override
  _TipScrollerState createState() => _TipScrollerState();
}

class _TipScrollerState extends State<TipScroller> {
  @override
  Widget build(BuildContext context) {
    final tipTiles = Payment.tipPercents.map(
      (String value) {
        return ListTile(
          title: Text(
            value,
            style: Style.wheelTextStyle,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
    final dividedTipTiles = ListTile.divideTiles(
      context: context,
      tiles: tipTiles,
    ).toList();

    return Column(children: [
      Text("After Tax Tip", style: Style.labelStyle),
      SizedBox(
          width: 100,
          height: 150,
          child: CupertinoPicker(
            itemExtent: 44,
            children: dividedTipTiles,
            scrollController: widget.controller,
            onSelectedItemChanged: widget.onChanged,
          ))
    ]);
  }
}
