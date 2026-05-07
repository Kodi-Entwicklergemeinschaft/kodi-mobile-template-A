// locale_controller.dart
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:shared_dependencies/riverpod.dart';

import 'package:local_storage/preference_manager.dart';
import 'package:local_storage/preference_manager_impl.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(() {
  return LocaleController();
});

const String _localPrefsKey = 'local_pref_key';
class LocaleController extends Notifier<Locale> {
  late PreferenceManager _prefs;
  @override
  Locale build() {
    _prefs = ref.read(preferenceManagerProvider);
    final saved = _prefs.getStringOrEmpty(_localPrefsKey);
    if (saved.isNotEmpty) {
      return Locale(saved);
    }

    // Default to device locale base lang
    final device = PlatformDispatcher.instance.locale;
    final code = _normalize(device.languageCode);

    // persist for future
    _prefs.saveString(_localPrefsKey, code);

    return Locale(code);
  }


  void setLocale(Locale locale) {
    _prefs.saveString(_localPrefsKey, locale.languageCode);
    state = locale;
  }

  // Convenience helpers (optional)
  void setLangCode(String code) => state = Locale(code);
  bool isCurrent(String code) => state.languageCode == code;

  String getCurrentLanguageCode() {
    return state.languageCode;
  }

  String _normalize(String code) {
    return code.split('_').first.split('-').first.toLowerCase();
  }

}
