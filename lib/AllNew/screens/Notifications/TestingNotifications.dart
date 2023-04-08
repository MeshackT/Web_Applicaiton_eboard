// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificatioClass {
//   Future<void> notify() async {
//     await FirebaseMessaging.instance.subscribeToTopic("topic");
//
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//
//     FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
//       // TODO: If necessary send token to application server.
//
//       // Note: This callback is fired at each app startup and whenever a new
//       // token is generated.
//     }).onError((err) {
//       // Error getting token.
//     });
//
//     await FirebaseMessaging.instance.setAutoInitEnabled(true);
//   }
// }
