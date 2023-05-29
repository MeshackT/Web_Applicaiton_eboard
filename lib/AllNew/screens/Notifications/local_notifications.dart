import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

/*
* ------ FiRST STEP ------
* Create a class "Name it anything"
*
* import http
* import firebase_messaging
* import flutter_local_notifications
*
* ------ INSIDE THE CLASS ------
* GET THE INSTANCE OF FlutterLocalNotificationsPlugin
* GET THE INSTANCE OF FirebaseMessaging
*
**********************************************************************
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
*************************************************************************

*  ------ SECOND STEP ------
* CREATE A METHOD TO GET PERMISSION FOR NOTIFICATION
*
*  ------ FOURTH STEP ------
* CREATE A METHOD TO INITIALIZE THE SETTINGS
*
*  ------ FIFTH STEP ------
* CREATE A METHOD TO GET PERMISSION FOR NOTIFICATION
* showNotificationOnForeground
* GIVE THE CHANNEL A NAME COM.EXAMPLE.NOTIFICATIONS (ANYTHING UNIQUE)
* GIVE THE ID A NAME NOTIFICATIONS (ANYTHING UNIQUE)
*
*
*  ------ SIXTH STEP ------
* SEND A NOTIFICATION TO THE CURRENT DEVICE (CURRENT TOPIC/TOKEN)
*
* *  ------ SEVENTH STEP ------
* SEND A NOTIFICATION TO THE DEVICE (THE OTHER TOPIC/TOKEN)
*
*
* *  ------ EIGHTH STEP ------
* SEND A NOTIFICATION TO THE CURRENT DEVICE (CURRENT TOPIC/TOKEN)
*
* *  ------ NINTH STEP ------
* CREATE A VARIABLE THAT HAS A TOPIC NAME TO SEND NOTIFICATIONS

  * String sendTo = "receiveMessage"
* create a method to subscribe to the topic and the other to unSubscribe
*
** ------TENTH Step------
* Create a method to send the notification to those that are subscribed
*
* ****************************************************************************
* ****************************************************************************
*
* ON YOUR STATEFULWIDGET/HOMEPAGE
*
* initState(){}
* CALL   LocalNotificationService.initialize();

* CREATE FirebaseMessaging.instance.getInitialMessage()
*CREATE => onMessageOpenedApp, onMessage, onMessageOpenedApp
*
*
* ***********************************************************************************
* ON YOU MAIN, DO THIS
*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  logger.e(
      "Handling a background message: ${message.messageId} ${message.notification?.title} ${message.notification?.body}");
}

LocalNotificationService localNotificationService = LocalNotificationService();
FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
*
*
*
********************************* MAIN DONE ************************************************
*
*
*
* ON YOU HOME STILL, INSIDE UR BUTTON
* localNotificationService.sendNotification()
*
* CREATE A BUTTON TO SUBSCRIBE AND UNSUBSCRIBE
* ---YOU CAN INGNORE IF YOU DONT WANT SUBSCRIPTION
*TextButton(
              onPressed: () {
                localNotificationService.unSubscribeToTopicDevice();
              },
              child: Text("unSubscribe"),
            ),
*
* TextButton(
              onPressed: () {
                localNotificationService.sendNotification().then((value) =>
                logger.i("Notification sent"),
                );
              },
              child: Text("Send"),
            ),
*
*
*
*  ON YOU ANDROIDMENIFEST.XML
*
*INSIDE ACTIVITY TAGS --PASTE THESE LINES
*********** <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>

           *
            <meta-data
                android:name="com.google.firebase.messaging.default_notification_channel_id"
                android:value="testingnotifications" ==>(UNIQUE NAME i MENTIONED ABOVE)
             />
*
*com.example.levy

*
* */

class LocalNotificationService {
  //STEP 2
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //STEP 3
  //get permission
  Future<void> getPermission() async {
    await Permission.photos.request();
    await Permission.contacts.request();
    await Permission.storage.request();
    await Permission.notification.request();


    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.phone,
      Permission.storage,
      Permission.notification,
      //add more permission to request here.
    ].request();
    if (statuses[Permission.photos]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      print("Permission Denied");
    } else if (statuses[Permission.phone]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      print("Permission Denied");
    } else if (statuses[Permission.storage]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      print("Permission Denied");
    } else if (statuses[Permission.notification]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      print("Permission Denied");
    } else if (statuses[Permission.camera]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      print("Permission Denied");
    } else {
      //showToast("Permission Granted");
      print("Permission Granted");
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not yet granted permission');
    }

    // Foreground State show message
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(event);
      if (event != null) {
        final routeFromMessage = event.data["AllToSee"];
        print(
            "onMessage ${event.notification!.title} ${event.notification!.body}");
      }
    });

    // background State show message
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event != null) {
        final routeFromMessage = event.data["AllToSee"];
        print(
            "onMessageOpenApp ${event.notification!.title} ${event.notification!.body}");
      }
    });
  }

  //SET 4
  //sets the notification
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings);
  }

  //STEP 5
  //shows the notification on screen
  static void showNotificationOnForeground(RemoteMessage message) {
    const notificationDetail = NotificationDetails(
      android: AndroidNotificationDetails(
          "com.example.testingnotifications", //channelId
          "testingnotifications", //channel name
          importance: Importance.max,
          priority: Priority.high),
    );

    _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetail,
        payload: message.data["allToSee"]);
  }

//STEP 6
  ///Copied the token of the other device and sent the message
  // Future<void> sendNotification() async {
  //   String serverToken =
  //       'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
  //
  //   await _firebaseMessaging.requestPermission();
  //
  //   String? token = await _firebaseMessaging.getToken();
  //
  //   print("token $token");
  //
  //   await http.post(
  //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key=$serverToken',
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'title': 'Test Notification 1',
  //           'body': 'This is a test notification 1',
  //         },
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'id': '1',
  //           'status': 'done',
  //         },
  //         'to':
  //             "caoSNBOoQn6mvcyd001d1i:APA91bHt_R3dXQAlnXDa_VJcwdWdSGBn4uhHsVtFZ5eV2z-cc5PfU-2kGRC9CqaUxdIuai2YqJQof3MMzW0vW51w6eESw3TxSZSXTWCNRGQ8IejvoZYrXN97U3QV5TPEmPxYkXbCzumN",
  //       },
  //     ),
  //   );
  // }

  //STEP 7
  ///Sends notification to this phone that presses the button
  // Future<void> sendNotificationToCurrentPhone() async {
  //   String serverToken =
  //       'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';
  //
  //   await _firebaseMessaging.requestPermission();
  //
  //   String? token = await _firebaseMessaging.getToken();
  //
  //   print("token $token");
  //
  //   await http.post(
  //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key=$serverToken',
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'title': 'Test Notification 1',
  //           'body': 'This is a test notification 1',
  //         },
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'id': '1',
  //           'status': 'done'
  //         },
  //         'to': token,
  //       },
  //     ),
  //   );
  // }

  //EIGHT STEP
  // subscribe to topic

  // subscribe to topic
  Future<void> subscribeToTopicDevice(String subscribeToTopicAll) async {
    print("Subscribed t0 $subscribeToTopicAll");

    await FirebaseMessaging.instance.subscribeToTopic(subscribeToTopicAll).then(
          (value) => print("subscribed"),
        );
  }

  // unsubscribe to topic
  Future<void> unSubscribeToTopicDevice(String subscribeToTopicAll) async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(subscribeToTopicAll)
        .then(
          (value) => print("unSubscribed"),
        );
  }

  //9TH STEP

  ///Sends notification to this phone that presses the button

  Future<void> sendNotificationToTopicALlToSee(
      String title, String description, String topicTOSubscribe) async {
    String serverToken =
        'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL';

    await _firebaseMessaging.requestPermission();

    await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': title,
            'body': description,
            'show_when': true,
            'icon': '@mipmap/ic_launcher',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '11',
            'status': 'done'
          },
          'to': '/topics/$topicTOSubscribe',
        },
      ),
    )
        .catchError((error) {
      print(error);
    });
  }
}
