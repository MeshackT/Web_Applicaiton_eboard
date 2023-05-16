import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/screens/home/home.dart';
import '../AllNew/shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class TextNotifications extends StatefulWidget {
  const TextNotifications({Key? key}) : super(key: key);

  @override
  State<TextNotifications> createState() => _TextNotificationsState();
}

class _TextNotificationsState extends State<TextNotifications> {
  String _deviceToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  //subscribe all to get notified
  String topic = "notifications";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getDeviceToken();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    CollectionReference messagesWithTextOnly =
    FirebaseFirestore.instance.collection('messagesWithTextOnly');

    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 0.0),
          decoration: const BoxDecoration(
            //screen background color
            gradient: LinearGradient(
                colors: [Color(0x0fffffff), Color(0xE7791971)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
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
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TextNotifications()));
                        },
                        icon: const Icon(Icons.ac_unit),
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),
          ),
        ),
    );

  }

}

