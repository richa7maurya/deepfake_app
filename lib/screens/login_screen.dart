import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/components/wave_pattern.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  TextEditingController fullName, username, email, password;
  @override
  void initState() {
    fullName = TextEditingController();
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    username.dispose();
    fullName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: DeepfakeColors.primary,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            print('All good');
            print({
              "full_name": fullName.text,
              "email": email.text,
              "username": username.text,
              "password": password.text,
            });
          }
        },
        child: Icon(
          FontAwesomeIcons.chevronRight,
          size: 16,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WavePattern(
              text: isLogin ? 'Welcome\nBack' : 'Create an\nAccount',
              heightRatio: 0.35,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLogin)
                    OutlinedTextFormField(
                      controller: email,
                      hintText: 'Enter Email',
                      prefixIcon: FontAwesomeIcons.envelope,
                      validationMessage: 'Please enter your email',
                      isPassword: false,
                    ),
                  if (!isLogin)
                    OutlinedTextFormField(
                      controller: fullName,
                      hintText: 'Enter Full Name',
                      prefixIcon: FontAwesomeIcons.pencilAlt,
                      validationMessage: 'Please enter your full name',
                      isPassword: false,
                    ),
                  OutlinedTextFormField(
                    controller: username,
                    prefixIcon: FontAwesomeIcons.user,
                    hintText: 'Enter Username',
                    validationMessage: 'Please enter your username',
                    isPassword: false,
                  ),
                  OutlinedTextFormField(
                    controller: password,
                    hintText: 'Enter Password',
                    prefixIcon: FontAwesomeIcons.eye,
                    validationMessage: 'Please enter your password',
                    isPassword: true,
                  ),
                ],
              ),
            ),
            Text(
              isLogin ? "Don't have an account?" : "Already have an account?",
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isLogin ? 'Sign Up' : 'Login',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                  _formKey.currentState.reset();
                });
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class OutlinedTextFormField extends StatefulWidget {
  const OutlinedTextFormField({
    Key key,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.validationMessage,
    this.isPassword,
    this.controller,
  }) : super(key: key);

  final prefixIcon,
      suffixIcon,
      hintText,
      validationMessage,
      isPassword,
      controller;

  @override
  _OutlinedTextFormFieldState createState() => _OutlinedTextFormFieldState();
}

class _OutlinedTextFormFieldState extends State<OutlinedTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      child: TextFormField(
        controller: this.widget.controller,
        obscureText: obscureText && this.widget.isPassword,
        decoration: InputDecoration(
          fillColor: Colors.white,
          prefixIcon: this.widget.prefixIcon != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    this.widget.prefixIcon,
                    size: 18,
                  ),
                  color: DeepfakeColors.secondary,
                )
              : null,
          hintStyle: TextStyle(
            color: DeepfakeColors.secondary.withOpacity(0.7),
          ),
          hintText: this.widget.hintText,
          focusColor: DeepfakeColors.secondary,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: DeepfakeColors.secondary, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DeepfakeColors.secondary, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DeepfakeColors.secondary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DeepfakeColors.danger, width: 2.0),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return this.widget.validationMessage;
          }
          return null;
        },
      ),
    );
  }
}
