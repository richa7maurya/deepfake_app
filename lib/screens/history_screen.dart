import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/components/video_item.dart';
import 'package:deepfake_app/globals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:deepfake_app/components/image_item.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var temp = 0;
  Dio dio = new Dio();
  bool isAPICalled = false;
  List<Map<String, String>> videos = [];
  List<Map<String, String>> images = [];

  List<Widget> historyList = [];

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
      this.videos.add({
        "type": "video",
        "fileName": videos[i]["fileName"],
        "_id": videos[i]["_id"],
        "status": videos[i]["status"],
        "createdAt": videos[i]["createdAt"]
      });
    }

    List<dynamic> images = response.data["idata"];
    for (int i = 0; i < images.length; i++) {
      this.images.add({
        "type": "image",
        "fileName": images[i]["fileName"],
        "_id": images[i]["_id"],
        "status": images[i]["status"],
        "createdAt": images[i]["createdAt"]
      });
    }

    List<Map<String, String>> history = [];
    history = this.videos;
    history.addAll(this.images);
    history.sort((a, b) {
      return DateTime.parse(b["createdAt"])
          .difference(DateTime.parse(a["createdAt"]))
          .inMilliseconds;
    });

    this.setState(() {
      for (int i = 0; i < history.length; i++)
        this.historyList.add(
              Padding(
                key: Key(history[i]["_id"]),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.015),
                child: (history[i]["type"] == "video")
                    ? VideoItem(
                        this.afterDelete,
                        history[i]["fileName"],
                        history[i]["_id"],
                        history[i]["status"],
                        history[i]["createdAt"],
                      )
                    : ImageItem(
                        this.afterDelete,
                        history[i]["fileName"],
                        history[i]["_id"],
                        history[i]["status"],
                        history[i]["createdAt"],
                      ),
              ),
            );

      this.isAPICalled = true;
    });
  }

  afterDelete(String _id) {
    this.setState(() {
      this.historyList.removeWhere((element) => element.key == Key(_id));
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
