import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_notes/app.dart';
import 'package:pocket_notes/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts and shows the title', (WidgetTester tester) async {
    // Fake (in-memory) shared_preferences with nothing saved yet.
    SharedPreferences.setMockInitialValues({});
    final themeController = await ThemeController.load();

    // PocketNotesApp now REQUIRES a themeController.
    await tester.pumpWidget(PocketNotesApp(themeController: themeController));
    await tester.pump();

    expect(find.text('Pocket Notes'), findsOneWidget);
  });

  testWidgets('Starts in dark mode when dark was saved',
      (WidgetTester tester) async {
    // Pretend the user chose dark mode in a previous session.
    SharedPreferences.setMockInitialValues({'is_dark_mode': true});
    final themeController = await ThemeController.load();

    await tester.pumpWidget(PocketNotesApp(themeController: themeController));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });

  testWidgets('Tapping the toggle switches theme and saves it',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final themeController = await ThemeController.load();

    await tester.pumpWidget(PocketNotesApp(themeController: themeController));
    await tester.pump();

    // Light mode shows the "dark_mode" icon. Tap it to switch to dark.
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    // The choice was also written to (mock) storage.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('is_dark_mode'), true);
  });
}