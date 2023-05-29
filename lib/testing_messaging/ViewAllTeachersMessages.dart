import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
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
  bool isVisible = false;
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
                    isLoading
                        ? Visibility(
                            visible: isVisible,
                            child: SpinKitChasingDots(
                              color: Theme.of(context).primaryColor,
                              size: 15,
                            ),
                          )
                        : const Text(""),
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
                                    Flexible(
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
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        elevation: 5.0,
                                        itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Row(
                                              children: [
                                                Icon(
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
                                InstaImageViewer(
                                  child: CachedNetworkImage(
                                    imageUrl: imageURLFromFirebase,
                                    placeholder: (context, url) => SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: SpinKitChasingDots(
                                        color: Theme.of(context).primaryColor,
                                        size: 50,
                                      ),
                                    ),
                                    cacheManager: CacheManager(
                                      //this removes the image and re-downloads it after 7 days
                                      Config(
                                        'customCacheKey',
                                        stalePeriod: const Duration(days: 7),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 150,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    // imageBuilder: (context, imageProvider) => Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   height: 350,
                                    //   decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //       image: imageProvider,
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ),
                                    imageBuilder: (context, imageProvider) =>
                                        Center(
                                      child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Wrap(
                                    children: [
                                      SelectableText(
                                        text,
                                        style: textStyleText(context),
                                      ),
                                    ],
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

  Future<File> _getFile(String filename) async {
    final dir = await getTemporaryDirectory();
    return File("${dir.path}/$filename");
  }

  Future<void> selectedItem(
      BuildContext context, item, String imageURLFromFire) async {
    setState(() {
      isVisible = true;
      isLoading = true;
    });
    switch (item) {
      case 0:
        try {
          //TODO https://youtu.be/FcVADQsqEYk
          await GallerySaver.saveImage(imageURLFromFire, albumName: "E-Board")
              .then(
            (value) => Fluttertoast.showToast(
                backgroundColor: Colors.purple.shade500,
                msg: "Image saved to you gallery. Pictures/E-Board"),
          );
          setState(() {
            isLoading = false;
          });
          //_downloadButtonPressed(imageURLFromFire);
        } catch (e) {
          setState(() {
            isVisible = true;
            isLoading = false;
          });
          Fluttertoast.showToast(
              backgroundColor: Colors.purple.shade500,
              msg: "Image can't be save. ${e.toString()}");
        }

        break;

      case 1:
        try {
          if (imageURLFromFire.isEmpty || imageURLFromFire == "") {
            Fluttertoast.showToast(
                backgroundColor: Colors.purple.shade500,
                msg: "There's no URL link found");
          } else {
            await FlutterShare.share(
                title: 'Image Link', linkUrl: imageURLFromFire);
          }
        } catch (e) {
          snack("Could not download the image. Check your internet connection.",
              context);
        }

        break;
    }
  }
}
