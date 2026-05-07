import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations_provider.dart';

class AppLocalization {
  final Locale locale;
  final TranslationsProvider _provider;

  AppLocalization(this.locale, this._provider);

  static AppLocalization of(BuildContext context) =>
      Localizations.of<AppLocalization>(context, AppLocalization)!;

  static List<String> languages(TranslationsProvider provider) =>
      provider.supportedLocales.map((e) => e.languageCode).toList();

  String getTranslatedString(String key) {
    try {
      return _provider.getLocalizedValues(locale)[key] ?? key;
    } catch (_) {
      return key;
    }
  }
}

extension StringTr on String {
  String tr(BuildContext context) => AppLocalization.of(context).getTranslatedString(this);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate(this.provider);
  final TranslationsProvider provider;

  static Iterable<LocalizationsDelegate<dynamic>> delegates(TranslationsProvider provider) => [
    AppLocalizationsDelegate(provider),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages(provider).contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) =>
      SynchronousFuture<AppLocalization>(AppLocalization(locale, provider));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) => false;
}
