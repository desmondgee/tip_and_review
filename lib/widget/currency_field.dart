import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/currency.dart';
import 'package:flutterapp/style.dart';

class CurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String label;
  final double labelGap;

  CurrencyField({
    this.controller,
    this.onChanged,
    this.label,
    this.labelGap: 0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      label == "" ? Container() : Text(label, style: Style.labelStyle),
      label == "" ? Container() : SizedBox(height: labelGap),
      SizedBox(
        width: 100,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          onTap: () => controller.selection =
              TextSelection.collapsed(offset: controller.text.length),
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
              // labelText: label,
              hintText: "\$0.00"),
        ),
      )
    ]);
  }
}
