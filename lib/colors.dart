import 'package:flutter/material.dart';

class DeepfakeTheme {
  static ThemeData lightTheme = new ThemeData(
    cardColor: Colors.white,
    colorScheme: ColorScheme(
      primary: Color(0xffE14ECA),
      primaryVariant: Color(0xffE14ECA),
      secondaryVariant: Color(0xff007BFF),
      secondary: Color(0xff007BFF),
      background: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xff1E1E2F),
      onBackground: Color(0xff1E1E2F),
      onError: Colors.white,
      error: Color(0xffF5365C),
      brightness: Brightness.light,
    ),
    fontFamily: 'Poppins',
  );
  static ThemeData darkTheme = new ThemeData(
    cardColor: Color(0xff282A3F),
    colorScheme: ColorScheme(
      primary: Color(0xffE14ECA),
      primaryVariant: Color(0xffE14ECA),
      secondaryVariant: Color(0xff007BFF),
      secondary: Color(0xff007BFF),
      background: Color(0xff1E1E2F),
      surface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      error: Color(0xffF5365C),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Poppins',
  );
}
