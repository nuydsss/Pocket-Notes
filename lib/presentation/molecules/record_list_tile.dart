import 'package:flutter/material.dart';

import '../../data/models/note_record.dart';
import '../atoms/app_icon_button.dart';

/// MOLECULE: one row of the list. Shows the record's two fields and a
/// delete button (atom). Tapping the row asks the parent to edit it.
class RecordListTile extends StatelessWidget {
  const RecordListTile({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  final NoteRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final second = record.secondaryDisplay;
    return ListTile(
      title: Text(record.primaryValue),
      subtitle: Text(
        second.isEmpty ? '-' : '${record.type.secondaryLabel}: $second',
      ),
      onTap: onTap,
      trailing: AppIconButton(
        icon: Icons.delete_outline,
        tooltip: 'Delete',
        onPressed: onDelete,
      ),
    );
  }
}
