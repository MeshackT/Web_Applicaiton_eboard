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
import 'package:yueway/testing_messaging/ViewAllTeachersMessages.dart';

import '../../AllNew/model/ConnectionChecker.dart';
import '../../AllNew/shared/constants.dart';
import '../ViewAllTeachersTexts.dart';
import '../messaging.dart';

class DesktopViewAllTeachersMessages extends StatefulWidget {
  const DesktopViewAllTeachersMessages({Key? key}) : super(key: key);

  @override
  State<DesktopViewAllTeachersMessages> createState() =>
      _DesktopViewAllTeachersMessagesState();
}

class _DesktopViewAllTeachersMessagesState
    extends State<DesktopViewAllTeachersMessages> {
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return const ViewAllTeachersMessages();
      } else {
        return Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 0.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0x0fffffff), Color(0xE7791971)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                                    builder: (context) =>
                                        const ViewAllTeachersTexts(),
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
                              return GridView.builder(
                                itemCount: _documents.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot document = _documents[index];
                                  var imageURLFromFirebase =
                                      (document.get("imageURL")).toString();
                                  String text = document.get("text");
                                  String name = document.get("nameOfTeacher");

                                  var dateAndTime = document.get("timestamp");

                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                      height: 600,
                                      width: 450,
                                      color: Colors.white,
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              InstaImageViewer(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      imageURLFromFirebase,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: SpinKitChasingDots(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 25,
                                                    ),
                                                  ),
                                                  cacheManager: CacheManager(
                                                    //this removes the image and re-downloads it after 7 days
                                                    Config(
                                                      'customCacheKey',
                                                      stalePeriod:
                                                          const Duration(
                                                              days: 120),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: SpinKitChasingDots(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 100,
                                                    ),
                                                  ),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Center(
                                                    child: Image(
                                                      height: 600,
                                                      width: 450,
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Theme.of(context)
                                                    .primaryColorLight
                                                    .withOpacity(.8),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  child: SelectableText(
                                                    text,
                                                    style: textStyleText(
                                                            context)
                                                        .copyWith(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontFamily:
                                                                'Hiragino Kaku Gothic ProN'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.white,
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  child: Text(
                                                    name.toString()[0],
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: textStyleText(
                                                                  context)
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          Utils.formattedDate(
                                                              dateAndTime),
                                                          style: textStyleText(
                                                                  context)
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          .7),
                                                                  fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
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
            ),
          ),
        );
      }
    });
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
