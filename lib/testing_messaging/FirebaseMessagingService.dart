// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:logger/logger.dart';
//
// class FirebaseMessagingService {
//   //get the instance of messaging Class
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   Logger logger = Logger(printer: PrettyPrinter(colors: true));
//
//   //get the token of the device
//   Future<String> getToken() async {
//     String? token = await _fcm.getToken();
//     //return the token
//     return token ?? "";
//   }
//
//   //subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     await _fcm.subscribeToTopic(topic);
//   }
//
//   //unsubscribe to topic...cant receive messages
//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _fcm.unsubscribeFromTopic(topic);
//   }
//
//   //messages notifications on background
//   Future<void> configure() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       logger.i("Got a message whilst in the foreground!");
//       logger.i("Message data: ${message.data}");
//
//       if (message.notification != null) {
//         logger.i("Message also contained a notification:"
//             " ${message.notification}");
//       }
//     });
//   }
//
//   //handle messages on background
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print("Handling a background message: ${message.messageId}");
//   }
//
//   Future<void> sendFcmMessage() async {
//     try {
//       var token = await _fcm.getToken();
//       logger.i(token);
//
//       RemoteMessage message = const RemoteMessage(
//         data: {'key1': 'value1', 'key2': 'value2'},
//         notification: RemoteNotification(
//           title: 'New Message',
//           body: 'You have a new message',
//         ),
//         ttl: 1,
//       );
//
//       await _fcm.sendMessage(
//         messageId: token,
//         messageType: message.toString(),
//       );
//     } catch (e) {
//       logger.i(e);
//     }
//   }
// }
