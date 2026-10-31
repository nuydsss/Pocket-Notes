import 'package:flutter/material.dart';

/// ATOM: a centered message shown when a list has nothing in it.
class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
