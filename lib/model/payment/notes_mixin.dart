abstract class NotesMixin {
  static final foodRatingLabels = [
    "Bad",
    "Decent",
    "Good",
    "Very Good",
    "Amazing",
  ];

  static final pricingLabels = [
    "\$0 - \$10",
    "\$10 - \$15",
    "\$15 - \$20",
    "\$20 - \$30",
    "\$30 - \$50",
    "\$50 - \$100",
    "\$100+",
  ];

  static final experienceLabels = ['👿', '👌', '😇'];

  int foodRating = 2;
  int pricing = 2;
  int experience = 1;

  String foodRatingLabel() {
    return foodRatingLabels[foodRating];
  }

  String pricingLabel() {
    return pricingLabels[pricing];
  }

  String experienceLabel() {
    return experienceLabels[experience];
  }
}
