import 'package:deepfake_app/components/app_bar.dart';
import 'package:deepfake_app/globals.dart';
import 'package:deepfake_app/localization/LangLocalization.dart';
import 'package:deepfake_app/screens/about_screen.dart';
import 'package:deepfake_app/screens/classify_screen.dart';
import 'package:deepfake_app/screens/history_screen.dart';
import 'package:deepfake_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'blocs/theme.dart';
import 'screens/home_screen.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;
  HomeScreen homeScreen;
  final screens = [
    ClassifyScreen(),
    HistoryScreen(),
    AboutScreen(),
  ];

  final controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    homeScreen = HomeScreen(callback: this.callback);
    screens.insert(0, homeScreen);
  }

  void callback(int i) {
    setState(() {
      _currentIndex = i;
    });
    controller.jumpToPage(i);
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  afterLogin(data) {
    userId = data["id"];
    bearerToken = data["token"];
    name = data["name"];
    loggedIn = !loggedIn;
    setState(() {});
  }

  logout() {
    userId = "";
    bearerToken = "";
    name = "";
    loggedIn = !loggedIn;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      LangLocalization.of(context).getTranslatedValue('routes')["home"],
      LangLocalization.of(context).getTranslatedValue('routes')["classify"],
      LangLocalization.of(context).getTranslatedValue('routes')["History"],
      LangLocalization.of(context).getTranslatedValue('routes')["About"],
    ];
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return SafeArea(
      child: !loggedIn
          ? LoginScreen(
              callback: this.afterLogin,
            )
          : Scaffold(
              body: PageView(
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: screens,
                controller: controller,
              ),
              backgroundColor: _theme.colorScheme.background,
              appBar: DeepfakeAppBar(
                title: titles[_currentIndex],
                callback: this.logout,
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[300],
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: _theme.colorScheme.secondary,
                    title: Text(
                      LangLocalization.of(context)
                          .getTranslatedValue('routes')["home"],
                    ),
                    icon: Icon(
                      FontAwesomeIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: _theme.colorScheme.secondary,
                    title: Text(
                      LangLocalization.of(context)
                          .getTranslatedValue('routes')["classify"],
                    ),
                    icon: Icon(
                      FontAwesomeIcons.atom,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: _theme.colorScheme.secondary,
                    title: Text(
                      LangLocalization.of(context)
                          .getTranslatedValue('routes')["History"],
                    ),
                    icon: Icon(
                      FontAwesomeIcons.history,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: _theme.colorScheme.secondary,
                    title: Text(
                      LangLocalization.of(context)
                          .getTranslatedValue('routes')["About"],
                    ),
                    icon: Icon(
                      FontAwesomeIcons.users,
                    ),
                  ),
                ],
                onTap: (index) {
                  if (Navigator.of(context).canPop())
                    Navigator.of(context).pop();
                  controller.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
    );
  }
}
