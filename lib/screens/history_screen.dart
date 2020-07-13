import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the History Screen",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
