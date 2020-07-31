import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LangLocalization {
  final Locale locale;

  LangLocalization(this.locale);

  static LangLocalization of(BuildContext context) {
    return Localizations.of<LangLocalization>(context, LangLocalization);
  }

  Map<String, dynamic> _localizedValues;
  Future load() async {
    String jsonStringValues =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson;
    // mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  Map<String, dynamic> getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<LangLocalization> delegate =
      _LangLocalizationDelegate();
}

class _LangLocalizationDelegate
    extends LocalizationsDelegate<LangLocalization> {
  const _LangLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'gu'].contains(locale.languageCode);
  }

  @override
  Future<LangLocalization> load(Locale locale) async {
    LangLocalization localization = new LangLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_LangLocalizationDelegate old) => false;
}
