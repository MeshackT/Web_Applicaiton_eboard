import 'dart:io';
import 'dart:typed_data';

import 'package:Eboard/AllNew/screens/home/home.dart';
import 'package:Eboard/AllNew/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

User user = FirebaseAuth.instance.currentUser!;

class LearnerViewPrivateDocuments extends StatefulWidget {
  const LearnerViewPrivateDocuments({Key? key}) : super(key: key);

  @override
  State<LearnerViewPrivateDocuments> createState() =>
      _LearnerViewPrivateDocuments();
}

class _LearnerViewPrivateDocuments extends State<LearnerViewPrivateDocuments> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  String searchText = '';
  List<DocumentSnapshot> _documents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subject Private documents",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 0.0),
          decoration: const BoxDecoration(
            //screen background color
            gradient: LinearGradient(
                colors: [Color(0x0fffffff), Color(0xE7791971)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? SpinKitChasingDots(
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          )
                        : SizedBox(
                            width: 280,
                            child: TextField(
                              controller: _searchController,
                              cursorColor: Theme.of(context).primaryColorDark,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  left: 15,
                                  bottom: 11,
                                  top: 11,
                                  right: 15,
                                ),
                                hintText: "Enter a name",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                                prefixIcon: const Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("pdfs")
                      .where("publication", isEqualTo: "Private")
                      // .where("uid", isEqualTo: user.uid)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.size <= 0) {
                      return Center(
                        child: Text(
                          "No data sent yet.",
                          style: textStyleText(context).copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitChasingDots(
                        color: Theme.of(context).primaryColor,
                      );
                    } else {
                      var _documents = snapshot.data!.docs;
                      if (searchText.isNotEmpty) {
                        _documents = _documents.where((element) {
                          return element
                              .get('text')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
                      return ListView.builder(
                        itemCount: _documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = _documents[index];
                          String text = document.get("text");
                          String name = document.get("nameOfTeacher");
                          var dateAndTime = document.get("timestamp");
                          String fileUrl = document.get("fileUrl");

                          Timestamp timestamp = document.get("timestamp");
                          DateTime dateTime = timestamp.toDate();
                          // convert timestamp to DateTime
                          var formattedDateTime =
                              " ${dateTime.hour}:${dateTime.minute}";

                          return GestureDetector(
                            onTap: () {
                              print("this is the link $fileUrl");
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => View(url: fileUrl),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              text,
                                              style: textStyleText(context)
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Utils.formattedDate(
                                                      dateAndTime),
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(.7),
                                                          fontSize: 10),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  formattedDateTime,
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(.7),
                                                          fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                        height: 40,
                                        child: PopupMenuButton<int>(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          elevation: 5.0,
                                          itemBuilder: (context) => [
                                            PopupMenuItem<int>(
                                              value: 0,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.7),
                                                    size: 15,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Share PDF",
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.download,
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.7),
                                                    size: 15,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Download PDF",
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onSelected: (item) => selectedItem(
                                              context, item, name, fileUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Text(
                                      "By $name",
                                      style: textStyleText(context)
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO Show pop up button
  Future<void> selectedItem(BuildContext context, item, String nameOfSender,
      String fileUrlfile) async {
    switch (item) {
      case 0:
        try {
          ///share the pdf url
          if (fileUrlfile.isEmpty || fileUrlfile == "") {
            print("cant share");
            snack('There`s no url link found', context);
          } else {
            print("can share $fileUrlfile");
            await FlutterShare.share(
                title: "By $nameOfSender",
                text: fileUrlfile,
                chooserTitle: "By $nameOfSender");
          }
        } catch (e) {
          print(fileUrlfile);
          snack(e.toString(), context);
        }
        break;
      case 1:
        try {
          setState(() {
            isLoading = true;
          });
          const Duration(milliseconds: 1500);
          print("Started downloading");
          // Download the PDF file
          http.Response response = await http.get(Uri.parse(fileUrlfile));
          Uint8List pdfBytes = response.bodyBytes;

          // Get the external storage directory
          Directory? externalDir = await getExternalStorageDirectory();
          if (externalDir == null) {
            print('External storage directory not found');
            return;
          }

          // Create the e-board folder if it doesn't exist
          String folderPath = '${externalDir.path}/e-board';
          Directory folder = Directory(folderPath);
          if (!await folder.exists()) {
            await folder.create(recursive: true);
          }

          // Extract the file name from the URL
          String fileName = fileUrlfile.split('/').last;

          // Save the file to the e-board folder
          String filePath = '$folderPath/$fileName';
          File file = File(filePath);
          await file.writeAsBytes(pdfBytes);
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: 'File downloaded and saved successfully at: $filePath');
        } catch (e) {
          print(fileUrlfile);
          snack(e.toString(), context);
        }
        break;
    }
  }
}

Future openFile({required String url, String? fileName}) async {
  final file = await downloadFile(url, fileName!);

  if (file == null) {
    return;
  }
  print("Path: ${file.path}");

  openFile(url: file.path);
}

Future<File?> downloadFile(String url, String name) async {
  try {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(days: 0, milliseconds: 0, minutes: 0),
      ),
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  } on Exception catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

class View extends StatelessWidget {
  final PdfViewerController? pdfViewerController;
  final url;

  const View({Key? key, required this.url, this.pdfViewerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("URL Link SHows here: $url");
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
        content: Text(
          'Tap back again to leave the application',
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LearnerViewPrivateDocuments(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("View PDF"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              icon: Icon(
                Icons.home,
                size: 25,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 0.0),
          decoration: const BoxDecoration(
            //screen background color
            gradient: LinearGradient(
                colors: [Color(0x0fffffff), Color(0xE7791971)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: SfPdfViewer.network(
            url,
            controller: pdfViewerController,
          ),
        ),
      ),
    );
  }
}
