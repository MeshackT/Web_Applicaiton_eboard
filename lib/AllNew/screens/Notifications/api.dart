import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmApi {
  static Logger logger = Logger(printer: PrettyPrinter(colors: true));

  String nameOfTeacher = "";
  String _userSubject = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _deviceToken = "";
  static String topic = "";
  bool setOn = true;


  static Future<bool> sendNotification(String title, String description) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL'
    };

    final body = jsonEncode({
      'to': '/topics/all',
      'notification': {
        'title': title,
        'body': description,
        'android_channel_id': 'easyapproach',
        'priority': 'high',
        'show_when': true,
        'icon': 'ic_notification',
        'sound': 'default',
      }
    });

    final response = await http.post(url, headers: headers, body: body);
    return response.statusCode == 200;
  }
  static Future<void> _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   setOn = prefs.getBool('my_switch_state') ?? false;
    // });
  }

  static Future<void> _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('my_switch_state', value);
  }

  //get the token of the device
  void _getDeviceToken() async {
    _deviceToken = (await _firebaseMessaging.getToken())!;
    if (_deviceToken != null) {
      // setState(() {
      //   _deviceToken = _deviceToken;
      // });
      logger.i(_deviceToken);
    } else {
      logger.i("Device token is null.");
    }
  }

  static Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);

    await FlutterLocalNotificationsPlugin()
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  static void _configureFirebaseListeners() {
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

  ///send to a topic
  static Future<void> sendNotificationToTopic() async {
    const String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };

    Map<String, dynamic> body = {
      'notification': {
        'title': "Hi",
        'body': 'CAT',
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

  static void unSubscribeToTopicSwitch() async {
    logger.i(topic);
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic).whenComplete(() =>
        Fluttertoast.showToast(msg: "Unsubscribed"),
    );
  }
  static void subscribeToTopicSwitch() async {
    logger.i(topic);
    await FirebaseMessaging.instance.subscribeToTopic(topic).whenComplete(() =>
        Fluttertoast.showToast(msg: "Subscribed"),
    );
  }
}
