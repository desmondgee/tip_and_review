import 'package:flutter/material.dart';
import '../style.dart';

class Section extends StatefulWidget {
  final String title;
  final Widget body;
  Section({this.title, this.body});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 500,
            child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
                    child: Column(children: [
                      Text(widget.title, style: Style.headerStyle),
                      Divider(),
                      widget.body
                    ])))));
  }
}
