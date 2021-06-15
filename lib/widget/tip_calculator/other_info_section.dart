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
  var locationController = TextEditingController();
  var notesController = TextEditingController();

  //==== Overrides ====
  //@override
  void initState() {
    super.initState();

    locationController.text = widget.payment.location;
    notesController.text = widget.payment.notes;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payment.location == null) {
      locationController.clear();
    }

    if (widget.payment.notes == null) {
      notesController.clear();
    }

    return Section(
        title: "Other Info",
        body: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(10)
            },
            children: [
              TableRow(children: [
                Text(
                  "Location:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  style: Style.labelStyle,
                  textAlign: TextAlign.right,
                  onChanged: (value) => widget.payment.location = value,
                ),
                // Icon(Icons.edit_outlined),
              ]),
              TableRow(children: [
                Text(
                  "Food:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    widget.payment.foodRatingLabel(),
                    style: Style.textStyle,
                    textAlign: TextAlign.right,
                  ),
                  Slider.adaptive(
                      value: widget.payment.foodRating * 1.0,
                      onChanged: (newRating) {
                        setState(() =>
                            widget.payment.foodRating = newRating.round());
                      },
                      min: 0,
                      max: 4,
                      divisions: 4),
                ])
              ]),
              TableRow(children: [
                Text(
                  "Price:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    widget.payment.pricingLabel(),
                    style: Style.textStyle,
                    textAlign: TextAlign.right,
                  ),
                  Slider.adaptive(
                      value: widget.payment.pricing * 1.0,
                      onChanged: (newRating) {
                        setState(
                            () => widget.payment.pricing = newRating.round());
                      },
                      min: 0,
                      max: 6,
                      divisions: 6)
                ])
              ]),
              TableRow(children: [
                Text(
                  "Service:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    widget.payment.experienceLabel(),
                    style: Style.textStyle,
                    textAlign: TextAlign.right,
                  ),
                  Slider.adaptive(
                      value: widget.payment.experience * 1.0,
                      onChanged: (newRating) {
                        setState(() =>
                            widget.payment.experience = newRating.round());
                      },
                      min: 0,
                      max: 2,
                      divisions: 2)
                ])
              ]),
              TableRow(children: [
                Text(
                  "Notes:",
                  style: Style.labelStyle,
                  textAlign: TextAlign.center,
                ),
                TextField(
                    controller: notesController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => widget.payment.notes = value,
                    minLines: 1,
                    maxLines: null)
              ]),
            ]));
  }
}
