import 'package:Eboard/AllNew/screens/Notifications/local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class LearnerViewNotifications extends StatefulWidget {
  final String subject;

  const LearnerViewNotifications({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  State<LearnerViewNotifications> createState() =>
      _LearnerViewNotificationsState();
}

class _LearnerViewNotificationsState extends State<LearnerViewNotifications> {
  CollectionReference userFeeds =
      FirebaseFirestore.instance.collection('feeds');
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference feedCollection =
      FirebaseFirestore.instance.collection('feeds');

  String subjectOfTeacher = "";
  String teacherName = "";
  String teacherGrade = "";

  LocalNotificationService localNotificationService =
      LocalNotificationService();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _deviceToken = "";
  String topic = "";
  bool setOn = true;

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    setState(() {
      topic = subjectOfTeacher;
      subjectOfTeacher = widget.subject.toString();
      logger.i(
          "$teacherName this is the subject on notification $subjectOfTeacher notified? $setOn");
    });

    _getDeviceToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //get the token of the device
  void _getDeviceToken() async {
    _deviceToken = (await _firebaseMessaging.getToken())!;
    if (_deviceToken != null) {
      setState(() {
        _deviceToken = _deviceToken;
      });
      //logger.i(_deviceToken);
    } else {
      logger.i("Device token is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subject Private Notifications",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to close notifications',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0x00cccccc), Color(0xE7791971)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: feedCollection
                          .where('subject', isEqualTo: subjectOfTeacher)
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (ctx, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Waiting for Internet Connection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SpinKitChasingDots(
                                color: Theme.of(context).primaryColorDark,
                                size: 15,
                              ),
                            ],
                          ));
                        } else if (streamSnapshot.connectionState ==
                            ConnectionState.none) {
                          return Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Internet Connection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SpinKitChasingDots(
                                color: Theme.of(context).primaryColorDark,
                                size: 15,
                              ),
                            ],
                          ));
                        } else if (streamSnapshot.data!.size == 0) {
                          return Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ],
                          ));
                        }
                        var documents = streamSnapshot.data!.docs;
                        final List<QueryDocumentSnapshot> docs =
                            streamSnapshot.data!.docs;
                        return ListView.builder(
                          //reverse: true,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(parent: null),
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot document =
                                streamSnapshot.data!.docs[index];
                            Timestamp timestamp = document.get("time");

                            DateTime dateTime = timestamp.toDate();
                            // convert timestamp to DateTime
                            var formattedDateTime =
                                "${dateTime.month}/${dateTime.day}"
                                "/${dateTime.year} | ${dateTime.hour}"
                                ":${dateTime.minute}";

                            return Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  // height:
                                  //     MediaQuery.of(context).size.height / 3.3,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              documents[index].get("subject"),
                                              style: textStyleText(context)
                                                  .copyWith(
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formattedDateTime.toString(),
                                              style: textStyleText(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Name of Teacher",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Grade",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Title",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "About",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  documents[index].get("name"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  documents[index].get("grade"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SelectableText(
                                                  documents[index].get("title"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 10, right: 10),
                                        child: Divider(
                                          height: .5,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Wrap(
                                          children: [
                                            SelectableText(
                                              documents[index]
                                                  .get("description"),
                                              style: textStyleText(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
