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
  String location;
  String notes;

  String foodRatingLabel() {
    if (foodRating == null) return null;
    return foodRatingLabels[foodRating];
  }

  String pricingLabel() {
    if (pricing == null) return null;
    return pricingLabels[pricing];
  }

  String experienceLabel() {
    if (experience == null) return null;
    return experienceLabels[experience];
  }

  Map<String, dynamic> notesJson() {
    return {
      "foodRating": foodRating,
      "pricing": pricing,
      "experience": experience,
      "location": location,
      "notes": notes
    };
  }

  void clearNotes() {
    foodRating = 2;
    pricing = 2;
    experience = 1;
    location = null;
    notes = null;
  }
}
