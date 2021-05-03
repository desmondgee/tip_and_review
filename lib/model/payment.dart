// Types of payment are:
// * TTPayment - Payment with tip based on taxed total
// * UTPayment - Payment with tip based on untaxed total
// * MPayment - Payment manually tipped
//
// Totals are defined as follows:
// * subtotal = item costs + any special taxes or fees
// * taxedTotal = subtotal + tax
// * grandTotal = subtotal + tax + tip
import 'dart:convert';

import 'package:flutterapp/currency.dart';
import 'package:flutterapp/model/payment/notes_mixin.dart';
import 'package:intl/intl.dart';

class Payment with NotesMixin {
  static final tipPercents = <String>[
    "0%",
    "5%",
    "10%",
    "12%",
    "14%",
    "15%",
    "16%",
    "17%",
    "18%",
    "20%",
    "25%",
    "30%",
  ];

  static final DateFormat dateFormatter = DateFormat('MMMM dd, yyyy');

  int tipCents = 0;
  int grandTotalCents = 0;
  DateTime datetime;

  Payment.fromJson(Map<String, dynamic> json) {
    tipCents = json["tipCents"];
    grandTotalCents = json["grandTotalCents"];
    datetime = DateTime.fromMillisecondsSinceEpoch(json["datetime"]);
    location = json["location"];
    foodRating = json["foodRating"];
    pricing = json["pricing"];
    experience = json["experience"];
    notes = json["notes"];
  }

  double _tipFraction() {
    return tipCents / (grandTotalCents - tipCents);
  }

  String formattedDateTime() {
    return datetime == null ? "DATE MISSING" : dateFormatter.format(datetime);
  }

  String formattedTipPercent() {
    return Currency.formatPercent(_tipFraction(), trailing: 1);
  }

  String formattedTip() {
    return Currency.formatCents(tipCents);
  }

  String formattedGrandTotal() {
    return Currency.formatCents(grandTotalCents);
  }
}
