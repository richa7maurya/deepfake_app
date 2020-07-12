import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = ' Home ';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('My Page!')),
      drawer: Drawer(
        child: Container(
          color: const Color(0xff2874f7),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'THE SENTINELS ',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'DEEPFAKE RECOGNITION',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.0,
                thickness: 3.0,
                color: Colors.white,
                indent: 20.0,
                endIndent: 20.0,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    new Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('HOME', style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    new Icon(
                      Icons.compare,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('CLASSIFY', style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(children: <Widget>[
                  new Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('HISTORY', style: TextStyle(color: Colors.white)),
                ]),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(children: <Widget>[
                  new Icon(
                    Icons.people_outline,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('ABOUT US', style: TextStyle(color: Colors.white)),
                ]),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
