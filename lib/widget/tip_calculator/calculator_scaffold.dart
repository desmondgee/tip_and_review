import 'package:flutter/material.dart';
import '../../style.dart';

class CalculatorScaffold extends StatefulWidget {
  final bool isSavable;
  final Function onSaved;
  final Widget body;
  final String header;
  final scrollController = ScrollController();

  CalculatorScaffold({this.isSavable, this.onSaved, this.body, this.header});

  @override
  _CalculatorScaffoldState createState() => _CalculatorScaffoldState();
}

class _CalculatorScaffoldState extends State<CalculatorScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        floatingActionButton: widget.isSavable
            ? FloatingActionButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  widget.scrollController.jumpTo(0);
                  widget.onSaved();

                  final snackBar =
                      SnackBar(content: Text("Payment saved to history"));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Icon(Icons.bookmarks_outlined),
                backgroundColor: Colors.teal,
                tooltip: "Save Payments To History",
              )
            : null,
        body: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(children: [
              widget.body,
              SizedBox(
                  height:
                      80) // add space so save button doesn't overlapping notes field.
            ])));
  }
}
