import 'package:deepfake_app/components/app_bar.dart';
import 'package:deepfake_app/screens/about_screen.dart';
import 'package:deepfake_app/screens/classify_screen.dart';
import 'package:deepfake_app/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../colors.dart';
import 'home_screen.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final titles = ["Home", "Classify", "History", "About Us"];
  int _currentIndex = 0;
  final screens = [
    HomeScreen(),
    ClassifyScreen(),
    HistoryScreen(),
    AboutScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_currentIndex],
        backgroundColor: DeepfakeColors.background,
        appBar: DeepfakeAppBar(
          title: titles[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: DeepfakeColors.secondary,
              title: Text(
                'Home',
              ),
              icon: Icon(
                FontAwesomeIcons.home,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: DeepfakeColors.secondary,
              title: Text('Classify'),
              icon: Icon(
                FontAwesomeIcons.atom,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: DeepfakeColors.secondary,
              title: Text('History'),
              icon: Icon(
                FontAwesomeIcons.history,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: DeepfakeColors.secondary,
              title: Text('About Us'),
              icon: Icon(
                FontAwesomeIcons.users,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
