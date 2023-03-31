import 'dart:io';

import 'package:flutter/material.dart';

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
}
