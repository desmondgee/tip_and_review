import 'package:flutter/material.dart';
import 'dot.dart';

class PageDots extends StatefulWidget {
  final int index;
  final int length;
  PageDots({this.index, this.length});

  @override
  _PageDotsState createState() => _PageDotsState();
}

class _PageDotsState extends State<PageDots> {
  @override
  Widget build(BuildContext context) {
    List<Dot> dots =
        new List<Dot>.generate(widget.length, (i) => Dot(i == widget.index));

    return Row(
      children: dots,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
