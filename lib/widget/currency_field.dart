import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/style.dart';

class CurrencyField extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String label;
  final double labelGap;
  CurrencyField({
    this.controller,
    this.onChanged,
    this.label,
    this.labelGap: 0,
  });

  @override
  _CurrencyFieldState createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.label, style: Style.labelStyle),
      SizedBox(height: widget.labelGap),
      SizedBox(
          width: 100,
          child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              onChanged: widget.onChanged,
              onTap: () => widget.controller.selection =
                  TextSelection.collapsed(
                      offset: widget.controller.text.length),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String text = Currency.reformatDollars(newValue.text);
                  return TextEditingValue(
                      text: text,
                      selection: TextSelection.collapsed(
                          // offset > length safe in chrome but crashes android.
                          offset: text.length));
                })
              ],
              decoration: InputDecoration(
                  // tried prefixText but has weird issue where it only shows when field is clicked. however hintText shows when not clicked and clicked until something is typed. So you will see `$$` when clicked but nothing is typed yet.
                  border: OutlineInputBorder(),
                  hintText: "\$0.00")))
    ]);
  }
}
