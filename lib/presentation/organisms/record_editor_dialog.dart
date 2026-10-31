import 'package:flutter/material.dart';

import '../../data/models/note_record.dart';
import '../../data/models/record_type.dart';
import '../molecules/record_form_fields.dart';

/// ORGANISM: dialog for adding or editing a record.
///
/// It is a StatefulWidget so it can create AND dispose its text controllers
/// safely (avoids memory leaks). It pops a [NoteRecord] when saved, or null
/// when cancelled.
class RecordEditorDialog extends StatefulWidget {
  const RecordEditorDialog({super.key, required this.type, this.existing});

  final RecordType type;
  final NoteRecord? existing; // null = adding, not null = editing.

  @override
  State<RecordEditorDialog> createState() => _RecordEditorDialogState();
}

class _RecordEditorDialogState extends State<RecordEditorDialog> {
  late final TextEditingController _primary;
  late final TextEditingController _secondary;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Pre-fill the fields when editing.
    _primary = TextEditingController(text: widget.existing?.primaryValue ?? '');
    _secondary =
        TextEditingController(text: widget.existing?.secondaryDisplay ?? '');
  }

  @override
  void dispose() {
    _primary.dispose();
    _secondary.dispose();
    super.dispose();
  }

  void _save() {
    try {
      final record = NoteRecord.fromInput(
        id: widget.existing?.id, // Keep the same id when editing.
        type: widget.type,
        primary: _primary.text,
        secondary: _secondary.text,
      );
      Navigator.of(context).pop(record);
    } on FormatException catch (e) {
      // Show the validation message under the second field.
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.type.label;
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add $label' : 'Edit $label'),
      content: RecordFormFields(
        type: widget.type,
        primaryController: _primary,
        secondaryController: _secondary,
        secondaryError: _error,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
