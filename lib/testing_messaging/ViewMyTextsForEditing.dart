import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';
import 'messaging.dart';

class ViewMyTextsForEditing extends StatefulWidget {
  const ViewMyTextsForEditing({Key? key}) : super(key: key);

  @override
  State<ViewMyTextsForEditing> createState() => _ViewMyTextsForEditingState();
}

class _ViewMyTextsForEditingState extends State<ViewMyTextsForEditing> {
  TextEditingController aboutEdit = TextEditingController();
  TextEditingController titleEdit = TextEditingController();
  TextEditingController gradeEdit = TextEditingController();

  String titleEditTemp = "";
  String documentIdEdit = "";
  String nameOfTeacher = "";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserData(nameOfTeacher);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Messaging(),
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
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Messaging(),
                          ),
                        );
                      },
                      style: buttonRound,
                      child: Text(
                        "Modify Images",
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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("messagesWithTextOnly")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.size <= 0) {
                      return Center(
                        child: Text(
                          "No data sent yet.",
                          style: textStyleText(context).copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitChasingDots(
                        color: Theme.of(context).primaryColor,
                      );
                    } else {
                      var _documents = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: _documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = _documents[index];
                          String text = document.get("text");
                          String name = document.get("nameOfTeacher");
                          String teacherID = document.get("userID");

                          var dateAndTime = document.get("timestamp");
                          String documentIDCurrent = document.id;

                          Timestamp timestamp = document.get("timestamp");
                          DateTime dateTime = timestamp.toDate();
                          // convert timestamp to DateTime
                          var formattedDateTime =
                              " ${dateTime.hour}:${dateTime.minute}";

                          return InkWell(
                            onLongPress: () {
                              setState(() {
                                titleEdit.text = text.toString();
                              });
                              showSheetToEdit(
                                  text, documentIDCurrent, teacherID);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text(
                                          name.toString()[0],
                                          style:
                                              textStyleText(context).copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        flex:1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: textStyleText(context)
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Utils.formattedDate(
                                                      dateAndTime),
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(.7),
                                                          fontSize: 10),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  formattedDateTime,
                                                  style: textStyleText(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(.7),
                                                          fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Utils.toolTipMessage("Press and hold to edit or delete the message", context),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          onPressed: () async {},
                                          icon: Icon(
                                            Icons.circle,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Text(
                                      text,
                                      style: textStyleText(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO Show text edit sheet
  showSheetToEdit(titleEditTemp, documentIdEdit, String teacherID) {
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
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Container(
              //color: Theme.of(context).primaryColorLight,
              // height: MediaQuery.of(context).size.height / 1.2,
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewMyTextsForEditing(),
                            ),
                          );
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10),
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
                            color:
                                Theme.of(context).primaryColor.withOpacity(.7),
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
                                snack("Insert Text in the provided space",
                                    context);
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
                          OutlinedButton(
                            onPressed: () async {
                              if (teacherID.toString() !=
                                  (user!.uid).toString()) {
                                Fluttertoast.showToast(
                                    backgroundColor:
                                    Theme.of(context).primaryColor,
                                    msg: "Can't delete text not published by you");
                              } else {
                                final CollectionReference learnersCollection =
                                    FirebaseFirestore.instance
                                        .collection('messagesWithTextOnly');
                                final DocumentReference identityDocument =
                                    learnersCollection.doc(documentIdEdit);
                                await identityDocument
                                    .delete()
                                    .then(
                                      (value) => Fluttertoast.showToast(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          msg: "Deleted Notifications"),
                                    )
                                    .whenComplete(() => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                const ViewMyTextsForEditing())));
                                titleEdit.clear();

                              }
                            },
                            style: buttonRound,
                            child: Text(
                              "Delete",
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
          ),
        );
      },
    );
  }
  Future<void> _getCurrentUserData(String userNameCurrent) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    //get data where data ID is equals to the current logged in user
    var userQuery =
    firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        //get the subject of the teacher
        // get the name field or empty string if it doesn't exist
        setState(() {
          userNameCurrent = data?['name'] ?? '';
        });
        //check if data exist and not empty
        logger.i("inside getField $userNameCurrent");
      } else {
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}
