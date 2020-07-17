import 'dart:io';

import 'package:deepfake_app/colors.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:deepfake_app/globals.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:deepfake_app/permissions.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var temp = 0;
  Dio dio;
  bool isAPICalled = false;
  List<String> videoNames = <String>[];
  List<String> videoId = <String>[];
  List<Widget> historyList = [];
  List<VideoItem> array;

  _HistoryScreenState();

  initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
  }

  @override
  void initState() {
    // TODO: Call /fetchHistory
    this.initializeDownloader();
    super.initState();
    dio = new Dio();
    this.getHistory();
  }

  getHistory() async {
    Options options = new Options(
        contentType: "application/x-www-form-urlencoded",
        headers: {'Authorization': 'Bearer ' + BearerToken});

    Map data = {"userId": userId};
    var response = await dio.post(ServerUrl + "/fetch-history",
        data: data, options: options);

    List<dynamic> videos = response.data["vdata"];
    for (int i = 0; i < videos.length; i++) {
      this.videoNames.add(videos[i]["fileName"]);
      this.videoId.add(videos[i]["_id"]);
    }

    this.setState(() {
      for (int i = 0; i < videoNames.length; i++)
        this.historyList.add(
              VideoItem(
                this,
                this.videoNames.elementAt(i),
                this.videoId.elementAt(i),
              ),
            );
      this.isAPICalled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: (this.historyList.length != 0)
          ? Column(children: this.historyList)
          : Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: (isAPICalled == false)
                    ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            DeepfakeColors.primary),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.smile,
                            color: Colors.blueGrey,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Nothing to display here. Start Classifying",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    ));
  }
}

class VideoItem extends StatelessWidget {
  final String videoName;
  final videoId;
  final _HistoryScreenState parent;
  Dio dio;
  PermissionsService service;

  final List<String> choices = <String>[
    "Generate PDF Report",
    "Delete Video History",
    "Play Classified Video"
  ];
  final List<Icon> icons = <Icon>[
    Icon(
      FontAwesomeIcons.filePdf,
      color: isDark ? Colors.white : Colors.black,
      size: 20,
    ),
    Icon(
      FontAwesomeIcons.trash,
      color: isDark ? Colors.white : Colors.black,
      size: 20,
    ),
    Icon(
      FontAwesomeIcons.play,
      color: isDark ? Colors.white : Colors.black,
      size: 20,
    )
  ];

  VideoItem(this.parent, this.videoName, this.videoId) {
    service = new PermissionsService();
    dio = new Dio();
  }

  static var httpClient = new HttpClient();
  generatePDF() async {
    print("Generate PDF");
    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + BearerToken});

    Map<String, String> query = {"userId": userId, "videoId": this.videoId};
    var res = await dio.get(ServerUrl + "/pdf",
        queryParameters: query, options: options);
    if (res.statusCode == 200) {
      await this.service.requestStoragePermission();
      await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS)
          .then((value) async {
        await FlutterDownloader.enqueue(
            url: ServerUrl + "/" + res.data["report"],
            savedDir: value,
            showNotification: true,
            openFileFromNotification: true,
            fileName: "Report-" +
                this.videoName.split(".")[0] +
                "-" +
                res.data["report"]);
      });
    }
  }

  deleteVideo() {
    print("Delete Video");
    // TODO: Delete video api call goes here
  }

  playVideo() {
    print("Play video");
    // TODO: Play video api call goes here
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        decoration: BoxDecoration(
            color: isDark ? DeepfakeColors.cardBackground : Colors.black12),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Text(
                  this.videoName,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "0")
                    this.generatePDF();
                  else if (value == "1")
                    this.deleteVideo();
                  else if (value == "2") this.playVideo();
                },
                icon: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white : Colors.black,
                ),
                color: isDark ? Colors.black : Colors.white,
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
                              child: icons[n],
                            ),
                            Text(
                              choice,
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
