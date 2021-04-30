import 'package:flutter/material.dart';

class Dot extends StatefulWidget {
  final bool isActive;
  Dot(this.isActive);

  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> {
  _DotState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: widget.isActive ? 10 : 8.0,
        width: widget.isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            widget.isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: widget.isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
