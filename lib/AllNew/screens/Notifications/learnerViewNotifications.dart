import 'dart:async';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../home/learnersHome.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class LearnerViewNotifications extends StatefulWidget {
  final String subject;

  const LearnerViewNotifications({Key? key,
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



  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _deviceToken = "";
  String topic = "";
  bool setOn = true;
  late StreamSubscription<QuerySnapshot> _subscription;


  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    setState(() {
      topic = subjectOfTeacher;
      subjectOfTeacher = widget.subject.toString();
      logger.i("$teacherName this is the subject on notification $subjectOfTeacher notified? $setOn");
    });

    _getDeviceToken();
    _configureFirebaseListeners();
    _loadSwitchState();
  }
  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }



  Future<void> _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      setOn = prefs.getBool('my_switch_state') ?? false;
    });
  }

  Future<void> _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      await prefs.setBool('my_switch_state', value);
    });
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

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);

    await FlutterLocalNotificationsPlugin()
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Handling foreground message: ${message.data}");
      String title = message.notification?.title ?? "New notification";
      String body = message.notification?.body ?? "";
      showNotification(title, body);
    });

    FirebaseMessaging.instance
        .getToken()
        .then((token) => print("Device token: $token"));

    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
  }


  ///send to a topic
  // Future<void> sendNotificationToTopic() async {
  //   const String serverToken =
  //       'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
  //   const String url = 'https://fcm.googleapis.com/fcm/send';
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=$serverToken',
  //   };
  //
  //   Map<String, dynamic> body = {
  //     'notification': {
  //       'title': "From: ${nameOfTeacher.toString()}",
  //       'body': 'Subject: ${_subject.text}\nAbout: ${_titleController.text}',
  //     },
  //     'priority': 'high',
  //     'to': '/topics/${_subject.text}',
  //   };
  //   logger.i("send notifications to this subscriptions ${_subject.text}");
  //
  //   http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: json.encode(body),
  //   );
  // }

  void unSubscribeToTopicSwitch() async {
    topic = widget.subject;

    logger.i("unsubscribed to $topic");

    try{
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic).whenComplete(() =>
          Fluttertoast.showToast(msg: "Unsubscribed to $topic"),
      );
    }catch(e){
      logger.i(e);
    }
  }
  void subscribeToTopicSwitch() async {
    topic = widget.subject;

    logger.i("subscribed to $topic");
    try{
      await FirebaseMessaging.instance.subscribeToTopic(topic).whenComplete(() =>
          Fluttertoast.showToast(msg: "Subscribed to $topic"),
      );
    }catch(e){
      logger.i(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: OutlinedButton(
                        style: buttonRound,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LearnerHome()));
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    Switch(
                      value: setOn,
                      inactiveThumbColor: Theme.of(context).primaryColorLight.withOpacity(.6),
                      activeColor: Theme.of(context).primaryColor,
                      thumbIcon: MaterialStateProperty.resolveWith((Set states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Icon(
                            Icons.close,
                            color: Colors.grey,
                          );
                        }
                        return null; // All other states will use the default thumbIcon.
                      }),
                      onChanged: (val) async {
                        // Update the value of setOn
                        try {
                          // Update the value of setOn
                          if (!val) {
                            subscribeToTopicSwitch();
                            logger.i(val);
                          } else {
                            unSubscribeToTopicSwitch();
                            logger.i(val);
                          }
                          _saveSwitchState(val);

                        } on Exception catch (e) {
                          snack(e.toString(), context);
                          logger.i(e);
                        }
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: feedCollection
                          .where('subject', isEqualTo: subjectOfTeacher)
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
                        }else if (streamSnapshot.data!.size == 0) {
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
                          physics: const NeverScrollableScrollPhysics(),
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
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
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
                                              style:
                                                  textStyleText(context).copyWith(
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
                                                  MainAxisAlignment.spaceBetween,
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
                                                  MainAxisAlignment.spaceBetween,
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
                                                Text(
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
                                      SizedBox(
                                        height: 75,
                                        width: MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              documents[index].get("description"),
                                              style: textStyleText(context),
                                            ),
                                          ),
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
