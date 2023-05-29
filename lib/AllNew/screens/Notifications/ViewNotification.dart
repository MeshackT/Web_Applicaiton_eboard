import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class ViewNotifications extends StatefulWidget {
  String subjectOfTeacherPassed = "";

  ViewNotifications({Key? key, required this.subjectOfTeacherPassed})
      : super(key: key);

  @override
  State<ViewNotifications> createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> {
  CollectionReference userFeeds =
      FirebaseFirestore.instance.collection('feeds');
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference feedCollection =
      FirebaseFirestore.instance.collection('feeds');

  TextEditingController aboutEdit = TextEditingController();
  TextEditingController titleEdit = TextEditingController();
  TextEditingController gradeEdit = TextEditingController();

  String aboutEditTemp = "";
  String titleEditTemp = "";
  String gradeEditTemp = "";
  String documentIdEdit = "";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          //screen background color
          gradient: LinearGradient(
              colors: [Color(0x00cccccc), Color(0xE7791971)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: feedCollection
                      .where('subject',
                          isEqualTo: widget.subjectOfTeacherPassed)
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (ctx, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: Column(
                        children: [
                          Text(
                            'Waiting for Internet Connection',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          SpinKitChasingDots(
                            color: Theme.of(context).primaryColorDark,
                            size: 15,
                          ),
                        ],
                      ));
                    } else if (streamSnapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(
                          child: Column(
                        children: [
                          Text(
                            'No for Internet Connection',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          SpinKitChasingDots(
                            color: Theme.of(context).primaryColorDark,
                            size: 15,
                          ),
                        ],
                      ));
                    } else if (streamSnapshot.data!.size == 0) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      );
                    }
                    var documents = streamSnapshot.data!.docs;
                    final List<QueryDocumentSnapshot> docs =
                        streamSnapshot.data!.docs;
                    return ListView.builder(
                      // reverse: true,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(parent: null),
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        //get the document index
                        DocumentSnapshot document =
                            streamSnapshot.data!.docs[index];
                        Timestamp timestamp = document.get("time");

                        DateTime dateTime = timestamp.toDate();
                        // convert timestamp to DateTime
                        var formattedDateTime =
                            "${dateTime.month}/${dateTime.day}"
                            "/${dateTime.year} | ${dateTime.hour}"
                            ":${dateTime.minute}";

                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Dismissible(
                              key: Key(document.id),
                              onDismissed: (direction) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(document.id)
                                      .delete();
                                });
                                snack("Notification deleted", context);
                              },
                              background: Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Delete",
                                        style: textStyleText(context).copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "Do you really want to dismiss this notification?",
                                        style: textStyleText(context),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            "Yes",
                                            style: textStyleText(context),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            "Cancel",
                                            style: textStyleText(context),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              movementDuration:
                                  const Duration(milliseconds: 500),
                              direction: DismissDirection.endToStart,
                              child: InkWell(
                                onLongPress: () {
                                  logger.i(" $titleEditTemp $aboutEditTemp"
                                      " $gradeEditTemp ${documents[index].id}");
                                  logger.i(documents[index].data());

                                  setState(() {
                                    ///TODO get and set the data collected into these values
                                    aboutEditTemp = documents[index]
                                        .get("description")
                                        .toString();
                                    titleEditTemp = documents[index]
                                        .get("title")
                                        .toString();
                                    gradeEditTemp = documents[index]
                                        .get("grade")
                                        .toString();
                                    documentIdEdit = documents[index].id;
                                  });

                                  showSheetToEdit(
                                    context,
                                    titleEditTemp,
                                    aboutEditTemp,
                                    gradeEditTemp,
                                    documentIdEdit,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                documents[index].get("subject"),
                                                style: textStyleText(context)
                                                    .copyWith(
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                formattedDateTime.toString(),
                                                style: textStyleText(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Name of Teacher",
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Grade",
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Title",
                                                    style:
                                                        textStyleText(context)
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 70, //changed
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "About",
                                                          style: textStyleText(
                                                                  context)
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Utils.toolTipMessage(
                                                            "Press and hold to edit the message.\nScroll up if the about is not seen",
                                                            context),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    documents[index]
                                                        .get("name"),
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    documents[index]
                                                        .get("grade"),
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    documents[index]
                                                        .get("title"),
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 5,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, left: 10, right: 10),
                                          child: Divider(
                                            height: .5,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Text(
                                            documents[index].get("description"),
                                            style: textStyleText(context)
                                                .copyWith(),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSheetToEdit(BuildContext context, titleEditTemp, aboutEditTemp,
      gradeEditTemp, documentIdEdit) {
    bool isLoading = false;

    setState(() {
      titleEdit.text = titleEditTemp;
      aboutEdit.text = aboutEditTemp;
      gradeEdit.text = gradeEditTemp;
    });
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      elevation: 1,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Edit your notification",
                              style: textStyleText(context).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: titleEdit,
                            decoration: InputDecoration(
                                label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Title",
                                style: textStyleText(context).copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )),
                            style: textStyleText(context),
                            textAlign: TextAlign.start,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              setState(() {
                                titleEdit.text = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: gradeEdit,
                            decoration: InputDecoration(
                                label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Grade",
                                style: textStyleText(context).copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )),
                            style: textStyleText(context),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              setState(() {
                                gradeEdit.text = value!;
                              });
                            },
                          ),
                          TextFormField(
                            controller: aboutEdit,
                            maxLines: 5,
                            decoration: InputDecoration(
                                label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "About",
                                style: textStyleText(context).copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )),
                            style: textStyleText(context),
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              setState(() {
                                aboutEdit.text = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
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
                            try {
                              Fluttertoast.showToast(
                                  msg: "waiting for update to complete.",
                                  backgroundColor:
                                      Theme.of(context).primaryColor);
                              final CollectionReference learnersCollection =
                                  FirebaseFirestore.instance
                                      .collection('feeds');
                              final DocumentReference identityDocument =
                                  learnersCollection.doc(documentIdEdit);
                              await identityDocument
                                  .set({
                                    'grade': gradeEdit.text.toString(),
                                    'title': titleEdit.text.toString(),
                                    'description': aboutEdit.text.toString(),
                                  }, SetOptions(merge: true))
                                  .then(
                                    (value) => Fluttertoast.showToast(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        msg: "Edited Notifications"),
                                  )
                                  .whenComplete(
                                      () => Navigator.of(context).pop());
                            } on Exception catch (e) {
                              // TODO
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                          style: buttonRound,
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: buttonRound,
                          child: Text(
                            "Cancel",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
