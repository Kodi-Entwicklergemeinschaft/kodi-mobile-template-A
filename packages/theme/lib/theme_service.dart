part of 'theme.dart';


const String _themePrefsKey = 'app_theme_mode';

final themeServiceProvider = NotifierProvider<ThemeService, ThemeState>(
      () => ThemeService(),
);

class ThemeService extends Notifier<ThemeState> {
  late PreferenceManager _prefs;

  ThemeMode get mode {
    final themeString = _prefs.getStringOrNull(_themePrefsKey);
    if (themeString == 'dark') {
      return ThemeMode.dark;
    } else if (themeString == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.light; // Default to system theme
    }
  }

  @override
  ThemeState build() {
    _prefs = ref.watch(preferenceManagerProvider);
    return ThemeState(mode);
  }

  Future<void> toggleTheme(bool isDark) async {
    final newMode = isDark ? 'dark' : 'light';
    await _prefs.saveString(_themePrefsKey, newMode);
    state = ThemeState(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setMode(ThemeMode themeMode) async {
    String? themeString;
    if (themeMode == ThemeMode.dark) {
      themeString = 'dark';
    } else if (themeMode == ThemeMode.light) {
      themeString = 'light';
    } else {
      themeString = 'system';
    }
    await _prefs.saveString(_themePrefsKey, themeString);

    state = ThemeState(themeMode);
  }

}

