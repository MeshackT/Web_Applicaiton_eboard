import 'dart:io';

import 'package:Eboard/AllNew/screens/home/home.dart';
import 'package:Eboard/AllNew/shared/constants.dart';
import 'package:Eboard/testing_messaging/ViewDocuments.dart';
import 'package:Eboard/testing_messaging/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

var user = FirebaseAuth.instance.currentUser!;

class DesktopViewDocuments extends StatefulWidget {
  const DesktopViewDocuments({Key? key}) : super(key: key);

  @override
  State<DesktopViewDocuments> createState() => _DesktopViewDocumentsState();
}

class _DesktopViewDocumentsState extends State<DesktopViewDocuments> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  String nameOfTeacher = "";
  String storeUserPosterUID = "";
  String urlLinkParsed = "";
  String textNameParsed = "";
  bool isLoadingDelete = false;
  bool webDisplay = false;
  PdfViewerController? pdfViewerController;

  String searchText = '';
  List<DocumentSnapshot> _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUserData();
  }

  @override
  void dispose() {
    pdfViewerController!.dispose();
    super.dispose();
  }

  Future<void> selectedItem(
      BuildContext context,
      item,
      String nameOfSender,
      String fileUrlfile,
      String documentIndexPdf,
      String userCurrentlyLogged) async {
    switch (item) {
      case 0:
        try {
          Logger logger = Logger(
              printer: PrettyPrinter(
            colors: true,
          ));
          logger.e("Testing");
          setState(() {
            isLoadingDelete = true;
          });
          if (userCurrentlyLogged == null &&
              userCurrentlyLogged != storeUserPosterUID) {
            logger.i("cant do this");
            snack('Can\'t delete the post as you are not the poster', context);
            setState(() {
              isLoadingDelete = false;
            });
          } else {
            logger.i("can delete");
            await FirebaseFirestore.instance
                .collection("pdfs")
                .doc(documentIndexPdf)
                .delete();
            setState(() {
              isLoadingDelete = false;
            });
          }
        } catch (e) {
          print(fileUrlfile);
          snack(e.toString(), context);
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return const ViewDocuments();
      } else {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Messaging(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).primaryColorLight),
            centerTitle: true,
            title: const Text(
              "View PDF",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 2),
            ),
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
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 0.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  gradient: const LinearGradient(
                      colors: [Color(0x0ffffffff), Color(0xE7791971)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.0,
                    )
                  ]),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColorLight,
                            // color: Theme.of(context).primaryColorLight,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 1.0,
                              )
                            ]),
                        height: MediaQuery.of(context).size.height,
                        width: 500,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextField(
                                        controller: _searchController,
                                        cursorColor:
                                            Theme.of(context).primaryColorDark,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                              color: Theme.of(context)
                                                  .primaryColorDark,
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
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("pdfs")
                                    //.where("publication", isEqualTo: "Public")
                                    .orderBy("timestamp", descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Column(
                                      children: [
                                        Text("Error: ${snapshot.error}"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SpinKitChasingDots(
                                          color: Theme.of(context).primaryColor,
                                          size: 17,
                                        ),
                                      ],
                                    ));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data!.size <= 0) {
                                    return Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "No data sent yet.",
                                            style:
                                                textStyleText(context).copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SpinKitChasingDots(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 17,
                                          ),
                                        ],
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot document =
                                            _documents[index];
                                        String text = document.get("text");
                                        String name =
                                            document.get("nameOfTeacher");
                                        var dateAndTime =
                                            document.get("timestamp");
                                        String fileUrl =
                                            document.get("fileUrl");
                                        Timestamp timestamp =
                                            document.get("timestamp");
                                        DateTime dateTime = timestamp.toDate();
                                        // convert timestamp to DateTime
                                        var formattedDateTime =
                                            " ${dateTime.hour}:${dateTime.minute}";

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              urlLinkParsed == "";
                                              setState(() {
                                                urlLinkParsed = fileUrl;
                                                textNameParsed = text;
                                              });

                                              print("${_documents.first}");
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(.3),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.picture_as_pdf,
                                                        size: 40,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              text,
                                                              style:
                                                                  textStyleText(
                                                                          context)
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  Utils.formattedDate(
                                                                      dateAndTime),
                                                                  style: textStyleText(context).copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              .7),
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  formattedDateTime,
                                                                  style: textStyleText(context).copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              .7),
                                                                      fontSize:
                                                                          10),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        height: 40,
                                                        child: PopupMenuButton<
                                                            int>(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          icon: Icon(
                                                            Icons.more_vert,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          elevation: 5.0,
                                                          itemBuilder:
                                                              (context) => [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            .7),
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "Delete PDF",
                                                                    style: textStyleText(
                                                                            context)
                                                                        .copyWith(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                          onSelected: (item) =>
                                                              selectedItem(
                                                                  context,
                                                                  item,
                                                                  name,
                                                                  fileUrl,
                                                                  document.id,
                                                                  storeUserPosterUID),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child: Text(
                                                      "By $name",
                                                      style:
                                                          textStyleText(context)
                                                              .copyWith(
                                                                  fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                  ),
                  Visibility(
                    visible: urlLinkParsed == "" ? true : false,
                    child: Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: urlLinkParsed == "" ? false : true,
                      child: View(url: urlLinkParsed, text: textNameParsed)),
                  // viewDocs(context, urlLinkParsed),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> _getCurrentUserData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    //get data where data ID is equals to the current logged in user
    var userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        //get the subject of the teacher
        // get the name field or empty string if it doesn't exist
        setState(() {
          nameOfTeacher = data['secondName'];
          storeUserPosterUID = data['uid'];
        });
        //check if data exist and not empty
        print("inside getField $nameOfTeacher");
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}

Future<void> downloadPDF(String fileUrl, BuildContext context) async {
  try {
    // Download the PDF file
    http.Response response = await http.get(Uri.parse(fileUrl));
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
    String fileName = fileUrl.split('/').last;

    // Save the file to the e-board folder
    String filePath = '$folderPath/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(pdfBytes).whenComplete(() => Navigator.of(context));

    Fluttertoast.showToast(
        msg: 'File downloaded and saved successfully at: $filePath');
  } catch (e) {
    // Handle any errors that occur during the download and saving process
    print('Error downloading file: $e');
    Fluttertoast.showToast(msg: e.toString());
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

Widget viewDocs(BuildContext context, var url) {
  PdfViewerController? pdfViewerController;

  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10),
            child: Text(
              "View your selected pdf",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          url != ""
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfPdfViewer.network(
                      url,
                      controller: pdfViewerController,
                      enableHyperlinkNavigation: true,
                      enableTextSelection: true,
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfPdfViewer.network(
                      "https://github.com/MeshackT/docs/blob/main/1696619748853.pdf",
                      controller: pdfViewerController,
                      enableHyperlinkNavigation: true,
                      enableTextSelection: true,
                    ),
                  ),
                )
        ],
      ),
    ),
  );
}

class View extends StatelessWidget {
  final PdfViewerController? pdfViewerController;
  final String? url;
  final String? text;

  const View(
      {Key? key,
      required this.url,
      this.pdfViewerController,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("URL Link SHows here: $url");

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            boxShadow: const [
              BoxShadow(
                blurRadius: 1.0,
              )
            ]),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: text != "" || text != null
                    ? Text(
                        text!,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      )
                    : Text(
                        "View document",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                      ),
              ),
              url != ""
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfPdfViewer.network(
                          url!,
                          controller: pdfViewerController,
                          enableHyperlinkNavigation: true,
                          enableTextSelection: true,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfPdfViewer.network(
                          "https://github.com/MeshackT/docs/blob/main/1696619748853.pdf",
                          controller: pdfViewerController,
                          enableHyperlinkNavigation: true,
                          enableTextSelection: true,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
