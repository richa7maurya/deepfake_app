import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../colors.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  var state = 0;
  @override
  void initState() {
    super.initState();
    state = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(28.0),
        child: state == 0 ? UploadVideo(this) : ClassifyFile(this));
  }
}

class UploadVideo extends StatelessWidget {
  _ClassifyScreenState parent;
  UploadVideo(this.parent) {}

  @override
  Widget build(BuildContext context) {
    return Column(
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
            this.parent.setState(() {
              this.parent.state = 1;
            });
          },
          child: const Text('UPLOAD',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}

class ClassifyFile extends StatefulWidget {
  _ClassifyScreenState parent;
  ClassifyFile(this.parent);
  @override
  _ClassifyFilesState createState() => _ClassifyFilesState(this.parent);
}

class _ClassifyFilesState extends State<ClassifyFile> {
  _ClassifyScreenState parent;
  _ClassifyFilesState(this.parent) {}
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _visible = true, isAPICalled = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');

    _initializeVideoPlayerFuture = _controller.initialize();
    isAPICalled = false;
    _visible = true;
    _controller.setLooping(true);
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Your video has been sent for classification. Your will see the results in the history.',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                this.setState(() {
                  this.isAPICalled = !this.isAPICalled;
                  this.parent.setState(() {
                    this.parent.state = 0;
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
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
                        borderRadius: BorderRadius.circular(10.0),
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
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
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
            padding: const EdgeInsets.only(bottom: 50.0),
            child: RaisedButton(
              color: DeepfakeColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: () {
                this.setState(() {
                  this.isAPICalled = !this.isAPICalled;
                });
                this._showMyDialog();
              },
              child: const Text('CLASSIFY',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
