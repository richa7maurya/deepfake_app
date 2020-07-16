import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:deepfake_app/globals.dart';
import 'package:dio/dio.dart';
import '../colors.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;
  File file;
  bool isVideo;
  bool isAPICalled;

  @override
  void initState() {
    super.initState();
    this.isAPICalled = false;
  }

  _pickVideo() async {
    final file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'jpg', 'png', 'mp4'],
    );

    if (file != null) {
      if (file.path.split(".")[1] == "mp4") {
        _videoPlayerController = VideoPlayerController.file(File(file.path));

        chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: DeepfakeColors.primary,
          ),
        );
        this.isVideo = true;
      } else {
        this.isVideo = false;
      }
      setState(() {
        this.file = file;
      });
    }
  }

  _sendToClassify() async {
    this.setState(() {
      this.isAPICalled = true;
    });
    FileStat stats = file.statSync();
    String text;
    var response;
    Dio dio = new Dio();

    if (stats.size < MaxFileSizeinMB * 1024 * 1024) {
      FormData formData = new FormData();
      formData.fields.add(MapEntry("userId", "5f0ec570dc8e2b3f885b2bd6"));
      formData.files
          .add(MapEntry("video", await MultipartFile.fromFile(file.path)));

      Options options = new Options(
          contentType: "form-data",
          headers: {'Authorization': 'Bearer ' + BearerToken});

      response = await dio.post(ServerUrl + "/classify",
          data: formData, options: options);

      print("-------------------------");
      print(response.statusCode);
      print(response);
      print("-------------------------");

      if (response.statusCode == 200) {
        text =
            "Your video has been sent for classification. You'll see the results in your History.";
      } else if (response.statusCode == 412 || response.statusCode == 413) {
        text = "Max permissible file size/video length exceeded!";
      } else if (response.statusCode == 400) {
        text = "Unexpected issue with file";
      } else if (response.statusCode == 422) {
        text = "No video codec found";
      } else if (response.statusCode == 429) {
        text = "Too many videos sent for classification within short duration";
      } else {
        text = "Unknown error occured. Try again later!";
      }
    } else {
      text = "Max permissible file size/video length exceeded!";
    }
    this.setState(() {
      this.isAPICalled = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: isDark ? Colors.black : Colors.white,
          content: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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
          this.file == null
              ? Text(
                  'Hi! You can begin classifying videos or photos by tapping the UPLOAD button below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: this.isVideo
                        ? Chewie(controller: chewieController)
                        : Image.file(file),
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
          (this.isAPICalled == false)
              ? RaisedButton(
                  color: DeepfakeColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: this.file == null ? _pickVideo : _sendToClassify,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      this.file == null ? 'UPLOAD' : 'CLASSIFY',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }
}
