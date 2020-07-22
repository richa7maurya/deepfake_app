import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/components/wave_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globals.dart';

class LoginScreen extends StatefulWidget {
  final Function callback;

  const LoginScreen({Key key, this.callback}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isApiCalled = false;
  Dio dio = new Dio();

  TextEditingController nameController,
      usernameController,
      emailController,
      passwordController;
  @override
  void initState() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    nameController.dispose();

    super.dispose();
  }

  handleLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;

      try {
        this.setState(() {
          this.isApiCalled = true;
        });
        this._showSnackbar(context, "Logging In ...");
        final response = await dio.post(
          '$serverURL/users/login',
          data: {
            "username": username,
            "password": password,
          },
        );

        if (response.data["success"]) {
          this.widget.callback(response.data);
        }
        this.setState(() {
          this.isApiCalled = false;
        });
        Scaffold.of(context).hideCurrentSnackBar();
      } on DioError catch (e) {
        Scaffold.of(context).hideCurrentSnackBar();
        this.setState(() {
          this.isApiCalled = false;
        });
        if (e.response.statusCode == 401) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: DeepfakeTheme.lightTheme.colorScheme.surface,
                content: Text(
                  'Oops! Something went wrong. Perhaps check your username and password',
                  style: TextStyle(
                    color: DeepfakeTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: DeepfakeTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  handleSignup(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final name = nameController.text;
      final email = emailController.text;
      final username = usernameController.text;
      final password = passwordController.text;
      try {
        this.setState(() {
          this.isApiCalled = true;
        });
        this._showSnackbar(context, "Signing Up ...");
        final res = await dio.post(
          '$serverURL/users/signup',
          data: {
            "username": username,
            "password": password,
            "name": name,
            "email": email,
          },
        );
        if (res.data["success"]) {
          // * Login the user automatically
          this.handleLogin(context);
        }
        this.setState(() {
          this.isApiCalled = false;
        });
        Scaffold.of(context).hideCurrentSnackBar();
      } on DioError catch (e) {
        Scaffold.of(context).hideCurrentSnackBar();
        this.setState(() {
          this.isApiCalled = false;
        });
        if (e.response.statusCode != 200)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: DeepfakeTheme.lightTheme.colorScheme.surface,
                content: Text(
                  'Oops! This username is taken.',
                  style: TextStyle(
                    color: DeepfakeTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: DeepfakeTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
      }
    }
  }

  _showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Container(
        alignment: Alignment.centerLeft,
        height: 30,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    DeepfakeTheme.darkTheme.colorScheme.primary,
                  ),
                ),
                height: 18.0,
                width: 18.0,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: DeepfakeTheme.darkTheme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: DeepfakeTheme.darkTheme.colorScheme.background,
      duration: Duration(days: 1),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Builder(
        builder: (context) {
          return Visibility(
            visible: !this.isApiCalled,
            child: FloatingActionButton(
              backgroundColor: DeepfakeTheme.darkTheme.colorScheme.primary,
              onPressed: () {
                if (isLogin)
                  this.handleLogin(context);
                else
                  this.handleSignup(context);
              },
              child: Icon(
                FontAwesomeIcons.chevronRight,
                size: 16,
              ),
            ),
          );
        },
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
              child: Padding(
                padding: const EdgeInsets.only(right: 22.0, left: 22.0),
                child: Column(
                  children: [
                    if (!isLogin)
                      OutlinedTextFormField(
                        controller: emailController,
                        hintText: 'Please enter your email',
                        isPassword: false,
                        prefixIcon: FontAwesomeIcons.envelope,
                        validate: (value) {
                          print(value);
                          if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value))
                            return null;
                          else
                            return "Enter valid Email id";
                        },
                      ),
                    if (!isLogin)
                      OutlinedTextFormField(
                        controller: nameController,
                        hintText: 'Please enter your full name',
                        isPassword: false,
                        prefixIcon: FontAwesomeIcons.pencilAlt,
                        validate: (value) {
                          print(value);
                          if (value.split(' ').contains(''))
                            return "Enter valid name";
                          else if (RegExp(r"^[A-Za-z\\s]+").hasMatch(value))
                            return null;
                          else
                            return "Only letters and spaces allowed";
                        },
                      ),
                    OutlinedTextFormField(
                      controller: usernameController,
                      hintText: 'Please enter your username',
                      isPassword: false,
                      prefixIcon: FontAwesomeIcons.user,
                      validate: (value) {
                        print(value);
                        if (value.split(' ').contains(''))
                          return "Enter valid username";
                        else
                          return null;
                      },
                    ),
                    OutlinedTextFormField(
                      controller: passwordController,
                      hintText: 'Please enter your password',
                      isPassword: true,
                      prefixIcon: FontAwesomeIcons.eye,
                      validate: (value) {
                        if (isLogin) {
                          if (value.length == 0) return "Enter a password";
                        } else {
                          if (value.contains(" "))
                            return "No spaces allowed";
                          else if (RegExp(
                                  r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
                              .hasMatch(value))
                            return null;
                          else {
                            print(value.length);
                            if (value.length < 8)
                              return "Length of password should be atleast 8 letter";
                            else if (!RegExp(r"[A-Z]+").hasMatch(value))
                              return "Password must contain atleast 1 Uppercase Letter";
                            else if (!RegExp(r"[a-z]+").hasMatch(value))
                              return "Password must contain atleast 1 Lowercase Letter";
                            else if (!RegExp(r"[0-9]+").hasMatch(value))
                              return "Password must contain atleast 1 number";
                            else
                              return "Password must contain atleast 1 special symbol";
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Text(
              isLogin ? "Don't have an account?" : "Already have an account?",
              style: TextStyle(
                color: DeepfakeTheme.darkTheme.cardColor,
              ),
            ),
            FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? 'Sign Up' : 'Login',
                        style: TextStyle(
                          fontSize: 24,
                          color: DeepfakeTheme.darkTheme.cardColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        FontAwesomeIcons.arrowRight,
                        size: 16,
                        color: DeepfakeTheme.darkTheme.cardColor,
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    _formKey.currentState.reset();
                  });
                }),
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
    this.isPassword,
    this.controller,
    this.validate,
  }) : super(key: key);

  final prefixIcon, suffixIcon, hintText, isPassword, controller, validate;

  @override
  _OutlinedTextFormFieldState createState() => _OutlinedTextFormFieldState();
}

class _OutlinedTextFormFieldState extends State<OutlinedTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
          style: TextStyle(color: Colors.black),
          controller: this.widget.controller,
          obscureText: obscureText && this.widget.isPassword,
          decoration: InputDecoration(
            prefixIcon: this.widget.prefixIcon != null
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: !this.widget.isPassword
                        ? Icon(
                            this.widget.prefixIcon,
                            size: 18,
                            color: DeepfakeTheme.darkTheme.cardColor,
                          )
                        : Icon(
                            obscureText
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 18,
                            color: DeepfakeTheme.darkTheme.cardColor,
                          ),
                    color: DeepfakeTheme.darkTheme.cardColor,
                  )
                : null,
            hintStyle: TextStyle(
              color: DeepfakeTheme.darkTheme.colorScheme.background
                  .withOpacity(0.7),
            ),
            hintText: this.widget.hintText,
            focusColor: DeepfakeTheme.darkTheme.colorScheme.secondary,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: DeepfakeTheme.darkTheme.colorScheme.background,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: DeepfakeTheme.darkTheme.colorScheme.secondary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: DeepfakeTheme.darkTheme.colorScheme.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: DeepfakeTheme.darkTheme.colorScheme.error,
                width: 2.0,
              ),
            ),
          ),
          validator: this.widget.validate),
    );
  }
}
