import 'package:deepfake_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _visible = true, _flag = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');

    _initializeVideoPlayerFuture = _controller.initialize();
    _visible = false;
    _flag = false;
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: DeepfakeColors.background,
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      color: DeepfakeColors.cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  this._visible = !this._visible;
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: DeepfakeColors.primary,
                                            width: 3.0,
                                          )),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: FutureBuilder(
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: _controller
                                                    .value.aspectRatio,
                                                child: VideoPlayer(_controller),
                                              );
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      )),
                                    ),
                                  ),
                                  Visibility(
                                    visible: this._visible,
                                    child: Container(
                                      height: 180,
                                      child: Center(
                                          child: ButtonTheme(
                                              child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                      ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 4),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "What are we solving?",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Cyber Criminals are using Image processing tools and techniques for producing the variety of crimes, including Image Modification, Fabrication using Cheap & Deep Fake Videos/Image. Desired Solution: The solution should focus on help the Image/Video verifier/examiner find out and differentiate a fabricated Image/Video with an original one. Technology that can help address the issue: AI/ML techniques can be used.",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 14.0, bottom: 4),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Our Approach",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Our method is based on the observations that current DeepFake algorithm can only generate images of limited resolutions, which need to be further warped to match the original faces in the source video. Such transforms leave distinctive artifacts in the resulting DeepFake videos. Our method detects such artifacts by comparing the generated face areas and their surrounding regions with a dedicated Convolutional Neural Network (CNN) model. Along with detection of DeepFake images and video, we also propose a solution to detect DeepFake audio to discern between real and fake audio, the detector uses visual representations of audio clips called spectrograms. Which is later classified by another CNN model as real or fake.",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "The models are deployed on the flask-based web-app which consists of ReactJS (front end) interface. It is the most efficient and economical solution for implementing it. It works on the principle “Train once, use anywhere”. These models can also be extended in the future to be implemented as a API service for third party applications.",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "1. Tensorflow / Keras / OpenCV \n2. Python, Flask (Open Source Web Framework) \n3. Google Cloud Platform and/or Microsoft Azure \n4. ReactJS",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: DeepfakeColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/classify');
                    },
                    child: const Text('START CLASSIFYING',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
