import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers whether the user chose dark mode.
///
/// HOW IT SURVIVES A FORCE-KILL:
/// shared_preferences writes the value to the device's storage (disk),
/// not to memory. So when the app is killed and reopened, [load] reads
/// the same value back.
class ThemeController extends ChangeNotifier {
  ThemeController._(this._prefs, this._isDark);

  /// Key used to store the value on disk.
  static const String _prefsKey = 'is_dark_mode';

  final SharedPreferences _prefs;
  bool _isDark;

  bool get isDark => _isDark;

  /// The value MaterialApp needs.
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  /// Reads the saved choice. Call this in main() before runApp().
  static Future<ThemeController> load() async {
    final prefs = await SharedPreferences.getInstance();
    // "?? false" is used ONLY when nothing has ever been saved (first launch).
    final saved = prefs.getBool(_prefsKey) ?? false;
    return ThemeController._(prefs, saved);
  }

  /// Changes the theme, updates the screen, then saves it to disk.
  Future<void> setDark(bool value) async {
    if (value == _isDark) return;
    _isDark = value;
    notifyListeners(); // Update the UI immediately.
    await _prefs.setBool(_prefsKey, value); // Persist for the next launch.
  }
}
