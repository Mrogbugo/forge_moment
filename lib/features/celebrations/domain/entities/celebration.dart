enum Occasion { birthday, anniversary, wedding, graduation, newBaby, housewarming, other }
enum Recurrence { once, annually }

class Celebration {
  final String id;
  final String personName;
  final DateTime date;
  final Occasion occasion;
  final Recurrence recurrence;
  final String? relationship;
  final bool reminderEnabled;
  final int reminderDaysBefore;

  const Celebration({
    required this.id,
    required this.personName,
    required this.date,
    required this.occasion,
    this.recurrence = Recurrence.annually,
    this.relationship,
    this.reminderEnabled = true,
    this.reminderDaysBefore = 3,
  });
}
