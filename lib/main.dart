import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/localization/LangLocalization.dart';
import 'package:deepfake_app/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'blocs/theme.dart';

void main() => runApp(DeepfakeApp());

class DeepfakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(DeepfakeTheme.darkTheme),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatefulWidget {
  const MaterialAppWithTheme({
    Key key,
  }) : super(key: key);
  static void setLocale(BuildContext context, Locale locale) {
    _MaterialAppWithThemeState state =
        context.findAncestorStateOfType<_MaterialAppWithThemeState>();
    state.setLocale(locale);
  }

  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _theme = Provider.of(context);
    return MaterialApp(
      title: 'Deepfake',
      theme: _theme.getTheme(),
      locale: _locale,
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('hi', 'IN'), // Hindi - India
        const Locale('gu', 'IN'), // Gujarati - India
      ],
      localizationsDelegates: [
        LangLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Root(),
      },
      initialRoute: '/',
    );
  }
}
