import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';

import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class LearnerViewAllMessages extends StatefulWidget {
  bool loading;

  LearnerViewAllMessages({Key? key, required this.loading}) : super(key: key);

  @override
  State<LearnerViewAllMessages> createState() => _LearnerViewAllMessagesState();
}

class _LearnerViewAllMessagesState extends State<LearnerViewAllMessages> {
  bool hasNoImage = false;

  bool isVisible = true;
  bool layoutIn = false;

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          widget.loading
              ? SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: 15,
                )
              : Visibility(
                  visible: isVisible,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Text(""),
                  )),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    decoration: const BoxDecoration(
                      //screen background color
                      gradient: LinearGradient(
                          colors: [Color(0x0fffffff), Color(0xE7791971)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.size <= 0) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      //screen background color
                      gradient: LinearGradient(
                          colors: [Color(0x0fffffff), Color(0xE7791971)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Center(
                      child: Text(
                        "No data sent yet.",
                        style: textStyleText(context).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
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
                    padding: const EdgeInsets.only(bottom: 80),
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
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Container(
                                      // margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0), //
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                                0.5), // Shadow color
                                            spreadRadius: 1, // Spread radius
                                            blurRadius: 80, // Blur radius
                                            offset: const Offset(1,
                                                2), // Offset in x and y directions
                                          ),
                                        ],
                                      ),
                                      // color: Colors.grey.shade100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  10.0), // Adjust the radius value as needed
                                              color: Colors.transparent,
                                            ),
                                            height: 320,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewImageLarge(
                                                          name: name,
                                                          image:
                                                              imageURLFromFirebase),
                                                ));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      imageURLFromFirebase,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Adjust the radius value as needed
                                                      color: Colors.transparent,
                                                    ),
                                                    height: 300,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.asset(
                                                        "assets/images/ic_launcher.png",
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: ExpansionTile(
                                              childrenPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 10),
                                              collapsedIconColor:
                                                  Theme.of(context)
                                                      .primaryColor,
                                              iconColor: Colors.green.shade900,
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Read More",
                                                    style: textStyleText(
                                                            context)
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                              maintainState: false,
                                              expandedCrossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  text,
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 2),
                                  color: Theme.of(context).primaryColorLight,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        child: Text(
                                          name.toString()[0],
                                          style:
                                              textStyleText(context).copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
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
                                      SizedBox(
                                        width: 40,
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
                                                    style:
                                                        textStyleText(context)
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
                                                    style:
                                                        textStyleText(context)
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
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
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
    );
  }

  Future<void> selectedItem(BuildContext context, item, imageUrl) async {
    switch (item) {
      case 0:
        try {
          setState(() {
            isVisible = false;
            widget.loading = true;
          });
          var albumName = "E-Board";
          await GallerySaver.saveImage(imageUrl, albumName: albumName).then(
              (value) => Fluttertoast.showToast(
                  backgroundColor: Colors.purple.shade500,
                  msg:
                      "Image saved to you gallery. The directory Pictures/E-board."));
        } catch (e) {
          Fluttertoast.showToast(
              backgroundColor: Colors.purple.shade500,
              msg: "Could not download the image");

          logger.e("$e could not download image");
          //snack(e.toString(), context);
        }
        setState(() {
          isVisible = false;
          widget.loading = false;
        });
        break;
      case 1:
        try {
          if (imageUrl.isEmpty || imageUrl == "") {
            print("cant share");
            snack('There`s no url link found', context);
          } else {
            print("can share $imageUrl");
            await FlutterShare.share(
                title: 'Image Link',
                text: "Here is a link for an image posted.\n",
                linkUrl: imageUrl);
          }
        } catch (e) {
          snack(e.toString(), context);
        }
        break;
    }
  }
}

class ViewImageLarge extends StatelessWidget {
  final String name;
  final String image;
  const ViewImageLarge({Key? key, required this.name, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Posted by $name",
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius value as needed
                  color: Colors.transparent,
                ),
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/ic_launcher.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
