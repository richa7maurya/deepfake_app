import 'package:deepfake_app/blocs/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Function callback;

  const HomeScreen({Key key, this.callback}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'C8FO0P2a3dA',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 2,
                color: _theme.cardColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Center(
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor:
                                  _theme.colorScheme.primary,
                              progressColors: ProgressBarColors(
                                playedColor: _theme.colorScheme.primary,
                                handleColor: _theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _theme.colorScheme.primary,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'What are we solving?',
                              style: TextStyle(
                                color: _theme.colorScheme.onSurface,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: Text(
                              'Cyber Criminals are using Image processing tools and techniques for producing the variety of crimes including Image Modification,  Fabrication using Cheap & Deep Fake  Videos/Image. Desired Solution: The solution should focus on help the Image/Video verifier/examiner find out and differentiate a  fabricated Image/Video with an original one.  Technology that can help address the issue: AI/ML techniques can be used.',
                              style: TextStyle(
                                color: _theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                color: _theme.colorScheme.primary,
                onPressed: () => this.widget.callback(1),
                child: Text(
                  'Start Classifying',
                  style: TextStyle(
                    color: _theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
