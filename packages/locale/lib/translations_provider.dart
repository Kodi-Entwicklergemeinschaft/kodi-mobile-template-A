// core/localization/translations_provider.dart
import 'package:flutter/widgets.dart';

abstract class TranslationsProvider {
  /// List of locales your app supports.
  List<Locale> get supportedLocales;

  /// Returns the localized key-value map for a given locale.
  /// Should always return a map (can fall back to en internally).
  Map<String, String> getLocalizedValues(Locale locale);
}
