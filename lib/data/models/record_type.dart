/// What kind of value the SECOND field of a record holds.
/// It decides which database column and Dart type is used.
enum SecondaryKind { text, integer, real, date }

/// The 10 record types. [digit] (0-9) is what is saved in the database.
enum RecordType {
  songs(0, 'Songs', 'Title', 'Artist', SecondaryKind.text),
  expenses(1, 'Expenses', 'Item', 'Amount', SecondaryKind.real),
  tasks(2, 'Tasks', 'Task', 'Due date (YYYY-MM-DD)', SecondaryKind.date),
  plants(3, 'Plants', 'Plant name', 'Watering notes', SecondaryKind.text),
  contacts(4, 'Contacts', 'Name', 'Phone number', SecondaryKind.text),
  gymLog(5, 'Gym Log', 'Exercise', 'Reps', SecondaryKind.integer),
  recipes(6, 'Recipes', 'Dish', 'Ingredients', SecondaryKind.text),
  books(7, 'Books', 'Title', 'Author', SecondaryKind.text),
  movies(8, 'Movies', 'Title', 'Rating', SecondaryKind.real),
  classSchedule(9, 'Class Schedule', 'Subject', 'Room', SecondaryKind.text);

  const RecordType(
    this.digit,
    this.label,
    this.primaryLabel,
    this.secondaryLabel,
    this.secondaryKind,
  );

  final int digit; // The record type number (0-9).
  final String label; // Name shown in the UI.
  final String primaryLabel; // Name of the first field.
  final String secondaryLabel; // Name of the second field.
  final SecondaryKind secondaryKind;

  /// Turns a stored digit back into a [RecordType].
  static RecordType fromDigit(int digit) =>
      RecordType.values.firstWhere((t) => t.digit == digit);
}
