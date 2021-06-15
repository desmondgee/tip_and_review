import 'package:flutter/material.dart';
import '../style.dart';

class Section extends StatefulWidget {
  final String title;
  final Widget body;
  final double verticalPadding;
  Section({this.title, this.body, this.verticalPadding = 25.0});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.title == "") {
      content = widget.body;
    } else {
      content = Column(
        children: [
          Text(widget.title, style: Style.headerStyle),
          Divider(),
          widget.body
        ],
      );
    }

    return Center(
      child: SizedBox(
        width: 500,
        child: Card(
          color: Color.fromRGBO(247, 245, 240, 1),
          elevation: 3,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color.fromRGBO(247, 234, 215, 1)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 3.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10.0, vertical: widget.verticalPadding),
            child: content,
          ),
        ),
      ),
    );
  }
}
