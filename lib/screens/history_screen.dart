import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/components/video_item.dart';
import 'package:deepfake_app/globals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var temp = 0;
  Dio dio = new Dio();
  bool isAPICalled = false;
  List<String> videoNames = <String>[];
  List<String> dates = <String>[];
  List<String> statuses = <String>[];
  List<String> videoId = <String>[];
  List<Widget> historyList = [];
  List<VideoItem> array;

  initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
  }

  @override
  void initState() {
    super.initState();
    this.getHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getHistory() async {
    Options options = new Options(
        contentType: "application/x-www-form-urlencoded",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map data = {"userId": userId};
    var response = await dio.post(serverURL + "/fetch-history",
        data: data, options: options);

    List<dynamic> videos = response.data["vdata"];
    for (int i = 0; i < videos.length; i++) {
      this.videoNames.add(videos[i]["fileName"]);
      this.videoId.add(videos[i]["_id"]);
      this.statuses.add(videos[i]["status"]);
      this.dates.add(videos[i]["createdAt"]);
    }

    this.setState(() {
      for (int i = 0; i < videoNames.length; i++)
        this.historyList.add(
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.015),
                child: VideoItem(
                  this.afterDelete,
                  this.videoNames.elementAt(i),
                  this.videoId.elementAt(i),
                  this.statuses.elementAt(i),
                  this.dates.elementAt(i),
                ),
              ),
            );
      this.isAPICalled = true;
    });
  }

  afterDelete() {
    setState(() {
      this.isAPICalled = false;
      this.historyList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: (this.historyList.length != 0)
            ? Column(children: this.historyList)
            : Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: (isAPICalled == false)
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            _theme.colorScheme.primary,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.smile,
                              color: _theme.colorScheme.onBackground,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                "Nothing to display here. Start Classifying",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _theme.colorScheme.onBackground,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
