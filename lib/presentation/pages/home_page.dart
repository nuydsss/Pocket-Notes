import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/note_record.dart';
import '../../data/models/record_type.dart';
import '../atoms/empty_message.dart';
import '../atoms/loading_indicator.dart';
import '../molecules/record_type_dropdown.dart';
import '../molecules/theme_toggle_button.dart';
import '../organisms/record_editor_dialog.dart';
import '../organisms/record_list.dart';

/// PAGE: puts the atoms, molecules and organisms together and connects
/// them to the database and the theme controller.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Always the same helper (and the same database connection).
  final DatabaseHelper _db = DatabaseHelper.instance;

  RecordType _selectedType = RecordType.songs;
  List<NoteRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  /// READ: loads the records of the selected type.
  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    try {
      final records = await _db.getRecords(type: _selectedType);
      if (!mounted) return; // The page may have been closed meanwhile.
      setState(() => _records = records);
    } catch (e) {
      // Prints the REAL error in your terminal so we can see the cause.
      debugPrint('Load error: $e');
      _showMessage('Could not load records.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// CREATE or UPDATE: opens the dialog, then saves the result.
  Future<void> _openEditor({NoteRecord? existing}) async {
    final result = await showDialog<NoteRecord>(
      context: context,
      builder: (_) =>
          RecordEditorDialog(type: _selectedType, existing: existing),
    );
    if (result == null) return; // User cancelled.

    try {
      if (existing == null) {
        await _db.insertRecord(result);
      } else {
        await _db.updateRecord(result);
      }
      await _loadRecords();
    } catch (e) {
      debugPrint('Save error: $e');
      _showMessage('Could not save the record.');
    }
  }

  /// DELETE: removes a record by its id.
  Future<void> _delete(NoteRecord record) async {
    try {
      await _db.deleteRecord(record.id!);
      await _loadRecords();
    } catch (e) {
      debugPrint('Delete error: $e');
      _showMessage('Could not delete the record.');
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  /// Chooses what to show in the body: spinner, empty message, or list.
  Widget _buildBody() {
    if (_loading) return const LoadingIndicator();
    if (_records.isEmpty) {
      return EmptyMessage(message: 'No ${_selectedType.label} yet.');
    }
    return RecordList(
      records: _records,
      onEdit: (record) => _openEditor(existing: record),
      onDelete: _delete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Notes'),
        actions: [
          // setDark() updates the UI AND saves the choice to disk.
          ThemeToggleButton(
            isDark: theme.isDark,
            onToggle: () => theme.setDark(!theme.isDark),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: RecordTypeDropdown(
              selected: _selectedType,
              onChanged: (type) {
                setState(() => _selectedType = type);
                _loadRecords();
              },
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add ${_selectedType.label}',
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}