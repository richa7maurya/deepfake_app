import 'dart:io';

import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/globals.dart';
import 'package:deepfake_app/permissions.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

bool downloaderInitialized = false;

class ImageItem extends StatefulWidget {
  final String imageName;
  final imageId;
  final status;
  final date;
  final Function callback;

  ImageItem(
      this.callback, this.imageName, this.imageId, this.status, this.date);

  static var httpClient = new HttpClient();

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  String imageFile = "";

  final Dio dio = new Dio();

  final PermissionsService service = new PermissionsService();

  final List<String> choices = <String>[
    "Generate PDF Report",
    "Delete Image",
    "Display Image"
  ];

  final icons = [
    FontAwesomeIcons.filePdf,
    FontAwesomeIcons.trash,
    FontAwesomeIcons.image,
  ];

  @override
  initState() {
    super.initState();
    print(DateTime.now().timeZoneOffset);
    this.getImagePath();
  }

  getImagePath() async {
    print("get image path");

    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map<String, String> query = {
      "userId": userId,
      "imageId": this.widget.imageId
    };
    var res = await dio.get(serverURL + "/get-image",
        queryParameters: query, options: options);

    if (res.statusCode == 200) {
      this.imageFile = res.data["imageFile"];
    }
  }

  generatePDF() async {
    if (!downloaderInitialized) {
      await FlutterDownloader.initialize(debug: true)
          .catchError((err) => print(err));
      downloaderInitialized = !downloaderInitialized;
    }
    print("Generate PDF");

    Options options = new Options(
        contentType: "application/json",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map<String, String> query = {
      "userId": userId,
      "imageId": this.widget.imageId
    };
    var res = await dio.get(serverURL + "/pdf-image",
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
                this.widget.imageName.split(".")[0] +
                "-" +
                res.data["report"]);
      });
    }
  }

  deleteImage() async {
    print("Delete Image");
    Options options = new Options(
        contentType: "application/x-www-form-urlencoded",
        headers: {'Authorization': 'Bearer ' + bearerToken});

    Map data = {"userId": userId, "imageId": this.widget.imageId};
    var response = await dio.post(serverURL + "/remove/image",
        data: data, options: options);

    String text = "";
    if (response.statusCode == 200) {
      text = "Deletion Successful";
    } else {
      text = "Oops! Something went wrong. Could not delete image.";
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
    this.widget.callback(this.widget.imageId);
  }

  downloadImage() async {
    if (!downloaderInitialized) {
      await FlutterDownloader.initialize(debug: true)
          .catchError((err) => print(err));
      downloaderInitialized = !downloaderInitialized;
    }
    print("Download Image");

    await this.service.requestStoragePermission();
    await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_DOWNLOADS)
        .then((value) async {
      await FlutterDownloader.enqueue(
          url: serverURL + "/get-image/image?imageFile=${this.imageFile}",
          savedDir: value,
          showNotification: true,
          openFileFromNotification: true,
          fileName:
              "Classified-" + this.widget.imageName.split(".")[0] + ".jpg");
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  displayImage() {
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
              (this.imageFile != "")
                  ? Stack(children: [
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
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            serverURL +
                                "/get-image/image?imageFile=${this.imageFile}",
                          ),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 0,
                          child: FlatButton(
                            onPressed: this.downloadImage,
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
                    ])
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No face(s) detected in the image.',
                            style: TextStyle(
                              fontSize: 20,
                              color: _theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Text(
                  'File name - ' + this.widget.imageName,
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
                        Localizations.localeOf(context).languageCode +
                            '_' +
                            Localizations.localeOf(context).countryCode,
                      ).add_jm().format(
                            DateTime.parse(this.widget.date).add(
                              DateTime.now().timeZoneOffset,
                            ),
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
                  this.widget.imageName,
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
                  this.deleteImage();
                else if (value == "2") this.displayImage();
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
