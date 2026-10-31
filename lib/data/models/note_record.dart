import 'record_type.dart';

/// One record in the database.
///
/// NOTE: it is called NoteRecord (not "Record") because Dart 3 already has a
/// built-in type named Record. Using the same name would be confusing.
///
/// Every record has its own unique [id], a [type], a required first field,
/// and an OPTIONAL second field stored in the column that fits its data type.
class NoteRecord {
  const NoteRecord({
    this.id,
    required this.type,
    required this.primaryValue,
    this.secondaryText,
    this.secondaryInt,
    this.secondaryReal,
    this.secondaryDate,
  });

  final int? id; // Null until SQLite assigns it on insert.
  final RecordType type;
  final String primaryValue; // title / item / task / name / dish / subject
  final String? secondaryText; // artist, notes, phone, ingredients, author, room
  final int? secondaryInt; // reps
  final double? secondaryReal; // amount, rating
  final DateTime? secondaryDate; // due date

  /// Builds a record from text typed by the user, converting the second
  /// field to the correct type. Throws [FormatException] on invalid input.
  factory NoteRecord.fromInput({
    int? id,
    required RecordType type,
    required String primary,
    required String secondary,
  }) {
    final first = primary.trim();
    final second = secondary.trim();

    if (first.isEmpty) {
      throw FormatException('${type.primaryLabel} is required.');
    }

    // An empty second field is allowed and is saved as NULL.
    final hasSecond = second.isNotEmpty;

    switch (type.secondaryKind) {
      case SecondaryKind.text:
        return NoteRecord(
          id: id,
          type: type,
          primaryValue: first,
          secondaryText: hasSecond ? second : null,
        );
      case SecondaryKind.integer:
        final value = hasSecond ? int.tryParse(second) : null;
        if (hasSecond && value == null) {
          throw FormatException('${type.secondaryLabel} must be a whole number.');
        }
        return NoteRecord(
            id: id, type: type, primaryValue: first, secondaryInt: value);
      case SecondaryKind.real:
        final value = hasSecond ? double.tryParse(second) : null;
        if (hasSecond && value == null) {
          throw FormatException('${type.secondaryLabel} must be a number.');
        }
        return NoteRecord(
            id: id, type: type, primaryValue: first, secondaryReal: value);
      case SecondaryKind.date:
        final value = hasSecond ? DateTime.tryParse(second) : null;
        if (hasSecond && value == null) {
          throw const FormatException('Use the date format YYYY-MM-DD.');
        }
        return NoteRecord(
            id: id, type: type, primaryValue: first, secondaryDate: value);
    }
  }

  /// Converts this record to a Map that sqflite can insert or update.
  Map<String, Object?> toMap() {
    return {
      // Skip the id on insert so SQLite can auto-generate it.
      if (id != null) 'id': id,
      'type': type.digit,
      'primary_value': primaryValue,
      'secondary_text': secondaryText,
      'secondary_int': secondaryInt,
      'secondary_real': secondaryReal,
      // SQLite has no date type, so we store an ISO-8601 text string.
      'secondary_date': secondaryDate?.toIso8601String(),
    };
  }

  /// Converts a database row back into a [NoteRecord].
  factory NoteRecord.fromMap(Map<String, Object?> map) {
    final dateText = map['secondary_date'] as String?;
    return NoteRecord(
      id: map['id'] as int?,
      type: RecordType.fromDigit(map['type'] as int),
      primaryValue: map['primary_value'] as String,
      secondaryText: map['secondary_text'] as String?,
      secondaryInt: map['secondary_int'] as int?,
      // "num" -> double avoids a crash if SQLite returns a whole number.
      secondaryReal: (map['secondary_real'] as num?)?.toDouble(),
      secondaryDate: dateText == null ? null : DateTime.tryParse(dateText),
    );
  }

  /// The second field as display text (empty string if it is null).
  String get secondaryDisplay {
    if (secondaryText != null) return secondaryText!;
    if (secondaryInt != null) return secondaryInt.toString();
    if (secondaryReal != null) return secondaryReal.toString();
    if (secondaryDate != null) {
      return secondaryDate!.toIso8601String().split('T').first;
    }
    return '';
  }
}
