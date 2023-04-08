import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/shared/constants.dart';
import 'package:logger/logger.dart';

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
                    }
                    var documents = streamSnapshot.data!.docs;
                    final List<QueryDocumentSnapshot> docs =
                        streamSnapshot.data!.docs;
                    return ListView.builder(
                      //reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                  FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(document.id)
                                      .get();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String grade = '';
                                      String subject = '';
                                      String name = '';
                                      String title = '';
                                      String description = '';
                                      grade = documents[index]["grade"];
                                      subject = documents[index]["subject"];
                                      name = documents[index]["name"];
                                      title = documents[index]["title"];
                                      description =
                                          documents[index]["description"];

                                      return AlertDialog(
                                        title: Text(
                                          'Update the notification',
                                          style: textStyleText(context)
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        content: Column(
                                          children: [
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  name = value;
                                                });
                                              },
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                name = value;
                                              },
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                name = value;
                                              },
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                name = value;
                                              },
                                            ),
                                            TextFormField(
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                label: Text(
                                                  'Description',
                                                  style: textStyleText(context),
                                                ),
                                                hintText: "Description",
                                                enabledBorder: null,
                                                focusedBorder: null,
                                                border: null,
                                              ),
                                              onChanged: (value) {
                                                name = value;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Update',
                                              style: textStyleText(context),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Cancel',
                                              style: textStyleText(context),
                                            ),
                                            onPressed: () {
                                              // Do something with the inputText
                                              print('Entered text: $name');
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
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
                                  child: Column(
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Name of Teacher",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Grade",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Title",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "About",
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  documents[index].get("name"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  documents[index].get("grade"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  documents[index].get("title"),
                                                  style: textStyleText(context),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
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
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 75,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            documents[index].get("description"),
                                            style: textStyleText(context),
                                          ),
                                        ),
                                      ),
                                    ],
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
}
