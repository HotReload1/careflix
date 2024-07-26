import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../shared_preferences/shared_preferences_instance.dart';
import '../shared_preferences/shared_preferences_key.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
  }

  Future initThemeMode() async {
    final prefs = SharedPreferencesInstance.pref;
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    final deviceThemeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    if (prefs.getString(SharedPreferencesKeys.ThemeMode) == null) {
      setThemeMode(deviceThemeMode);
      notifyListeners();
      return Null;
    }
    _themeMode = prefs.getString(SharedPreferencesKeys.ThemeMode)! ==
            ThemeMode.dark.toString()
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
    return Null;
  }

  changeThemeMode(ThemeMode themeMode) async {
    final prefs = SharedPreferencesInstance.pref;

    _themeMode = themeMode;
    await prefs.setString(
        SharedPreferencesKeys.ThemeMode, _themeMode.toString());
    notifyListeners();
  }
}
