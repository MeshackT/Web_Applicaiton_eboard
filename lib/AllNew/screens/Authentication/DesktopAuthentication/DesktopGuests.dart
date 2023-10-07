import 'package:Eboard/AllNew/model/ConnectionChecker.dart';
import 'package:Eboard/AllNew/screens/Authentication/Authenticate.dart';
import 'package:Eboard/AllNew/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../guestView.dart';

User user = FirebaseAuth.instance.currentUser!;

class DesktopGuestView extends StatefulWidget {
  const DesktopGuestView({Key? key}) : super(key: key);

  @override
  State<DesktopGuestView> createState() => _DesktopGuestViewState();
}

class _DesktopGuestViewState extends State<DesktopGuestView> {
  bool isLoading = false;
  bool isVisible = false;
  double? progress = null;
  String status = "NotDownloaded";

  String emailAddress = '';
  String secondaryContact = '';
  String primaryContact = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return const GuestView();
      } else {
        return Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Recent Posts",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          fontFamily: 'Hiragino Kaku Gothic ProN'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                                crossAxisCount: 3,
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
                                    height: 400,
                                    width: 350,
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          InstaImageViewer(
                                            child: CachedNetworkImage(
                                              imageUrl: imageURLFromFirebase,
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
                                                      const Duration(days: 120),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: SpinKitChasingDots(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 100,
                                                ),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Center(
                                                child: Image(
                                                  height: 400,
                                                  width: 350,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                              child: SelectableText(
                                                text,
                                                style: textStyleText(context)
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
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  // final String _result = "";
  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getUserField();
  } // late Uint8List _data;

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
