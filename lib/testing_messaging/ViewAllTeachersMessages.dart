import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';
import 'LearnerViewAllMessages.dart';
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
  double? progress;
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
            gradient: LinearGradient(
                colors: [Color(0x0fffffff), Color(0xE7791971)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 1.2,
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
                            "Back test",
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
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 20.0,
                              maxCrossAxisExtent: 320,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot document = _documents[index];
                              var imageURLFromFirebase =
                                  (document.get("imageURL")).toString();
                              String text = document.get("text");
                              String name = document.get("nameOfTeacher");

                              var dateAndTime = document.get("timestamp");

                              return Wrap(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5,
                                        top: 5,
                                        bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      // color: Theme.of(context).primaryColorLight,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        // Adjust the radius value as needed
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                      ),
                                                      height: 200,
                                                      width: 350,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewImageLarge(
                                                                    name: name,
                                                                    image:
                                                                        imageURLFromFirebase),
                                                          ));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                imageURLFromFirebase,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                // Adjust the radius value as needed
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              height: 100,
                                                              width: 100,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/ic_launcher.png",
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Divider(
                                                      height: 4,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      text,
                                                      style: textStyleText(
                                                              context)
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 2),
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        child: Text(
                                                          name.toString()[0],
                                                          style: textStyleText(
                                                                  context)
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      name,
                                                                      style: textStyleText(
                                                                              context)
                                                                          .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      Utils.formattedDate(
                                                                          dateAndTime),
                                                                      style: textStyleText(context).copyWith(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Theme.of(context).primaryColor.withOpacity(
                                                                              .7),
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                                  ),
                                ],
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
}
