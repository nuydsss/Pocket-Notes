import 'package:flutter/material.dart';

/// Holds the light and dark [ThemeData] used by the app.
/// Both are generated from the same seed color so they match.
class AppTheme {
  AppTheme._(); // Not meant to be instantiated.

  static const Color _seed = Colors.teal;

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
  );
}
