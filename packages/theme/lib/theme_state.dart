part of 'theme.dart';

class ThemeState {
  final ThemeMode mode;

  const ThemeState(this.mode);

  bool get isDark => mode == ThemeMode.dark;
}
