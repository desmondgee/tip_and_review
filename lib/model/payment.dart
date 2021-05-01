// Types of payment are:
// * TTPayment - Payment with tip based on taxed total
// * UTPayment - Payment with tip based on untaxed total
// * MPayment - Payment manually tipped
//
// Totals are defined as follows:
// * subtotal = item costs + any special taxes or fees
// * taxedTotal = subtotal + tax
// * grandTotal = subtotal + tax + tip
class Payment {
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
}
