import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';
import 'ViewAllTeachersTexts.dart';
import 'messaging.dart';

class ViewAllTeachersMessages extends StatefulWidget {
  const ViewAllTeachersMessages({Key? key}) : super(key: key);

  @override
  State<ViewAllTeachersMessages> createState() =>
      _ViewAllTeachersMessagesState();
}

class _ViewAllTeachersMessagesState extends State<ViewAllTeachersMessages> {
  bool isLoading = false;
  double? progress = null;
  String status = "NotDownloaded";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  } // late Uint8List _data;
  // final String _result = "";

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
                            builder: (context) => const Messaging(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ViewAllTeachersTexts(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Feed Texts",
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
                      .collection("messages")
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
                          var imageURLFromFirebase =
                              (document.get("imageURL")).toString();
                          String text = document.get("text");
                          String name = document.get("nameOfTeacher");

                          var dateAndTime = document.get("timestamp");

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            height: 500,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        name.toString()[0],
                                        style: textStyleText(context).copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  name,
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
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
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: PopupMenuButton<int>(
                                        color: Colors.white,
                                        elevation: 5.0,
                                        itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Row(
                                              children: [
                                                isLoading
                                                    ? SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: progress,
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.download,
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.7),
                                                      ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Download",
                                                  style: textStyleText(context)
                                                      .copyWith(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.share,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(.7),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Share",
                                                  style: textStyleText(context)
                                                      .copyWith(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (item) => selectedItem(
                                            context,
                                            item,
                                            imageURLFromFirebase),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Center(
                                    child: isLoading
                                        ? SpinKitChasingDots(
                                            key: ValueKey(document.id),
                                            size: 15,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Image.network(
                                      imageURLFromFirebase,
                                      loadingBuilder: (context, child, progress) => progress == null
                                          ? child
                                          :const SizedBox(
                                        height: 400,
                                        width: 400,
                                        child: Center(
                                          child: CircularProgressIndicator(),),
                                      ),
                                      height: 400,
                                      width: 400,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      key: ValueKey(document.id),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                      text,
                                      style: textStyleText(context),
                                    ),
                                  ),
                                ),
                              ],
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

  void _downloadButtonPressed(var imageURL) async {
    setState(() {
      progress = null;
    });
    final request = Request('GET', imageURL);
    final StreamedResponse response = await Client().send(request);

    final contentLength = response.contentLength;
    setState(() {
      progress = 0.01;
      status = "Download started";
    });

    List<int> bytes = [];

    final file = await _getFile(imageURL);

    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadLength = bytes.length;
        setState(() {
          progress = downloadLength.toDouble() / (contentLength ?? 1);
          status = "Progess ${((progress ?? 0) * 100).toStringAsFixed(2)} %";
        });
        logger.i("progress $progress");
      },
      onDone: () async {
        setState(() {
          progress = 1;
        });
        await file.writeAsBytes(bytes);
        debugPrint("download dinished");
      },
      onError: (e) {
        debugPrint(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename) async {
    final dir = await getTemporaryDirectory();
    return File("${dir.path}/$filename");
  }

  Future<void> selectedItem(
      BuildContext context, item, String imageURLFromFire) async {
    setState(() {
      isLoading = true;
    });
    switch (item) {
      case 0:
        try {
          //TODO https://youtu.be/FcVADQsqEYk
          await GallerySaver.saveImage(imageURLFromFire, albumName: "E-Board")
              .then(
            (value) =>
            snack("Image saved to Pictures/E-board/.", context),

          );
          setState(() {
            isLoading = false;
          });
          //_downloadButtonPressed(imageURLFromFire);
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          snack("Could not download the image. Check your internet connection.", context);
        }

        break;

      case 1:
        try {
          if (imageURLFromFire.isEmpty || imageURLFromFire == "") {
            print("cant share");
            snack('There`s no url link found', context);
          } else {
            await FlutterShare.share(
                title: 'Image Link', linkUrl: imageURLFromFire);
          }
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          snack("Could not download the image. Check your internet connection.", context);
        }

        break;
    }
  }
}
