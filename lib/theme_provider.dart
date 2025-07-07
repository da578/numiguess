import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  void setSeedColor(Color seedColor) {
    _seedColor = seedColor;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final colorValue =
        preferences.getInt('seedColor') ?? Colors.blue.toARGB32();
    _seedColor = Color(colorValue);
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('seedColor', _seedColor.toARGB32());
    await preferences.setString('themeMode', _themeMode.name);
  }
}
