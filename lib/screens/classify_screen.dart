import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../colors.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;
  PickedFile _video;
  @override
  void initState() {
    super.initState();
  }

  _pickVideo() async {
    final video = await _picker.getVideo(source: ImageSource.gallery);

    if (video != null) {
      _videoPlayerController = VideoPlayerController.file(File(video.path));

      chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: DeepfakeColors.primary,
        ),
      );

      setState(() {
        _video = video;
      });
    }
  }

  _sendToClassify() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Text(
            "Your video has been sent for classification. You'll see the results in your History.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.white,
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
    // TODO: Call /classify
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _video == null
              ? Text(
                  'Hi! You can begin classifying videos or photos by tapping the UPLOAD button below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Chewie(controller: chewieController),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: DeepfakeColors.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
          const SizedBox(height: 40),
          RaisedButton(
            color: DeepfakeColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: _video == null ? _pickVideo : _sendToClassify,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                _video == null ? 'UPLOAD' : 'CLASSIFY',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
