// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class FcmApi {
//   static Future<bool> sendNotification(String title, String description) async {
//     final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization':
//           'AAAANcqEdDA:APA91bGdr_w0xw6MemCCrXGjcX8CPrUuHYieAvjOZiUNumG9LD2NDdo6SGI_UyN_pq5rQgSMGgaIfjqQzA6Z8XAfJ-Qls1a1PjM7qskltEOxEH3ObU1Wb0B3PlezTDMJJPnMS4DTrPZL'
//     };
//
//     final body = jsonEncode({
//       'to': '/topics/all',
//       'notification': {
//         'title': title,
//         'body': description,
//         'android_channel_id': 'easyapproach',
//         'priority': 'high',
//         'show_when': true,
//         'icon': 'ic_notification',
//         'sound': 'default',
//       }
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//     return response.statusCode == 200;
//   }
// }
