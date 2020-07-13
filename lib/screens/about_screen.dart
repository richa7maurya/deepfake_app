import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the About Us Screen",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
