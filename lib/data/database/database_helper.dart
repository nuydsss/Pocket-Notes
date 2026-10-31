import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/note_record.dart';
import '../models/record_type.dart';

/// Opens the database ONCE and offers CRUD operations.
///
/// SINGLETON: only one DatabaseHelper exists (DatabaseHelper.instance), and
/// it keeps one cached connection that every method reuses.
class DatabaseHelper {
  // Private constructor: nobody outside can create another helper.
  DatabaseHelper._internal();

  /// The one and only helper, shared by the whole app.
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'pocket_notes.db';
  static const int _dbVersion = 1;
  static const String _table = 'records';

  // We cache the FUTURE of opening the database (not the database itself).
  // If two callers ask at the same moment they get the same Future, so the
  // file is never opened twice.
  Future<Database>? _databaseFuture;

  /// Every CRUD method gets the database through this getter.
  Future<Database> get database {
    // "??=" means: only call _openDatabase() if the cache is still empty.
    return _databaseFuture ??= _openDatabase().catchError((Object e) {
      // If opening failed, clear the cache so a later call can retry.
      _databaseFuture = null;
      throw e;
    });
  }

  Future<Database> _openDatabase() async {
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    return openDatabase(dbPath, version: _dbVersion, onCreate: _onCreate);
  }

  /// Runs only once: the first time the database file is created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        type           INTEGER NOT NULL CHECK (type BETWEEN 0 AND 9),
        primary_value  TEXT    NOT NULL,
        secondary_text TEXT,
        secondary_int  INTEGER,
        secondary_real REAL,
        secondary_date TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_records_type ON $_table(type)');
  }

  // ------------------------------ CREATE ----------------------------------

  /// Inserts a record and returns the new row id.
  Future<int> insertRecord(NoteRecord record) async {
    try {
      final db = await database;
      return await db.insert(_table, record.toMap());
    } on DatabaseException catch (e) {
      debugPrint('Insert failed: $e');
      rethrow;
    }
  }

  // ------------------------------- READ -----------------------------------

  /// Gets all records, or only one type when [type] is given. Newest first.
  Future<List<NoteRecord>> getRecords({RecordType? type}) async {
    try {
      final db = await database;
      final rows = await db.query(
        _table,
        where: type == null ? null : 'type = ?',
        whereArgs: type == null ? null : [type.digit],
        orderBy: 'id DESC',
      );
      return rows.map(NoteRecord.fromMap).toList();
    } on DatabaseException catch (e) {
      debugPrint('Query failed: $e');
      rethrow;
    }
  }

  // ------------------------------ UPDATE ----------------------------------

  /// Updates the record with the same id. Returns how many rows changed.
  Future<int> updateRecord(NoteRecord record) async {
    if (record.id == null) {
      throw ArgumentError('Cannot update a record without an id.');
    }
    try {
      final db = await database;
      return await db.update(
        _table,
        record.toMap(),
        where: 'id = ?', // "?" is a placeholder: the value is never pasted
        whereArgs: [record.id], // into the SQL text, which blocks injection.
      );
    } on DatabaseException catch (e) {
      debugPrint('Update failed: $e');
      rethrow;
    }
  }

  // ------------------------------ DELETE ----------------------------------

  /// Deletes the record with this id. Returns how many rows were deleted.
  Future<int> deleteRecord(int id) async {
    try {
      final db = await database;
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } on DatabaseException catch (e) {
      debugPrint('Delete failed: $e');
      rethrow;
    }
  }
}
