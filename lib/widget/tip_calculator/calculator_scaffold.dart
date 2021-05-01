import 'package:flutter/material.dart';
import '../../style.dart';

class CalculatorScaffold extends StatefulWidget {
  final bool isSavable;
  final Function onSave;
  final Widget body;
  final String header;

  CalculatorScaffold({this.isSavable, this.onSave, this.body, this.header});

  @override
  _CalculatorScaffoldState createState() => _CalculatorScaffoldState();
}

class _CalculatorScaffoldState extends State<CalculatorScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.isSavable
            ? FloatingActionButton(
                onPressed: widget.onSave,
                child: Icon(Icons.bookmarks_outlined),
                backgroundColor: Colors.teal,
                tooltip: "Save Payments To History",
              )
            : null,
        body: SingleChildScrollView(
            child: Column(children: [
          Center(child: Text(widget.header, style: Style.headerStyle)),
          widget.body
        ])));
  }
}
