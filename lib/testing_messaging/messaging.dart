import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/screens/home/home.dart';
import '../AllNew/shared/constants.dart';
import 'ViewAllTeachersMessages.dart';
import 'ViewAllTeachersTexts.dart';
import 'ViewMyTextsForEditing.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
User? user = FirebaseAuth.instance.currentUser;

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<Messaging> createState() => _MessagingState();
}

//also insert the singleTicker
class _MessagingState extends State<Messaging>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  //image zoom and return
  late TransformationController transformController;
  TapDownDetails? tapDownDetails;
  OverlayEntry? entry;

  String _deviceToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> _documents = [];

  //subscribe all to get notified
  String topic = "notifications";

  String defaultImage =
      "data:image/png;base64,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";
  String selectedFileName = '';
  String selectedFilePath = '';

  bool hasNoImage = false;
  bool isLoading = false;

  late XFile file;
  var imageUrl = "";

  String nameOfTeacher = "";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserData();
    _getDeviceToken();
    _configureFirebaseListeners();
    logger.i("This is the name of the topic: $topic");
    _loadSwitchState();

    //animation
    transformController = TransformationController();
  }

  @override
  void dispose() {
    _subscription.cancel();
    transformController.dispose();
    super.dispose();
  }

  Future<void> _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      setOn = prefs.getBool('my_switch_state') ?? false;
    });
  }

  Future<void> _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('my_switch_state', value);
  }

  //get the token of the device
  void _getDeviceToken() async {
    _deviceToken = (await _firebaseMessaging.getToken())!;
    if (_deviceToken != null) {
      setState(() {
        _deviceToken = _deviceToken;
      });
      logger.i(_deviceToken);
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
    //FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("Handling foreground message: ${message.data}");
      }
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

  Future<void> _addDocument(String text, String teacherNameFromData) async {
    try {
      await FirebaseFirestore.instance.collection("messagesWithTextOnly").add({
        "text": text,
        "timestamp": FieldValue.serverTimestamp(),
        "nameOfTeacher": teacherNameFromData,
        "userID": user!.uid,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: Theme
          .of(context)
          .primaryColor);
    }
  }

  ///send to a topic
  Future<void> sendNotificationToTopic(String nameOfSender) async {
    const String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };

    Map<String, dynamic> body = {
      'notification': {
        'title': "From: $nameOfSender",
      },
      'priority': 'high',
      'to': '/topics/$topic}',
    };

    http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  bool setOn = true;
  bool imageExists = true;
  String? imageURLFromFirebase;

  void unSubscribeToTopicSwitch() async {
    logger.i("unSubscribe $topic");
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic).whenComplete(
          () => Fluttertoast.showToast(msg: "Unsubscribed"),
    );
  }

  void subscribeToTopicSwitch() async {
    logger.i("subscribe $topic");
    await FirebaseMessaging.instance.subscribeToTopic(topic).whenComplete(
          () => Fluttertoast.showToast(msg: "Subscribed"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .primaryColorDark,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ViewMyTextsForEditing(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Modify Texts",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .primaryColorDark,
                        ),
                      ),
                    ),
                    Switch(
                      value: setOn,
                      inactiveThumbColor:
                      Theme
                          .of(context)
                          .primaryColorLight
                          .withOpacity(.6),
                      activeColor: Theme
                          .of(context)
                          .primaryColor,
                      thumbIcon:
                      MaterialStateProperty.resolveWith((Set states) {
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
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Home()));
                      },
                      icon: Icon(Icons.home,
                          color:
                          Theme
                              .of(context)
                              .primaryColor
                              .withOpacity(.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  height: 40,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.4,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  color: Theme
                      .of(context)
                      .primaryColorLight
                      .withOpacity(.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                              const ViewAllTeachersMessages(),
                            ),
                          );
                        },
                        style: buttonRound,
                        child: Text(
                          "View Images",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
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
                          "View Texts",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        color: Theme
                            .of(context)
                            .primaryColor,
                      );
                    } else {
                      _documents = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: _documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = _documents[index];
                          imageURLFromFirebase =
                              (document.get("imageURL")).toString();
                          String text = document.get("text");
                          String name = document.get("nameOfTeacher");
                          String teacherID = document.get("userID");

                          var dateAndTime = document.get("timestamp");

                          return Dismissible(
                            key: Key(_documents[index].id),
                            onDismissed: (direction) {
                              try {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("messages")
                                      .doc(document.id)
                                      .delete();
                                });
                                snack("Notification deleted", context);
                              } on Exception catch (e) {
                                // TODO
                                snack(e.toString(), context);
                              }
                            },
                            background: Container(
                              color: Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(.6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.delete,
                                      color:
                                      Theme
                                          .of(context)
                                          .primaryColorLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Delete",
                                      style: textStyleText(context).copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Do you really want to dismiss this notification?",
                                      style: textStyleText(context),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          if (teacherID.toString() !=
                                              (user!.uid).toString()) {
                                            snack(
                                                "Can't delete a message for someone else",
                                                context);
                                            Navigator.of(context).pop(false);
                                          } else {
                                            Navigator.of(context).pop(true);
                                          }
                                        },
                                        child: Text(
                                          "Yes",
                                          style: textStyleText(context),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          "Cancel",
                                          style: textStyleText(context),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            movementDuration: const Duration(milliseconds: 500),
                            direction: DismissDirection.endToStart,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              color: Theme
                                  .of(context)
                                  .primaryColorLight
                                  .withOpacity(.3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        child: Text(
                                          name.toString()[0],
                                          style:
                                          textStyleText(context).copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme
                                                .of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: textStyleText(context)
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme
                                                      .of(context)
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
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor
                                                        .withOpacity(.7),
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: IconButton(
                                              onPressed: () async {},
                                              icon: Icon(
                                                Icons.circle,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor
                                                    .withOpacity(.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  //removed sizedBo with height=400
                                  buildImage(imageURLFromFirebase!),
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
        ),
      ),
      //TODO show BottomSheet
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: IconTheme
                  .of(context)
                  .color,
              onPressed: () {
                showSheetToEdit();
              },
              child: Icon(
                Icons.edit,
                color: Theme
                    .of(context)
                    .primaryColorLight,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: IconTheme
                  .of(context)
                  .color,
              onPressed: () {
                showSheetToEditWIthImage();
              },
              child: Icon(
                Icons.camera,
                color: Theme
                    .of(context)
                    .primaryColorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //TODO show selection
  showSelectionForImage() {
    showModalBottomSheet(
      context: context,
      barrierColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(.1),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(00),
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          child: Container(
            color: Theme
                .of(context)
                .primaryColorLight,
            child: Wrap(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _selectFile(false);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    _selectFile(true);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///////////////TODO show image edit sheet////////////////////
  showSheetToEditWIthImage() {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      elevation: 1,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            // topLeft: Radius.circular(50),
            // topRight: Radius.circular(50),
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              //color: Theme.of(context).primaryColorLight,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.only(top: 0.0),
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0x0fffffff), Color(0xE7791971)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 20,
                        child: Text(
                          "Drag Down",
                          style: textStyleText(context).copyWith(fontSize: 12),
                        )),
                    SingleChildScrollView(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedFileName.isEmpty;
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: buttonRound,
                                child: Text(
                                  "Discard",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .primaryColorDark,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    selectedFileName.isEmpty;
                                  });
                                  showSheetToEdit();
                                },
                                style: buttonRound,
                                child: Text(
                                  "Toggle",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .primaryColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                                child: Container(
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Whats on your mind? Image",
                                      style: textStyleText(context).copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Apple SD Gothic Neo',
                                          color: Theme
                                              .of(context)
                                              .primaryColorLight),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: selectedFileName.isEmpty
                                      ? Column(
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        size: 100,
                                      ),
                                      Center(
                                        child: Text(
                                            "Upload an image first",
                                            textAlign: TextAlign.center,
                                            style: textStyleText(context)
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    ],
                                  )
                                      : Center(
                                    child: Image.file(File(file.path),
                                        height: 320,
                                        width: 320,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: TextFormField(
                                  maxLength: 50,
                                  controller: _controller,
                                  maxLines: 1,
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "Caption",
                                    hintStyle: textStyleText(context).copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Theme
                                          .of(context)
                                          .primaryColor
                                          .withOpacity(.7),
                                    ),
                                  ),
                                  style: textStyleText(context),
                                  textAlign: TextAlign.center,
                                  autocorrect: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  onSaved: (value) {
                                    //Do something with the user input.
                                    setState(() {
                                      _controller.text = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          await showSelectionForImage();
                                        },
                                        style: buttonRound,
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme
                                                .of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        //upload
                                        try {
                                          if ((_controller.text).isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Insert image and Text",
                                                backgroundColor:
                                                Theme
                                                    .of(context)
                                                    .primaryColor);
                                          } else {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            //add an image
                                            await _uploadFile();
                                            //upload data
                                            await _addDocumentWithImage(
                                                _controller.text,
                                                imageUrl,
                                                nameOfTeacher)
                                                .then(
                                                  (value) =>
                                                  snack("Sent", context),
                                            )
                                                .then(
                                                  (value) =>
                                                  sendNotificationToTopic(
                                                      nameOfTeacher),
                                            )
                                                .whenComplete(
                                                  () =>
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                          const Messaging())),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        } catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                        }
                                        _controller.clear();
                                        setState(() {
                                          selectedFileName.isEmpty;
                                        });
                                      },
                                      style: buttonRound,
                                      child: isLoading
                                          ? SpinKitChasingDots(
                                        color: Theme
                                            .of(context)
                                            .primaryColorLight,
                                      )
                                          : Text(
                                        "Send",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Theme
                                              .of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // removeOverlay(){
  //   entry?.remove();
  //   entry == null;
  // }
  // //show Overlay
  // void showOverlay(BuildContext context){
  //   final renderBox = context.findRenderObject()! as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   entry = OverlayEntry(
  //       builder: (context){
  //         return Positioned(
  //           left: offset.dx,
  //           top: offset.dy,
  //           width: MediaQuery.of(context).size.width,
  //             child: buildImage());
  //       });
  //   final overlay = Overlay.of(context);
  //   overlay.insert(entry!);
  // }

  Widget buildImage(String imageURL) {
    return Builder(builder: (context) {
      return AspectRatio(
        aspectRatio: 4/3,
        child: InstaImageViewer(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(.4),
          child: Image(
            image: Image.network(
                imageURL)
                .image,
            loadingBuilder: (context, child, progress) =>
            progress == null
                ? child
                : const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  _selectFile(bool imageFrom) async {
    // file variable stores the image from cam or gallery
    file = (await ImagePicker().pickImage(
        source: imageFrom ? ImageSource.gallery : ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
    ))!;

    if (file != null) {
      setState(() {
        selectedFileName = file.name;
      });
      logger.i(file.name);
    }
  }

  Future<void> _addDocumentWithImage(String text,
      String urlLink,
      String teacherNameFromData,) async {
    logger.i("add to document $urlLink");
    try {
      await FirebaseFirestore.instance
          .collection("messages")
          .add({
        "text": text,
        "timestamp": FieldValue.serverTimestamp(),
        "imageURL": urlLink,
        "nameOfTeacher": teacherNameFromData,
        "userID": user!.uid,
      })
          .then(
            (value) => Fluttertoast.showToast(msg: "Data sent"),
      )
          .whenComplete(() => Navigator.of(context).pop());
    } on Exception catch (e) {
      // TODO
      logger.i(e);
    }
  }

  //upload file in database storage
  _uploadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/' + file.name);

      //convert the part to file ==> parameter cant be string
      uploadTask = ref.putFile(
        File(file.path),
      );

      await uploadTask.whenComplete(
            () => logger.i("Upload done"),
      );
      String imageUrlLocal = await ref.getDownloadURL();

      setState(() {
        imageUrl = imageUrlLocal;
      });
    } catch (e) {
      logger.i(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //TODO Show text edit sheet
  showSheetToEdit() {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      enableDrag: true,
      elevation: 1,
      context: context,
      builder: (context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Container(
              //color: Theme.of(context).primaryColorLight,
              // height: MediaQuery.of(context).size.height / 1.2,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.only(top: 0.0),
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0x0fffffff), Color(0xE7791971)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedFileName.isEmpty;
                              _controller.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          style: buttonRound,
                          child: Text(
                            "Discard",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedFileName.isEmpty;
                              _controller.clear();
                            });
                            Navigator.of(context).pop();
                            showSheetToEditWIthImage();
                          },
                          style: buttonRound,
                          child: Text(
                            "Toggle",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          child: Container(
                            color:
                            Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(.7),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Whats on your mind?",
                                style: textStyleText(context).copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Apple SD Gothic Neo',
                                    color: Theme
                                        .of(context)
                                        .primaryColorLight),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: TextFormField(
                            controller: _controller,
                            maxLines: 5,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Message",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme
                                    .of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              setState(() {
                                _controller.text = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  try {
                                    if (_controller.text.isEmpty) {
                                      snack("Insert Text in the provided space",
                                          context);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await _addDocument(_controller.text,
                                          nameOfTeacher.toString())
                                          .then(
                                            (value) => snack("Sent", context),
                                      )
                                          .whenComplete(
                                            () =>
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const ViewMyTextsForEditing(),
                                              ),
                                            ),
                                      );
                                      sendNotificationToTopic(nameOfTeacher);

                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    _controller.clear();
                                  } on Exception catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    snack(e.toString(), context);
                                  }
                                },
                                style: buttonRound,
                                child: isLoading
                                    ? SpinKitChasingDots(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                )
                                    : Text(
                                  "Send",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .primaryColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentUserData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    //get data where data ID is equals to the current logged in user
    Query<Map<String, dynamic>> userQuery =
    firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        //get the subject of the teacher
        // get the name field or empty string if it doesn't exist
        setState(() {
          nameOfTeacher = data?['secondName'] ?? '';
        });
        //check if data exist and not empty
        logger.i("inside getField $nameOfTeacher");
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("Handling background message: $message");
}
