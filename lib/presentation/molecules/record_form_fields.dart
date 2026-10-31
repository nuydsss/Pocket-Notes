import 'package:flutter/material.dart';

import '../../data/models/record_type.dart';
import '../atoms/app_text_field.dart';

/// MOLECULE: the two text fields (atoms) used to type a record.
/// Labels and keyboard type change automatically with the [RecordType].
class RecordFormFields extends StatelessWidget {
  const RecordFormFields({
    super.key,
    required this.type,
    required this.primaryController,
    required this.secondaryController,
    this.secondaryError,
  });

  final RecordType type;
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final String? secondaryError;

  /// Picks a suitable on-screen keyboard for the second field.
  TextInputType get _secondaryKeyboard => switch (type.secondaryKind) {
        SecondaryKind.integer => TextInputType.number,
        SecondaryKind.real =>
          const TextInputType.numberWithOptions(decimal: true),
        _ => TextInputType.text,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: primaryController,
          label: type.primaryLabel,
        ),
        AppTextField(
          controller: secondaryController,
          label: type.secondaryLabel,
          keyboardType: _secondaryKeyboard,
          errorText: secondaryError,
        ),
      ],
    );
  }
}
