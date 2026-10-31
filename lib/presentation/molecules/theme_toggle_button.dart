import 'package:flutter/material.dart';

import '../atoms/app_icon_button.dart';

/// MOLECULE: an icon button (atom) that shows the right icon for the
/// current theme and tells the parent when it is tapped.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: isDark ? Icons.light_mode : Icons.dark_mode,
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: onToggle,
    );
  }
}
