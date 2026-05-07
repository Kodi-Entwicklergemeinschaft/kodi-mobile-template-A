import 'package:flutter/widgets.dart';
import 'package:locale/locale.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'de.dart';
import 'en.dart';
import 'da.dart';
import 'ar.dart';
import 'fa.dart';
import 'no.dart';
import 'ru.dart';
import 'sv.dart';
import 'tr.dart';
import 'uk.dart';

final appTranslationProvider = Provider((ref) => AppTranslationsProvider());

class AppTranslationsProvider implements TranslationsProvider {
  static const _fallback = Locale('en');

  @override
  List<Locale> get supportedLocales => localeNames.keys.toList();

  // ⭐ BiMap ensures unique keys & values
  final Map<Locale, String> localeNames = Map.of({
    const Locale("en"): 'English',
    const Locale("de"): 'Deutsch',
    const Locale("ar"): 'العربية',
    const Locale("da"): 'Dansk',
    const Locale("fa"): 'فارسی',
    const Locale("no"): 'Norsk',
    const Locale("ru"): 'Русский',
    const Locale("sv"): 'Svenska',
    const Locale("tr"): 'Türkçe',
    const Locale("uk"): 'Українська',
  });

  late final Map<String, Locale> nameToLocale = {
    for (var e in localeNames.entries) e.value: e.key,
  };

  String languageDisplayName(Locale locale) {
    return localeNames[locale] ?? locale.languageCode;
  }

  Locale localeFromName(String name) {
    return nameToLocale[name] ?? _fallback;
  }

  @override
  Map<String, String> getLocalizedValues(Locale locale) {
    switch (locale.languageCode) {
      case 'de':
        return de;
      case 'ar':
        return ar;
      case 'da':
        return da;
      case 'fa':
        return fa;
      case 'no':
        return no;
      case 'ru':
        return ru;
      case 'sv':
        return sv;
      case 'tr':
        return tr;
      case 'uk':
        return uk;
      case 'en':
      default:
        return en;
    }
  }
}
