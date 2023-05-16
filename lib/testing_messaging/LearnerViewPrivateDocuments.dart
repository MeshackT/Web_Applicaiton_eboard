import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:yueway/AllNew/screens/home/home.dart';
import 'package:yueway/AllNew/screens/home/learnersHome.dart';
import 'package:yueway/AllNew/shared/constants.dart';
import 'package:yueway/testing_messaging/LearnerViewDocument.dart';

User user = FirebaseAuth.instance.currentUser!;

class LearnerViewPrivateDocuments extends StatefulWidget {
  const LearnerViewPrivateDocuments({Key? key}) : super(key: key);

  @override
  State<LearnerViewPrivateDocuments> createState() => _LearnerViewPrivateDocuments();
}

class _LearnerViewPrivateDocuments extends State<LearnerViewPrivateDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LearnerHome(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
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
                                            // PopupMenuItem<int>(
                                            //   value: 1,
                                            //   child: Row(
                                            //     children: [
                                            //       Icon(
                                            //         Icons.download,
                                            //         color: Theme.of(context)
                                            //             .primaryColor
                                            //             .withOpacity(.7),
                                            //         size: 15,
                                            //       ),
                                            //       const SizedBox(
                                            //         width: 10,
                                            //       ),
                                            //       Text(
                                            //         "Download PDF",
                                            //         style:
                                            //         textStyleText(context)
                                            //             .copyWith(),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
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
  Future<void> selectedItem(
      BuildContext context, item, String nameOfSender, String fileUrlfile) async {
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
      // case 1:
      //   try {
      //     if (fileUrlfile.isEmpty || fileUrlfile == "") {
      //       print("cant share");
      //       snack('There`s no url link found', context);
      //     } else {
      //       print("can download $fileUrlfile");
      //       openFile(url: fileUrlfile);
      //
      //     }
      //   } catch (e) {
      //     print(fileUrlfile);
      //     snack(e.toString(), context);
      //   }
      //   break;
    }
  }
}

Future openFile({required String url, String? fileName}) async{
  final file = await downloadFile(url, fileName!);

  if(file == null){
    return;
  }
  print("Path: ${file.path}");

  openFile(url: file.path);
}
Future<File?> downloadFile(String url, String name) async{
  try {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(days: 0, milliseconds: 0,
            minutes: 0),
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
    return Scaffold(
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
          enableTextSelection: true,
          enableDocumentLinkAnnotation: true,
          enableHyperlinkNavigation: true,
          enableDoubleTapZooming: true,
          url,
          controller: pdfViewerController,
        ),
      ),
    );
  }
}
