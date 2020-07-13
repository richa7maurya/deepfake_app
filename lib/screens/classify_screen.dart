import 'package:flutter/material.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Classify Screen",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
