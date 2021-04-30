import 'package:flutter/material.dart';
import 'dot.dart';

class PageDots extends StatefulWidget {
  final int index;
  final int length;
  PageDots({this.index, this.length}) {
    print("page dots index - " + index.toString());
  }

  @override
  _PageDotsState createState() => _PageDotsState();
}

class _PageDotsState extends State<PageDots> {
  @override
  Widget build(BuildContext context) {
    print("page dot state index - " + widget.index.toString());
    List<Dot> dots =
        new List<Dot>.generate(widget.length, (i) => Dot(i == widget.index));

    return Row(
      children: dots,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
