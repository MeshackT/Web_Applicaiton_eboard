import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/*
* This class is used to connect to the emailJS.com and send emails from this device
* */
class SendEmail {
  static const serviceId = "service_87cdk3x";
  static const templateId = "template_luf2qpl";
  static const userId = "J3i5Zxm_DHgjT4AfS";

  static Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_name': name,
              'user_email': email,
              'user_subject': subject,
              'user_message': message,
            },
          },
        ));
    if (kDebugMode) {
      print(response.toString());
    }
  }
}
