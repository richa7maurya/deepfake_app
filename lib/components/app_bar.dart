import 'package:deepfake_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:deepfake_app/globals.dart';

class DeepfakeAppBar extends StatefulWidget implements PreferredSizeWidget {
  DeepfakeAppBar({
    Key key,
    @required this.onChange,
    @required this.title,
  }) : super(key: key);

  final String title;
  final Function onChange;

  @override
  _DeepfakeAppBarState createState() => _DeepfakeAppBarState(this.onChange);

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _DeepfakeAppBarState extends State<DeepfakeAppBar> {
  final options = [
    ThemeChanger(),
    Center(
      child: RaisedButton(
        onPressed: () => print("Logout"),
        color: DeepfakeColors.danger,
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: DeepfakeColors.danger),
        ),
      ),
    ),
  ];

  Function onChange;
  _DeepfakeAppBarState(this.onChange);

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.title,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      actions: [
        PopupMenuButton<dynamic>(
          tooltip: 'Settings',
          color: isDark ? Colors.black : Colors.white,
          onSelected: (value) {
            if (value.runtimeType.toString() == 'ThemeChanger') {
              setState(() {
                isDark = !isDark;
                this.onChange();
              });
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
            color: isDark ? Colors.white : Colors.black,
          ),
        )
      ],
    );
  }
}

class ThemeChanger extends StatefulWidget {
  const ThemeChanger({
    Key key,
  }) : super(key: key);

  @override
  _ThemeChangerState createState() => _ThemeChangerState();
}

class _ThemeChangerState extends State<ThemeChanger> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Theme",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        Icon(
          isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
          color: isDark ? Colors.white : Colors.black,
        )
      ],
    );
  }
}
