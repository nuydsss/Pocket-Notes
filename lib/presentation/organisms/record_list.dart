import 'package:flutter/material.dart';

import '../../data/models/note_record.dart';
import '../molecules/record_list_tile.dart';

/// ORGANISM: the full scrollable list, built from many [RecordListTile]
/// molecules.
class RecordList extends StatelessWidget {
  const RecordList({
    super.key,
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  final List<NoteRecord> records;
  final ValueChanged<NoteRecord> onEdit;
  final ValueChanged<NoteRecord> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return RecordListTile(
          record: record,
          onTap: () => onEdit(record),
          onDelete: () => onDelete(record),
        );
      },
    );
  }
}
