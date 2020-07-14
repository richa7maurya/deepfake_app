import 'package:flutter/material.dart';
import '../colors.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Hi! You can begin classifying videos or photos by tapping the UPLOAD button below',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          RaisedButton(
            color: DeepfakeColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/classify');
            },
            child: const Text('UPLOAD',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
