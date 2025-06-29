import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.orange;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void setSeedColor(Color seedColor) {
    _seedColor = seedColor;
    notifyListeners();
  }
}
