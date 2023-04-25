import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../gradeList/grade12.dart';
import '../home/home.dart';
import 'ViewNotification.dart';

User? user = FirebaseAuth.instance.currentUser;
Logger logger = Logger(printer: PrettyPrinter(colors: true));

//A Model to grab and store data
class UserFeeds {
  final String grade;
  final String uid;
  final String subject;
  final String name;
  final String documentID;
  final String description;
  final String title;
  final String date;

  UserFeeds(
    this.uid,
    this.grade,
    this.name,
    this.documentID,
    this.subject,
    this.description,
    this.title,
    this.date,
  );

  //collection reference
  final userFeeds = FirebaseFirestore.instance.collection('feeds').doc();

  //add the feed created to feed
  Future<void> addFeed() {
    //get document ID
    final documentID = userFeeds.id;
    //date
    Timestamp timeStamp = Timestamp.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);

    // Call the user's CollectionReference to add a new user
    return userFeeds
        .set({
          'documentID': documentID, //document auto generated
          'uid': user!.uid, // The teacherID
          'name': name, //name of teacher
          'subject': subject, // subject name
          'grade': grade, //grade
          'title': title, // subject title
          'description': description, // subject description
          'time': FieldValue.serverTimestamp(),
        })
        .then((value) => print("feed entered"))
        .catchError((error) => print("Failed to add feed: $error"));
  }
}
//=====================================================================

class SendNotification extends StatefulWidget {
  const SendNotification({Key? key}) : super(key: key);
  static const routeName = '/select';

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _grade = TextEditingController();
  final _subject = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String nameOfTeacher = "";
  String _userSubject = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription<QuerySnapshot> _subscription;

  String _deviceToken = "";
  String topic = "";
  bool setOn = true;
  bool isLoading = false;
  String newGrade = "";
  String newAbout = "";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getUserField();
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
  Future<void> sendNotificationToTopic(newGrade, newAbout) async {
    logger.i("new data $newGrade $newAbout");

    const String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };

    Map<String, dynamic> body = {
      'notification': {
        'title': "From: ${nameOfTeacher.toString()}",
        'body': 'Subject: ${_subject.text}\n'
            'Grade: ${newGrade.toString()}'
            '\nAbout: ${newAbout.toString()}',
      },
      'priority': 'high',
      'to': '/topics/${_subject.text}',
    };
    logger.i("send notifications to this subscriptions ${_subject.text}");

    http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  void unSubscribeToTopicSwitch() async {
    topic = _subject.text;

    logger.i("unsubscribed to $topic");

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic).whenComplete(
            () => Fluttertoast.showToast(msg: "Unsubscribed to $topic"),
          );
    } catch (e) {
      logger.i(e);
    }
  }

  void subscribeToTopicSwitch() async {
    topic = _subject.text;

    logger.i("subscribed to $topic");
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic).whenComplete(
            () => Fluttertoast.showToast(msg: "Subscribed to $topic"),
          );
    } catch (e) {
      logger.i(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   userSubject1 = _subject.text;
    // });
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              navigate(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text("Learner's notifications"),
          titleSpacing: 2,
          centerTitle: false,
          elevation: 0,
          actions: [
            Switch(
                value: setOn,
                inactiveThumbColor:
                    Theme.of(context).primaryColorLight.withOpacity(.6),
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
                  if (!val) {
                    subscribeToTopicSwitch();
                    logger.i(val);
                  } else {
                    unSubscribeToTopicSwitch();
                    logger.i(val);
                  }
                  _saveSwitchState(val);
                }),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorLight,
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.create,
                  color: Theme.of(context).primaryColorLight,
                  size: 15,
                ),
                text: "Create",
              ),
              Tab(
                icon: Icon(Icons.mark_chat_unread,
                    size: 15, color: Theme.of(context).primaryColorLight),
                text: "View",
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: false,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
            content: Text(
              'Tap back again to leave the application',
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              textAlign: TextAlign.center,
            ),
          ),
          child: TabBarView(
            children: [
              //Tabs/Terms
              buildPage("Create a Notification"),
              ViewNotifications(
                  subjectOfTeacherPassed: _userSubject.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(String title) {
    return SingleChildScrollView(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            title,
                            style: textStyleText(context)
                                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                   
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _titleController,
                            decoration: textInputDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: .8,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              label: Text(
                                'About',
                                style: textStyleText(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              hintText: "About message",
                              hintStyle: textStyleText(context),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Message about what?";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: textInputDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              label: Text(
                                "Your Message",
                                style: textStyleText(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your message here",
                              hintStyle: textStyleText(context),
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            autocorrect: true,
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter your message";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _subject,
                            decoration: textInputDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              label: Text(
                                "Your Subject",
                                style: textStyleText(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your subject here",
                              hintStyle: textStyleText(context),
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            autocorrect: true,
                            textAlign: TextAlign.center,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter your subject";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _grade,
                            decoration: textInputDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: .8,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: .8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              label: Text(
                                "Your Grade",
                                style: textStyleText(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your grade here",
                              hintStyle: textStyleText(context),
                            ),
                            keyboardType: TextInputType.number,
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            autocorrect: true,
                            textAlign: TextAlign.center,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter your grade";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              try {
                                String userLoggedIn = user!.uid;
                                String documentID = "";
                                String nameOfTeacherInput = nameOfTeacher;
                                String subjectOfTeacher = _subject.text;
                                String date = "";
                                logger
                                    .i("name of Teacher $nameOfTeacherInput and "
                                        "subject Name $_userSubject");

                                setState(() {
                                  isLoading =true;
                                  newGrade = _grade.text;
                                  newAbout = _titleController.text;
                                });
                                logger.i("$newGrade $newAbout");
                                if (_formKey.currentState!.validate()) {
                                  UserFeeds userFeeds = UserFeeds(
                                      userLoggedIn,
                                      _grade.text,
                                      nameOfTeacherInput.toString(),
                                      documentID,
                                      subjectOfTeacher,
                                      _descriptionController.text,
                                      _titleController.text,
                                      date);
                                  await userFeeds
                                      .addFeed()
                                      .then(
                                        (value) => sendNotificationToTopic(
                                            newGrade, newAbout),
                                      )
                                      .whenComplete(
                                        () => snack("Notification sent", context),
                                      );
                                  logger.i(
                                      "$nameOfTeacher ${_grade.text} ${_titleController.text}");

                                  _titleController.clear();
                                  _grade.clear();
                                  _descriptionController.clear();
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } on Exception catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                snack(e.toString(), context);
                              }
                            },
                            style: buttonRound,
                            child: isLoading?SpinKitChasingDots(
                              color: Theme.of(context).primaryColor,
                          ):Text(
                              "Send",
                              style: textStyleText(context).copyWith(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  //get the field required for the current logged in user

  Future<void> _getUserField() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        //get the subject of the teacher
        _userSubject = data?['subjects'][0] ?? '';
        // get the name field or empty string if it doesn't exist
        nameOfTeacher = data?['secondName'] ?? '';
        setState(() {
          _subject.text = _userSubject.toString();
          _userSubject = _userSubject.toString();
          nameOfTeacher = data?['secondName'] ?? '';
        });
        logger.i("inside getField ${_subject.text}");
        logger.i("inside getField $_userSubject");

        print(
            'News Feed User subject: $_userSubject User Name: $nameOfTeacher');
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}

//Navigate to the previous page
Future navigate(BuildContext context) {
  return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Grade12()));
}
