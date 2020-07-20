import 'dart:async';

import 'package:flutter/material.dart';
import 'package:deepfake_app/colors.dart';

class Box extends StatelessWidget {
  final width, height, text;
  final color, opacity;

  const Box(
      {Key key, this.width, this.height, this.color, this.opacity, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: this.color.withOpacity(this.opacity)),
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
            left: this.width * 0.1,
            top: this.height * 0.42,
          ),
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        width: this.width,
        height: this.height,
      ),
    );
  }
}

class WavePattern extends StatefulWidget {
  const WavePattern({
    Key key,
    this.text,
    this.heightRatio,
  }) : super(key: key);

  final text, heightRatio;

  @override
  _WavePatternState createState() => _WavePatternState();
}

class _WavePatternState extends State<WavePattern>
    with TickerProviderStateMixin {
  AnimationController _backController;
  AnimationController _frontController;
  Animation<double> backAnimation;
  Animation<double> frontAnimation;

  @override
  void initState() {
    super.initState();
    _backController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    _frontController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );

    backAnimation = _backController.drive(
      CurveTween(
        curve: Curves.easeOut,
      ),
    );

    frontAnimation = _frontController.drive(
      CurveTween(
        curve: Curves.easeOut,
      ),
    );

    _backController.addListener(() {
      setState(() {});
    });

    _frontController.addListener(() {
      setState(() {});
    });

    _frontController.forward();

    Future.delayed(Duration(milliseconds: 500), () {
      _backController.forward();
    });
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          child: Box(
            text: this.widget.text,
            opacity: backAnimation.value,
            color: DeepfakeTheme.darkTheme.colorScheme.background,
            width: MediaQuery.of(context).size.width,
            height:
                (MediaQuery.of(context).size.height * this.widget.heightRatio) *
                    backAnimation.value,
          ),
          clipper: BackClipper(),
        ),
        ClipPath(
          child: Box(
            text: "",
            opacity: frontAnimation.value,
            color: DeepfakeTheme.darkTheme.colorScheme.primary,
            width: MediaQuery.of(context).size.width / 2.5,
            height: (MediaQuery.of(context).size.height *
                    this.widget.heightRatio *
                    0.5) *
                frontAnimation.value,
          ),
          clipper: FrontClipper(),
        )
      ],
    );
  }
}

class FrontClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * .7);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.9,
      size.width * 0.48,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.01,
      size.width,
      0,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class BackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * .7);
    path.quadraticBezierTo(
        size.width * 0.3, size.height, size.width * 0.55, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.2, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
