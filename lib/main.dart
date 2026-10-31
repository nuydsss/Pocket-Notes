import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';

/// App entry point.
///
/// We make main() async so we can set up the database engine and READ the
/// saved theme from disk BEFORE the first frame is drawn.
Future<void> main() async {
  // Required when calling plugins (shared_preferences) before runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite does not work on Windows/Linux by itself.
  // This switches it to the FFI version (desktop only).
  // On Android, iOS and macOS nothing changes.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Load the saved theme (light by default on the very first launch).
  final themeController = await ThemeController.load();

  runApp(PocketNotesApp(themeController: themeController));
}