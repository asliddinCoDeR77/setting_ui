import 'package:flutter/material.dart';

class AppThemeMode {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier(ThemeMode.light);

  static ThemeMode get themeMode => themeModeNotifier.value;

  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}
