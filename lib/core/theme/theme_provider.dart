import 'package:invengo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = AppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toogleTheme() {
    if (_themeData == AppTheme.lightTheme) {
      themeData = AppTheme.darkTheme;
    } else {
      themeData = AppTheme.lightTheme;
    }
  }
}
