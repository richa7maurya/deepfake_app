import 'package:deepfake_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeepfakeAppBar extends StatefulWidget implements PreferredSizeWidget {
  DeepfakeAppBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  _DeepfakeAppBarState createState() => _DeepfakeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

bool isDark = true;

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
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.title,
      ),
      actions: [
        PopupMenuButton<dynamic>(
          tooltip: 'Settings',
          color: Colors.black,
          onSelected: (value) {
            if (value.runtimeType.toString() == 'ThemeChanger') {
              setState(() {
                isDark = !isDark;
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
          style: TextStyle(color: Colors.white),
        ),
        Icon(
          isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
        )
      ],
    );
  }
}
