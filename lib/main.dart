import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/root.dart';
import 'package:flutter/material.dart';
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

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeChanger _theme = Provider.of(context);
    return MaterialApp(
      title: 'Deepfake',
      routes: {
        '/': (context) => Root(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: _theme.getTheme(),
    );
  }
}
