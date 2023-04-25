import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

class SendUsFeedBack extends StatefulWidget {
  const SendUsFeedBack({Key? key}) : super(key: key);

  @override
  State<SendUsFeedBack> createState() => _SendUsFeedBackState();
}

class _SendUsFeedBackState extends State<SendUsFeedBack> {
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
        content: Text(
          'Tap back again to leave the application',
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        decoration: const BoxDecoration(
          //screen background color
          gradient: LinearGradient(
              colors: [Color(0x0fffffff), Color(0xE7791971)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      ),
    );
  }
}
