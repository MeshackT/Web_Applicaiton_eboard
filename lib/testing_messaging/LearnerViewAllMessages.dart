import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';
import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class LearnerViewAllMessages extends StatefulWidget {
  const LearnerViewAllMessages({Key? key}) : super(key: key);

  @override
  State<LearnerViewAllMessages> createState() => _LearnerViewAllMessagesState();
}

class _LearnerViewAllMessagesState extends State<LearnerViewAllMessages> {
  bool hasNoImage = false;
  bool isLoading = false;
  late Uint8List _data;
  late String _result = "";

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
          const SizedBox(
            height: 10,
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
                    itemCount: _documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = _documents[index];
                      var imageURLFromFirebase =
                          (document.get("imageURL")).toString();
                      String text = document.get("text");
                      String name = document.get("nameOfTeacher");

                      var dateAndTime = document.get("timestamp");

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          height: 500,
                          color:
                              Theme.of(context).primaryColorLight.withOpacity(.3),
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
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              name,
                                              style:
                                                  textStyleText(context).copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Text(
                                              Utils.formattedDate(dateAndTime),
                                              style: textStyleText(context)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(.7),
                                                      fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width /
                                            2.1,
                                      ),
                                    ],
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
                                          context, item, imageURLFromFirebase),
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
          var albumName = "E-Board";
          await GallerySaver.saveImage(imageUrl, albumName: albumName)
              .then((value) => Fluttertoast.showToast(
              backgroundColor: Colors.purple.shade500,
              msg:"Image saved to you gallery."));
        } catch (e) {
          logger.e("$e could not download image");
          //snack(e.toString(), context);
        }
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
                text: "Here is a link for an image posted.\n",linkUrl: imageUrl);
          }
        } catch (e) {
          snack(e.toString(), context);
        }
        break;
    }
  }
}
