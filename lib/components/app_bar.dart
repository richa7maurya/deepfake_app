import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
      "Logout",
      style: TextStyle(
        color: _theme.colorScheme.onBackground,
      ),
    );
  }
}

class _DeepfakeAppBarState extends State<DeepfakeAppBar> {
  final options = [
    ThemeChangerWidget(),
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
          "Theme",
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
