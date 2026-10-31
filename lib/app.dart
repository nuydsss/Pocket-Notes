import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'presentation/pages/home_page.dart';

/// Root widget. It listens to [ThemeController] and rebuilds the
/// MaterialApp whenever the user switches between light and dark mode.
class PocketNotesApp extends StatelessWidget {
  const PocketNotesApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Pocket Notes',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          // This single value decides which theme is shown.
          themeMode: themeController.themeMode,
          home: HomePage(themeController: themeController),
        );
      },
    );
  }
}
