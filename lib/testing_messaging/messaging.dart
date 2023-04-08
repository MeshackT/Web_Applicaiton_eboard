import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:levy/AllNew/screens/home/home.dart';
import 'package:levy/AllNew/shared/constants.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final TextEditingController _controller = TextEditingController();
  String _deviceToken = "";

  late StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> _documents = [];

  String topic = "notifications";

  @override
  void initState() {
    super.initState();
    _getDeviceToken();
    _configureFirebaseListeners();
    logger.i("This is the name of the topic: $topic $setOn");
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
    await prefs.setBool('my_switch_state', value);
  }

  // Future<void> saveData() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     setState(() {
  //       prefs.setBool('subscriptionValue', setOn);
  //     });
  //   } catch (e) {
  //     logger.i(e);
  //   }
  // }

  //subscribe to topic
  Future<void> subscribeToTopic() async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } on Exception catch (e) {
      snack(e.toString(), context);
    }
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

  Future<void> _addDocument(String text) async {
    await FirebaseFirestore.instance.collection("messages").add({
      "text": text,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendNotification() async {
    const String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };

    Map<String, dynamic> body = {
      'notification': {
        'title': _controller.text.toString(),
        'body': "Same device notification and not others",
      },
      'priority': 'high',
      'to': _deviceToken,
    };
    logger.i(body);

    http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  ///send to a topic
  Future<void> sendNotificationToTopic() async {
    const String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };

    Map<String, dynamic> body = {
      'notification': {
        'title': _controller.text,
        'body': 'testing easy approach',
      },
      'priority': 'high',
      'to': '/topics/$topic',
    };

    http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  bool setOn = false;

  void subscribeToTopicSwitch() async {
    logger.i(topic);
    if (setOn = true) {
      //true
      await FirebaseMessaging.instance
          .subscribeToTopic(topic)
          .then(
            (value) => Fluttertoast.showToast(
                msg: "Subscribed to receive notifications"),
          )
          .whenComplete(
            () => logger.i("subscribed"),
          );
    } else {
      //false
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(topic)
          .then(
            (value) => Fluttertoast.showToast(
                msg: "UnSubscribed receive notifications"),
          )
          .whenComplete(
            () => logger.i("unsubscribed"),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messaging"),
        actions: [
          Switch(
            value: setOn,
            inactiveThumbColor: Theme.of(context).primaryColorLight,
            activeColor: Theme.of(context).primaryColor.withOpacity(.6),
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
                setState(() {
                  setOn = val;
                });
                _saveSwitchState(val);
                subscribeToTopicSwitch();
              } on Exception catch (e) {
                snack(e.toString(), context);
                logger.i(e);
              }
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Home()));
            },
            icon: const Icon(Icons.ac_unit),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter a message",
              ),
            ),
          ),
          ElevatedButton(
            child: const Text("Add Message"),
            onPressed: () async {
              try {
                String text = _controller.text;
                await _addDocument(text).then(
                  (value) => snack("added Document", context),
                )
                    .whenComplete(
                      () =>
                          sendNotificationToTopic(),
                );

                _controller.clear();
              } on Exception catch (e) {
                snack(e.toString(), context);
              }
            },
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitChasingDots(
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  _documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: _documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = _documents[index];
                      String text = document.get("text");
                      return ListTile(
                        title: Text(text),
                        trailing: TextButton(
                          onPressed: (){
                            FirebaseFirestore.instance
                                .collection('messages')
                                .doc(document.id)
                                .delete();
                          },
                          child: Text("Delete", style: textStyleText(context),),
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
}

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("Handling background message: $message");

// extract notification data
  String title = message["notification"]["title"];
  String body = message["notification"]["body"];

// send local notification
// ... code to send local notification goes here ...
}
