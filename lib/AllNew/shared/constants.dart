import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

TextStyle textStyleText(BuildContext context) {
  return TextStyle(
      fontWeight: FontWeight.normal,
      letterSpacing: 1,
      color: Theme.of(context).primaryColor);
}



ButtonStyle buttonRound = OutlinedButton.styleFrom(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    foregroundColor: Colors.purple);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(
    String message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    content: Text(
      message.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColorLight),
    ),
    duration: const Duration(seconds: 4),
  ));
}

InputDecoration textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purple, width: 2),
    borderRadius: BorderRadius.circular(30),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purple, width: 2),
    borderRadius: BorderRadius.circular(30),
  ),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purple, width: 2),
    borderRadius: BorderRadius.circular(30),
  ),
);

//scaffold messenger
final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {

  static const mobileWidth = 700;

  static showDownloading(BuildContext context, String title, String message){
    return showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),

        content:  Column(
          children: [
            Text(message,
              style: textStyleText(context).copyWith(
                  fontSize: 13),
            ),
            const SizedBox(height: 5,),
            SpinKitChasingDots(
              size: 16,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }


  //Tool Tip
  static SizedBox toolTipMessage(String message, BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: () async {

        },
        icon: const Icon(
          Icons.info,
          color: Colors.grey,
        ),
        tooltip: message,
      ),
    );
  }

  static buttonClose() {
    return MaterialButton(
      height: 60,
      onPressed: () {
        exit(0);
      },
      color: Colors.purple,
      child: const Text(
        "Exit",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(
      String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      duration: const Duration(seconds: 4),
    ));
  }

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static appBar(String title, Function() navigate) {
    return AppBar(
      leading: navigate(),
      title: Text(title),
      elevation: .5,
      backgroundColor: Colors.purple,
    );
  }

  static String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMMM yyyy').format(dateFromTimeStamp);
  }

  static String formattedTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);
    return formattedTime;
  }
}
