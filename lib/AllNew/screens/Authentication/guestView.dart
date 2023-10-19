import 'package:Eboard/AllNew/model/ConnectionChecker.dart';
import 'package:Eboard/AllNew/screens/Authentication/Authenticate.dart';
import 'package:Eboard/AllNew/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../testing_messaging/LearnerViewAllMessages.dart';

User user = FirebaseAuth.instance.currentUser!;

class GuestView extends StatefulWidget {
  const GuestView({Key? key}) : super(key: key);

  @override
  State<GuestView> createState() => _GuestViewState();
}

class _GuestViewState extends State<GuestView> {
  bool isLoading = false;
  bool isVisible = false;
  double? progress = null;
  String status = "NotDownloaded";

  String emailAddress = '';
  String secondaryContact = '';
  String primaryContact = '';

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getUserField();
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
              Card(
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Authenticate(),
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
                          showCupertinoDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: Text(
                                "Contact us here",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                              content: Text(
                                "$primaryContact\n$secondaryContact\n$emailAddress",
                                style: textStyleText(context)
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          );
                        },
                        style: buttonRound,
                        child: Text(
                          "Enquiries",
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
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _documents.length,
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              color: Theme.of(context).primaryColorLight,
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
                                                    BorderRadius.circular(
                                                        10.0), //
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(
                                                            0.5), // Shadow color
                                                    spreadRadius:
                                                        1, // Spread radius
                                                    blurRadius:
                                                        80, // Blur radius
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Adjust the radius value as needed
                                                      color: Colors.transparent,
                                                    ),
                                                    height: 320,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
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
                                                                .circular(10.0),
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
                                                              (context, url) =>
                                                                  Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0), // Adjust the radius value as needed
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            height: 300,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/ic_launcher.jpg",
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
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: ExpansionTile(
                                                      childrenPadding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      collapsedIconColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      iconColor:
                                                          Colors.green.shade900,
                                                      title: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Read More",
                                                            style: textStyleText(
                                                                    context)
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ],
                                                      ),
                                                      maintainState: false,
                                                      expandedCrossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          text,
                                                          style: textStyleText(
                                                                  context)
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                          textAlign:
                                                              TextAlign.start,
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
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                child: Text(
                                                  name.toString()[0],
                                                  style: textStyleText(context)
                                                      .copyWith(
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
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
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

  Future<void> _getUserField() async {
    // Get the current user's ID
    //String? userId = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    var userQuery = firestore.collection('enquiryDetails');
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        // get the subject 1 field or empty string if it doesn't exist
        setState(() {
          emailAddress = data['emailForEnquiry'];
          // get the subject 2 field or empty string if it doesn't exist
          primaryContact = data['primaryContact'];
          // get the name field or empty string if it doesn't exist
          secondaryContact = data['secondaryContact'];
        });
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}
