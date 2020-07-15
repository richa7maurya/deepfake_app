import 'package:deepfake_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var temp = 0;
  List<String> str = <String>[
    "Video Sample 1",
    "Video Sample 2",
    "Video Sample 3",
    "Video Sample 4",
    "Video Sample 5",
    "Video Sample 6",
    "Video Sample 7",
    "Video Sample 8",
    "Video Sample 9",
    "Video Sample 10",
    "Video Sample 11",
    "Video Sample 12"
  ];

  List<Widget> historyList = [];

  List<VideoItem> array;

  _HistoryScreenState();

  @override
  void initState() {
    // TODO: Call /fetchHistory
    super.initState();
    for (int i = 0; i < str.length; i++)
      this.historyList.add(
            VideoItem(
              this,
              str.elementAt(i),
              str.elementAt(i),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: this.historyList),
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String videoName;
  final videoId;
  final _HistoryScreenState parent;
  VideoItem(this.parent, this.videoName, this.videoId);

  static const List<String> choices = <String>[
    "Generate PDF Report",
    "Delete Video History",
    "Play Classified Video"
  ];

  static const List<Icon> icons = <Icon>[
    Icon(
      FontAwesomeIcons.filePdf,
      color: Colors.white,
      size: 20,
    ),
    Icon(
      FontAwesomeIcons.trash,
      color: Colors.white,
      size: 20,
    ),
    Icon(
      FontAwesomeIcons.play,
      color: Colors.white,
      size: 20,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        decoration: BoxDecoration(color: DeepfakeColors.cardBackground),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Text(
                  this.videoName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PopupMenuButton<String>(
                onSelected: (value) =>
                    print(value + " for Button " + this.videoId),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                color: Colors.black,
                itemBuilder: (BuildContext context) {
                  return choices.map(
                    (String choice) {
                      int n = choices.indexOf(choice);
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: icons[n],
                            ),
                            Text(
                              choice,
                              style: TextStyle(color: Colors.white),
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
