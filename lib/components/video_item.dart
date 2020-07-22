import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/globals.dart';
import 'package:deepfake_app/permissions.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

bool downloaderInitialized = false;

class VideoItem extends StatefulWidget {
  final String videoName;
  final videoId;
  final status;
  final date;
  final Function callback;

  VideoItem(
    this.callback,
    this.videoName,
    this.videoId,
    this.status,
    this.date,
  );

  static var httpClient = new HttpClient();

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _videoPlayerController;

  ChewieController chewieController;

  String videoFile = "";

  final Dio dio = new Dio();

  final PermissionsService service = new PermissionsService();

  final List<String> choices = <String>[
    "Generate PDF Report",
    "Delete Video",
    "Play Video"
  ];

  final icons = [
    FontAwesomeIcons.filePdf,
    FontAwesomeIcons.trash,
    FontAwesomeIcons.play,
  ];

  @override
  initState() {
    super.initState();
    initializeDateFormatting('en_IN', null);
    this.getVideoPath();
  }

  getVideoPath() async {
    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map<String, String> query = {
      "userId": userId,
      "videoId": this.widget.videoId
    };

    try {
      final response = await dio.get(
        serverURL + "/get-video",
        queryParameters: query,
        options: options,
      );
      videoFile = response.data["videoFile"];
    } on DioError catch (e) {
      if (e.response.statusCode != 200)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            ThemeChanger _themeChanger = Provider.of(context);
            ThemeData _theme = _themeChanger.getTheme();
            return AlertDialog(
              backgroundColor: _theme.colorScheme.surface,
              content: Text(
                'Oops! Something went wrong displaying your video',
                style: TextStyle(
                  color: _theme.colorScheme.onSurface,
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: _theme.colorScheme.onSurface,
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

  generatePDF() async {
    if (!downloaderInitialized) {
      await FlutterDownloader.initialize(debug: true)
          .catchError((err) => print(err));
      downloaderInitialized = true;
    }
    print("Generate PDF");
    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map<String, String> query = {
      "userId": userId,
      "videoId": this.widget.videoId
    };
    var res = await dio.get(serverURL + "/pdf",
        queryParameters: query, options: options);
    if (res.statusCode == 200) {
      await this.service.requestStoragePermission();
      await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS)
          .then((value) async {
        await FlutterDownloader.enqueue(
            url: serverURL + "/" + res.data["report"],
            savedDir: value,
            showNotification: true,
            openFileFromNotification: true,
            fileName: "Report-" +
                this.widget.videoName.split(".")[0] +
                "-" +
                res.data["report"]);
      });
    }
  }

  deleteVideo() async {
    print("Delete Video");
    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map<String, String> data = {
      "userId": userId,
      "videoId": this.widget.videoId
    };

    String text = "";
    try {
      final response = await dio.post(serverURL + '/remove/video',
          data: data, options: options);

      if (response.data["success"]) {
        text = "Deletion Successful";
      }
    } on DioError catch (e) {
      if (e.response.statusCode != 200)
        text = "Oops! Something went wrong. Could not delete video.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeChanger _themeChanger = Provider.of(context);
        ThemeData _theme = _themeChanger.getTheme();
        return AlertDialog(
          backgroundColor: _theme.colorScheme.surface,
          content: Text(
            text,
            style: TextStyle(
              color: _theme.colorScheme.onSurface,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  color: _theme.colorScheme.onSurface,
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
    this.widget.callback(this.widget.videoId);
  }

  downloadVideo() async {
    if (!downloaderInitialized) {
      await FlutterDownloader.initialize(debug: true)
          .catchError((err) => print(err));
      downloaderInitialized = true;
    }
    print("Download Image");

    await this.service.requestStoragePermission();
    await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_DOWNLOADS)
        .then((value) async {
      await FlutterDownloader.enqueue(
          url: serverURL + "/get-video/video?videoFile=${this.videoFile}",
          savedDir: value,
          showNotification: true,
          openFileFromNotification: true,
          fileName:
              "Classified-" + this.widget.videoName.split(".")[0] + ".mp4");
    });
  }

  @override
  dispose() {
    if (_videoPlayerController != null) _videoPlayerController.dispose();
    if (chewieController != null) chewieController.dispose();
    super.dispose();
  }

  playVideo() {
    print("Play video");
    print(Localizations.localeOf(context).languageCode +
        '_' +
        Localizations.localeOf(context).countryCode);

    _videoPlayerController = VideoPlayerController.network(
        serverURL + '/get-video/video?videoFile=' + videoFile);

    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: DeepfakeTheme.darkTheme.primaryColor,
      ),
    );

    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        ThemeChanger _themeChanger = Provider.of(context);
        ThemeData _theme = _themeChanger.getTheme();
        return Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.03,
          ),
          color: _theme.cardColor,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _theme.colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Center(
                      child: Chewie(
                        controller: chewieController,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 0,
                      child: FlatButton(
                        onPressed: this.downloadVideo,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _theme.colorScheme.primary),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(FontAwesomeIcons.arrowDown,
                                  color: Colors.white),
                            )),
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Text(
                  'File name - ' + this.widget.videoName,
                  style: TextStyle(
                    fontSize: 20,
                    color: _theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Text(
                  'Status - ' + this.widget.status,
                  style: TextStyle(
                    fontSize: 20,
                    color: _theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Text(
                  'Date - ' +
                      new DateFormat.yMd(
                        'en_IN',
                      ).add_jm().format(
                            DateTime.parse(this.widget.date),
                          ),
                  style: TextStyle(
                    fontSize: 20,
                    color: _theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.045),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  this.widget.videoName,
                  style: TextStyle(
                    color: _theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "0")
                  this.generatePDF();
                else if (value == "1")
                  this.deleteVideo();
                else if (value == "2") this.playVideo();
              },
              icon: Icon(
                Icons.more_vert,
                color: _theme.colorScheme.onSurface,
              ),
              color: _theme.colorScheme.surface,
              itemBuilder: (BuildContext context) {
                return choices.map(
                  (String choice) {
                    int n = choices.indexOf(choice);
                    return PopupMenuItem<String>(
                      value: n.toString(),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(
                              icons[n],
                              color: _theme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                          Text(
                            choice,
                            style: TextStyle(
                              color: _theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList();
              },
            )
          ],
        ),
      ),
    );
  }
}
