import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../colors.dart';

class DeepfakeDrawer extends StatelessWidget {
  const DeepfakeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: DeepfakeColors.secondary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'THE SENTINELS ',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'DEEPFAKE RECOGNITION',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0.0,
              thickness: 2.0,
              color: Colors.white,
              indent: 20.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.home,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'HOME',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.atom,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'CLASSIFY',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/classify');
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.history,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'HISTORY',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.users,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'ABOUT US',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}
