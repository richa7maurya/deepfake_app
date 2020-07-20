import 'package:deepfake_app/blocs/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<Map<String, dynamic>> team;
  List<Widget> teamList = [];
  _AboutScreenState() {
    this.team = [
      {
        "name": "Sakshi Doshi",
        "designation": "Team Leader",
        "img": "sakshi.jpeg",
        "github": "SaShaShady",
        "linkedin": "sakshi-doshi-84b899a3",
        "quote": "Be brave enough to be bad at something new",
        "quoteHeight": 34.0
      },
      {
        "name": "Akash Lende",
        "designation": "Full Stack Developer",
        "img": "akash.jpeg",
        "github": "akashlende",
        "linkedin": "akashlende",
        "quote": "Turning Coffee ☕  into Code 💻",
        "quoteHeight": 34.0
      },
      {
        "name": "Richa Maurya",
        "designation": "Full Stack Developer",
        "img": "richa.jpg",
        "github": "richa7maurya",
        "linkedin": "richa7maurya",
        "quote": "Trust the Process ☮",
        "quoteHeight": 0.0
      },
      {
        "name": "Varun Irani",
        "designation": "Full Stack Developer",
        "img": "varun.jpeg",
        "github": "VarunIrani",
        "linkedin": "varun-irani-b4275b192",
        "quote": "Pianist 🎹 + Developer ⚛️ = Gullible Genius",
        "quoteHeight": 34.0
      },
      {
        "name": "Parag Ghorpade",
        "designation": "ML Developer",
        "img": "parag.jpeg",
        "github": "Parag0506",
        "linkedin": "parag-ghorpade",
        "quote": "Learning . . .  1 epoch at a time ⏳",
        "quoteHeight": 34.0
      },
      {
        "name": "Hrishikesh Mane",
        "designation": "ML Developer",
        "img": "mane.jpeg",
        "github": "hrishikeshmane",
        "linkedin": "hrishikesh-mane-755bab16a",
        "quote": "Struggling for extra cloud credits ☁💸",
        "quoteHeight": 34.0
      },
    ];
  }
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < this.team.length; i++) {
      teamList.add(
        TeamCard(
            this.team[i]["name"],
            this.team[i]["designation"],
            "https://github.com/" + this.team[i]["github"],
            "https://www.linkedin.com/in/" + this.team[i]["linkedin"],
            "assets/" + this.team[i]["img"],
            this.team[i]["quote"],
            this.team[i]["quoteHeight"],
            ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: this.teamList,
          ),
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final designation;
  final github;
  final name;
  final linkedin;
  final img;
  final url;
  final quote;
  final quoteHeight;
  TeamCard(
    this.name,
    this.designation,
    this.github,
    this.linkedin,
    this.img,
    this.quote,
    this.quoteHeight,
    this.url,
  );
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Card(
        elevation: 2,
        color: _theme.cardColor,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: _theme.colorScheme.primary,
                  style: BorderStyle.solid,
                ),
                image: DecorationImage(
                  image: AssetImage(this.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 175,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.name,
                      style: TextStyle(
                        color: _theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      this.designation,
                      style: TextStyle(
                        color: _theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL(this.github);
                              },
                              child: Icon(
                                FontAwesomeIcons.github,
                                color: _theme.colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL(this.linkedin);
                              },
                              child: Icon(
                                FontAwesomeIcons.linkedin,
                                color: _theme.colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Icon(
                            FontAwesomeIcons.quoteLeft,
                            size: 14,
                            color: _theme.colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          width: 178,
                          child: Text(
                            this.quote,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _theme.colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: this.quoteHeight,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                FontAwesomeIcons.quoteRight,
                                size: 14,
                                color: _theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
