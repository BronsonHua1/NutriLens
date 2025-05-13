import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

enum AppTheme {
  light,
  dark,
  warm,
  nature,
}

class ColorThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ColorThemeProvider() {
    // This ensures the theme values are initialized
    ThemeColor.setLightTheme();
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;

    switch (theme) {
      case AppTheme.light:
        ThemeColor.setLightTheme();
        break;
      case AppTheme.dark:
        ThemeColor.setDarkTheme();
        break;
      case AppTheme.warm:
        ThemeColor.setWarmTheme();
        break;
      case AppTheme.nature:
        ThemeColor.setNatureTheme();
        break;
    }

    notifyListeners();
  }
}