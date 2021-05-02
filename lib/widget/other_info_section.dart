import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:flutterapp/widget/section.dart';
import 'package:flutterapp/style.dart';

class OtherInfoSection extends StatefulWidget {
  final NotesMixin payment;

  OtherInfoSection({this.payment});

  @override
  _OtherInfoSectionState createState() => _OtherInfoSectionState();
}

class _OtherInfoSectionState extends State<OtherInfoSection> {
  @override
  Widget build(BuildContext context) {
    return Section(
        title: "Other Info",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
                width: 90,
                child: Text(
                  "Location:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 240,
                child: TextField(
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
                width: 110,
                child: Text(
                  "Food:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 90,
                child: Text(
                  widget.payment.foodRatingLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.payment.foodRating * 1.0,
                    onChanged: (newRating) {
                      setState(
                          () => widget.payment.foodRating = newRating.round());
                    },
                    min: 0,
                    max: 4,
                    divisions: 4)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
                width: 110,
                child: Text(
                  "Pricing:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 90,
                child: Text(
                  widget.payment.pricingLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.payment.pricing * 1.0,
                    onChanged: (newRating) {
                      setState(
                          () => widget.payment.pricing = newRating.round());
                    },
                    min: 0,
                    max: 6,
                    divisions: 6))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
                width: 110,
                child: Text(
                  "Experience:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 90,
                child: Text(
                  widget.payment.experienceLabel(),
                  style: Style.textStyle,
                  textAlign: TextAlign.right,
                )),
            SizedBox(
                width: 180,
                child: Slider.adaptive(
                    value: widget.payment.experience * 1.0,
                    onChanged: (newRating) {
                      setState(
                          () => widget.payment.experience = newRating.round());
                    },
                    min: 0,
                    max: 2,
                    divisions: 2))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
                width: 90,
                child: Text(
                  "Notes:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: 240,
                child: TextField(
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null))
          ]),
        ]));
  }
}
