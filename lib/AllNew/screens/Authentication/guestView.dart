import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:yueway/AllNew/model/ConnectionChecker.dart';
import 'package:yueway/AllNew/screens/Authentication/Authenticate.dart';
import 'package:yueway/AllNew/screens/Authentication/DesktopAuthentication/DesktopGuests.dart';
import 'package:yueway/AllNew/shared/constants.dart';

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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          child: Text(
                                            "S",
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
                                                      "By The school",
                                                      style:
                                                          textStyleText(context)
                                                              .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
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
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    InstaImageViewer(
                                      child: CachedNetworkImage(
                                        imageUrl: imageURLFromFirebase,
                                        placeholder: (context, url) =>
                                            SpinKitChasingDots(
                                          color: Theme.of(context).primaryColor,
                                          size: 25,
                                        ),
                                        cacheManager: CacheManager(
                                          //this removes the image and re-downloads it after 7 days
                                          Config(
                                            'customCacheKey',
                                            stalePeriod:
                                                const Duration(days: 7),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            SizedBox(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: SpinKitChasingDots(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 100,
                                          ),
                                        ),
                                        imageBuilder:
                                            (context, imageProvider) => Center(
                                          child: Image(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: SelectableText(
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
      } else {
        return const DesktopGuestView();
      }
    });
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
