import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButtonModel extends ChangeNotifier {
  Widget widget = Container(width: 0.0, height: 0.0);

  void setWidget(Widget newWidget) {
    widget = newWidget;
    notifyListeners();
  }

  void clear() {
    Widget blank = Container(width: 0.0, height: 0.0);
    // Widget blank =
    //     FloatingActionButton(onPressed: () => null, child: Icon(Icons.add));

    // widget = AnimatedCrossFade(
    //     firstChild: widget,
    //     secondChild: blank,
    //     firstCurve: Curves.easeOut,
    //     secondCurve: Curves.easeIn,
    //     sizeCurve: Curves.bounceOut,
    //     crossFadeState: CrossFadeState.showSecond,
    //     duration: Duration(seconds: 3));

    // widget = AnimatedSwitcher(
    //   duration: Duration(seconds: 3),
    //   child: blank,
    //   transitionBuilder: (Widget child, Animation<double> animation) {
    //     return ScaleTransition(child: child, scale: animation);
    //   },
    // );

    // widget = FloatingActionButton(
    //   onPressed: () => null,
    //   child: Icon(Icons.ac_unit),
    // );

    widget = blank;

    notifyListeners();
  }
}
