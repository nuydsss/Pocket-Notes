import 'package:flutter/material.dart';

import '../../data/models/record_type.dart';

/// MOLECULE: a labeled dropdown that lets the user choose the record type.
class RecordTypeDropdown extends StatelessWidget {
  const RecordTypeDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RecordType selected;
  final ValueChanged<RecordType> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RecordType>(
      initialValue: selected,
      decoration: const InputDecoration(
        labelText: 'Record type',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final type in RecordType.values)
          DropdownMenuItem(
            value: type,
            child: Text('${type.digit} - ${type.label}'),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
