import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/localization/LangLocalization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DeepfakeAppBar extends StatefulWidget implements PreferredSizeWidget {
  DeepfakeAppBar({
    Key key,
    @required this.title,
    this.callback,
  }) : super(key: key);

  final String title;

  final Function callback;

  @override
  _DeepfakeAppBarState createState() => _DeepfakeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

bool darkMode = true;

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Text(
      LangLocalization.of(context).getTranslatedValue('appbar')["logout"],
      style: TextStyle(
        color: _theme.colorScheme.onBackground,
      ),
    );
  }
}

class Language extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {
        "language":
            LangLocalization.of(context).getTranslatedValue('appbar')["eng"],
        "value": "en"
      },
      {
        "language":
            LangLocalization.of(context).getTranslatedValue('appbar')["hindi"],
        "value": "hi"
      },
      {
        "language":
            LangLocalization.of(context).getTranslatedValue('appbar')["guj"],
        "value": "gu"
      },
    ];
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return new DropdownButton<String>(
      hint: Text(
        LangLocalization.of(context).getTranslatedValue('appbar')["lang"],
        style: TextStyle(color: _theme.colorScheme.onBackground),
      ),
      dropdownColor: _theme.colorScheme.background,
      items: languages.map((Map<String, String> language) {
        return new DropdownMenuItem<String>(
          onTap: () {
            Locale _temp;
            switch (language["value"]) {
              case 'en':
                _temp = Locale('en', 'US');
                break;
              case 'hi':
                _temp = Locale('hi', 'IN');
                break;
              case 'gu':
                _temp = Locale('gu', 'IN');
                break;
            }
            MaterialAppWithTheme.setLocale(context, _temp);
            print(language["value"]);
          },
          value: language["value"],
          child: new Text(
            language["language"],
            style: TextStyle(color: _theme.colorScheme.onBackground),
          ),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }
}

class _DeepfakeAppBarState extends State<DeepfakeAppBar> {
  final options = [
    ThemeChangerWidget(),
    Language(),
    Logout(),
  ];

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 3,
            color: _theme.colorScheme.secondary,
          ),
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(
            color: _theme.colorScheme.onBackground,
          ),
        ),
        actions: [
          PopupMenuButton<dynamic>(
            tooltip: 'Settings',
            color: _theme.colorScheme.surface,
            onSelected: (value) {
              if (value.runtimeType.toString() == 'ThemeChangerWidget') {
                darkMode = !darkMode;
                if (darkMode) {
                  _themeChanger.setTheme(DeepfakeTheme.darkTheme);
                } else {
                  _themeChanger.setTheme(DeepfakeTheme.lightTheme);
                }
              } else {
                this.widget.callback();
              }
            },
            itemBuilder: (context) {
              return options.map((choice) {
                return PopupMenuItem(
                  value: choice,
                  child: choice,
                );
              }).toList();
            },
            icon: Icon(
              FontAwesomeIcons.cog,
              size: 20,
              color: _theme.colorScheme.onBackground,
            ),
          )
        ],
      ),
    );
  }
}

class ThemeChangerWidget extends StatefulWidget {
  const ThemeChangerWidget({
    Key key,
  }) : super(key: key);

  @override
  _ThemeChangerWidgetState createState() => _ThemeChangerWidgetState();
}

class _ThemeChangerWidgetState extends State<ThemeChangerWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LangLocalization.of(context).getTranslatedValue('appbar')["theme"],
          style: TextStyle(
            color: _theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(
          width: 1,
        ),
        Icon(
          _themeChanger.getTheme() == DeepfakeTheme.darkTheme
              ? FontAwesomeIcons.moon
              : FontAwesomeIcons.sun,
          color: _theme.colorScheme.onSurface,
        )
      ],
    );
  }
}
