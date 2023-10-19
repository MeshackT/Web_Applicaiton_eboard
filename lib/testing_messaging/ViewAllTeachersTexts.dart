// import 'package:share_plus/share_plus.dart';
import 'package:Eboard/testing_messaging/DesktopMessaging/DesktopViewAllTeachersTexts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';
import 'messaging.dart';

class ViewAllTeachersTexts extends StatefulWidget {
  const ViewAllTeachersTexts({Key? key}) : super(key: key);

  @override
  State<ViewAllTeachersTexts> createState() => _ViewAllTeachersTextsState();
}

class _ViewAllTeachersTextsState extends State<ViewAllTeachersTexts> {
  TextEditingController aboutEdit = TextEditingController();
  TextEditingController titleEdit = TextEditingController();
  TextEditingController gradeEdit = TextEditingController();

  String titleEditTemp = "";
  String documentIdEdit = "";

  bool webDisplay = false;

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const DesktopViewAllTeachersTexts();
  }

  //TODO Show pop up button
  Future<void> selectedItem(
      BuildContext context, item, String nameOfSender, String text) async {
    switch (item) {
      case 0:
        try {
          if (kIsWeb) {
            // Share.share(text);
          } else {
            if (text.isEmpty || text == "") {
              print("cant share");
              snack('There`s no url link found', context);
            } else {
              print("can share $text");
              await FlutterShare.share(
                  title: "By $nameOfSender",
                  text: text,
                  chooserTitle: "By $nameOfSender");
            }
          }
        } catch (e) {
          print(text);
          snack(e.toString(), context);
        }
        break;
    }
  }

  //TODO Show text edit sheet
  showSheetToEdit(titleEditTemp, documentIdEdit) {
    setState(() {
      titleEdit.text = titleEditTemp;
    });
    logger.i("$titleEditTemp \n ID is => $documentIdEdit ");
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      enableDrag: true,
      elevation: 1,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
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
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          titleEdit.clear();
                        });
                        Navigator.of(context).popUntil((route) => false);
                      },
                      style: buttonRound,
                      child: Text(
                        "Discard",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: Column(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(.7),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Whats on your mind?",
                          style: textStyleText(context).copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Apple SD Gothic Neo',
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TextFormField(
                      controller: titleEdit,
                      maxLines: 5,
                      decoration: textInputDecoration.copyWith(
                        hintText: "Message",
                        hintStyle: textStyleText(context).copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor.withOpacity(.7),
                        ),
                      ),
                      style: textStyleText(context),
                      textAlign: TextAlign.center,
                      autocorrect: true,
                      textAlignVertical: TextAlignVertical.center,
                      onSaved: (value) {
                        //Do something with the user input.
                        setState(() {
                          titleEdit.text = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            if (titleEdit.text.isEmpty) {
                              snack(
                                  "Insert Text in the provided space", context);
                            } else {
                              final CollectionReference learnersCollection =
                                  FirebaseFirestore.instance
                                      .collection('messagesWithTextOnly');
                              final DocumentReference identityDocument =
                                  learnersCollection.doc(documentIdEdit);
                              await identityDocument
                                  .set({
                                    'text': titleEdit.text.toString(),
                                  }, SetOptions(merge: true))
                                  .then(
                                    (value) => Fluttertoast.showToast(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        msg: "Edited Notifications"),
                                  )
                                  .whenComplete(() => null);
                            }
                            titleEdit.clear();
                          },
                          style: buttonRound,
                          child: Text(
                            "Send",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
