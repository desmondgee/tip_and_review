import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/style.dart';
import 'package:flutterapp/model/payment.dart';

class TipScroller extends StatefulWidget {
  final FixedExtentScrollController controller;
  final Function onChanged; // takes one argument, an integer for the new index.
  final String label;

  TipScroller({this.controller, this.onChanged, this.label});

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
      Text(widget.label, style: Style.labelStyle),
      SizedBox(
          width: 100,
          height: 100,
          child: CupertinoPicker(
            itemExtent: 44,
            children: dividedTipTiles,
            scrollController: widget.controller,
            onSelectedItemChanged: widget.onChanged,
          ))
    ]);
  }
}
