// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebaseMessagingService {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   Future<String?> getToken() async {
//     String? token = await messaging.getToken();
//     print("FirebaseMessaging token: $token");
//     return token;
//   }
//
//   void configureFirebaseMessaging() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: $message");
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onMessageOpenedApp: $message");
//     });
//
//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//       print("onBackgroundMessage: $message");
//     });
//   }
// }
