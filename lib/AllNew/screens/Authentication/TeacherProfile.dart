import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../home/home.dart';
import 'Authenticate.dart';

var user = FirebaseAuth.instance.currentUser!;

class TeachersProfile extends StatefulWidget {
  const TeachersProfile({Key? key}) : super(key: key);

  @override
  State<TeachersProfile> createState() => _TeachersProfileState();
}

class _TeachersProfileState extends State<TeachersProfile> {
  String teachersName = "";
  String teachersSecondName = "";
  String teachersGrade = '';
  String teachersEmail = "";
  String documentIDInitial = '';
  List<dynamic> teachersSubjects = [];

  bool isLoading = false;
  bool isEmptyData = false;

  TextEditingController editNameOfTeachers = TextEditingController();
  TextEditingController editSecondNameOfTeachers = TextEditingController();
  TextEditingController editEmailOfTeachers = TextEditingController();
  TextEditingController editS1OfTeachers = TextEditingController();
  TextEditingController editS2OfTeachers = TextEditingController();

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserFields(teachersGrade, teachersEmail, teachersName,
        teachersSecondName,
        teachersSubjects, documentIDInitial);
    //no data is received
    logger.e(
        "$teachersSubjects\nafter getting the data initially\n $documentIDInitial");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              //screen background color
              gradient: LinearGradient(colors: [
                const Color(0x00cccccc),
                const Color(0xE6691971).withOpacity(.7)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          child: OutlinedButton(
                            style: buttonRound,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          child: OutlinedButton(
                            style: buttonRound,
                            onPressed: () async {
                              await showSheetToEditForProfile(
                                teachersName,
                                teachersSecondName,
                                teachersEmail,
                                teachersSubjects,
                                documentIDInitial,
                              );
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "My Profile",
                      style: textStyleText(context).copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        color: Theme.of(context).primaryColor.withOpacity(.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText("Name"),
                                labelText(teachersName.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText("Second Name"),
                                labelText(teachersSecondName.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText("Email"),
                                labelText(teachersEmail.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     labelText("Grade"),
                            //     labelText(teachersGrade.toString()),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 6,
                            // ),
                            Divider(
                              height: 7,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText("Subjects"),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    labelText(teachersSubjects.join("\n")),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? SpinKitChasingDots(
                            color: Theme.of(context).primaryColorLight,
                            size: 12,
                          )
                        : OutlinedButton(
                            style: buttonRound,
                            onPressed: () async {
                              showCupertinoDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text(
                                    "Delete my account?",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                      child: const Text('Cancel!'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          // capture the context before the async operations
                                          final scaffoldContext =
                                              ScaffoldMessenger.of(context);
                                          final navigatorContext =
                                              Navigator.of(context);

                                          await _deleteSubjectFromAllDocuments();
                                          await _deleteIDFromAllDocuments();

                                          FirebaseAuth.instance.currentUser!
                                              .delete()
                                              .then((value) {
                                            signOut(context);
                                          });
                                          // use the captured context after the async operations
                                          scaffoldContext.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Account deleted successfully.'),
                                            ),
                                          );

                                          navigatorContext.pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Authenticate(),
                                            ),
                                          );
                                        } on Exception catch (e) {
                                          snack(e.toString(), context);
                                        }

                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: const Text('Delete!'),
                                    ),
                                  ],
                                  content: const Text(
                                      "You are about to delete your account permanently and it can't be retrieved!."),
                                ),
                              );
                            },
                            child: isLoading
                                ? SpinKitChasingDots(
                                    color: Theme.of(context).primaryColor,
                                    size: 12,
                                  )
                                : Text(
                                    "Delete my account permanently?",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Wrap labelText(String labelText) {
    return Wrap(
      children: [
        Text(
          labelText,
          style: textStyleText(context).copyWith(
            fontSize: 15,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  //get the field required for the current logged in user
  Future<void> _getCurrentUserFields(
    String nameOfTeachers,
    String secondNameOfTeacher,
    String gradeOfTeachers,
    String emailOfTeachers,
    List<dynamic> subjectsOfTeachers,
    String documentID,
  ) async {
    logger.i("Teachers Data");
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Query<Map<String, dynamic>> userQuery =
          firestore.collection('userData').where('uid', isEqualTo: user.uid);
      userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              querySnapshot.docs.first;
          // Map<String, dynamic>? data = documentSnapshot.data();

          //get the learners details
          subjectsOfTeachers = documentSnapshot.get('subjects');

          nameOfTeachers = documentSnapshot.get("name");
          secondNameOfTeacher = documentSnapshot.get("secondName");
          emailOfTeachers = documentSnapshot.get("email");
          // gradeOfTeachers = data['grade'].toString() ?? "";
          documentID = documentSnapshot.id;

          setState(() {
            teachersName = nameOfTeachers.toString();
            teachersSecondName = secondNameOfTeacher.toString();
            teachersEmail = emailOfTeachers.toString();
            teachersSubjects = subjectsOfTeachers.toList();
            documentIDInitial = documentID.toString();

            editEmailOfTeachers.text = teachersEmail.toString();
            editS1OfTeachers.text = teachersSubjects[0];
            editS2OfTeachers.text = teachersSubjects[1];
            editNameOfTeachers.text = teachersName.toString();
            editSecondNameOfTeachers.text = teachersSecondName.toString();
          });
          //logger.i("inside getField $teachersGrade");
          logger.e(
              "inside the method\n $teachersEmail\n"
                  "$teachersName"
                  "$teachersSecondName"
                  "$teachersSubjects"
                  "${teachersSubjects.length}"
                  "$documentIDInitial"
                  " ${teachersSubjects[0]} "
                  "${teachersSubjects[2]}");
        } else {
          logger.i('No document found');
        }
      }).catchError((error) => print('Failed to get document: $error'));
    } on Exception catch (e) {
      // TODO
      logger.i(e);
    }
  }

  Future signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ));
      await FirebaseAuth.instance
          .signOut()
          .then((value) => SpinKitChasingDots(
        color: Theme.of(context).primaryColor,
      ));
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Authenticate()));
        } else {
          Fluttertoast.showToast(
              backgroundColor: Theme.of(context).primaryColor,
              msg: 'Could not log out, you are still signed in!');
        }
      });

      //ChangeNotifier();
    } catch (e) {
      logger.i(e.toString());
      snack('Failed to Sign Out: $e', context);
    }
  }

  ///show bottom Sheet for editing
  showSheetToEditForProfile(
      String nameOfLearnerFromEdit,
      String secondNameOfLearnerFromEdit,
      String emailOfLearnerFromEdit,
      List<dynamic> subjectOfLearnerFromEdit,
      String documentIdEdit) {
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
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
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
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          child: Container(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.7),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Want to change your details?",
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
                          child: Column(children: [
                            TextFormField(
                              controller: editNameOfTeachers,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Name",
                                hintStyle: textStyleText(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                ),
                              ),
                              style: textStyleText(context),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  editNameOfTeachers.text = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: editSecondNameOfTeachers,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Second Name",
                                hintStyle: textStyleText(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                ),
                              ),
                              style: textStyleText(context),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  editSecondNameOfTeachers.text = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: editEmailOfTeachers,
                              decoration: textInputDecoration.copyWith(
                                hintText: "email",
                                hintStyle: textStyleText(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                ),
                              ),
                              style: textStyleText(context),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  editEmailOfTeachers.text = teachersEmail;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: editS1OfTeachers,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Subject 1",
                                hintStyle: textStyleText(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                ),
                              ),
                              style: textStyleText(context),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  editS1OfTeachers.text = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: editS2OfTeachers,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Subject 2",
                                hintStyle: textStyleText(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7),
                                ),
                              ),
                              style: textStyleText(context),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  editS2OfTeachers.text = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        if (
                                        editNameOfTeachers.text.isEmpty ||
                                        editSecondNameOfTeachers.text.isEmpty ||
                                            editEmailOfTeachers.text.isEmpty ||
                                            editS1OfTeachers.text.isEmpty) {
                                          snack(
                                              "Insert data in the provided space above.",
                                              context);
                                        } else {

                                          //await user.updateEmail(editEmailOfTeachers.text.trim().toLowerCase());

                                          List<dynamic> editSubjects =[];
                                          editSubjects.add(editS1OfTeachers.text);
                                          editSubjects.add(editS2OfTeachers.text);

                                          final CollectionReference
                                              learnersCollection =
                                              FirebaseFirestore.instance
                                                  .collection('userData');
                                          final DocumentReference
                                              identityDocument =
                                              learnersCollection
                                                  .doc(documentIdEdit);
                                          await identityDocument
                                              .set({
                                                'subjects': editSubjects,
                                                'name': editNameOfTeachers.text.toString(),
                                                'secondName': editSecondNameOfTeachers.text
                                                    .toString(),
                                                'email': editEmailOfTeachers
                                                    .text
                                                    .toString(),
                                              }, SetOptions(merge: true))
                                              .then(
                                                (value) =>
                                                    Fluttertoast.showToast(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        msg:
                                                            "Edited my details"),
                                              )
                                              .whenComplete(
                                                () =>
                                                    Navigator.of(context).pop(),
                                              );
                                        }
                                      } on Exception catch (e) {
                                        snack(e.toString(), context);
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    style: buttonRound,
                                    child: isLoading
                                        ? SpinKitChasingDots(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 13,
                                          )
                                        : Text(
                                            "Update",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
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
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  //this function deletes all the data in the subjects field in firebase
  Future<void> _deleteSubjectFromAllDocuments() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Query<Map<String, dynamic>> userQuery = firestore
          .collection('learnersData')
          .where('subjects', arrayContains: teachersSubjects[0].toString());

      userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          logger.i("Data Found");

          querySnapshot.docs.forEach(
              (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            //get the document reference
            DocumentReference documentReference =
                firestore.collection('learnersData').doc(documentSnapshot.id);

            //remove the subject from the document's subjects array
            List<String> subjects =
                List<String>.from(documentSnapshot['subjects']);
            subjects.remove(teachersSubjects[0].toString());

            //update the document with the new subjects array
            documentReference
                .update({'subjects': subjects})
                .then((value) => logger
                    .i('Subject removed from document ${documentSnapshot.id}'))
                .catchError((error) => logger.e(
                    'Failed to remove subject from document ${documentSnapshot.id}: $error'));
          });
        } else {
          print('No documents found');
        }
      }).catchError((error) => logger.e('Failed to get documents: $error'));
    } on Exception catch (e) {
      // TODO
      logger.i(e);
    }
  }

  //delete subject in all documents with user ID
  Future<void> _deleteIDFromAllDocuments() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Query<Map<String, dynamic>> userQuery = firestore
          .collection('learnersData')
          .where('teachersID', arrayContains: user.uid);

      userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          logger.i("Data Found");

          querySnapshot.docs.forEach(
              (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            //get the document reference
            DocumentReference documentReference =
                firestore.collection('learnersData').doc(documentSnapshot.id);

            //remove the teacher ID from the document's teachersID array
            List<String> teachersID =
                List<String>.from(documentSnapshot['teachersID']);
            teachersID.remove(user.uid);

            //update the document with the new teachersID array
            documentReference
                .update({'teachersID': teachersID})
                .then((value) => logger.i(
                    'Teacher ID removed from document ${documentSnapshot.id}'))
                .catchError((error) => logger.i(
                    'Failed to remove teacher ID from document ${documentSnapshot.id}: $error'));
          });
        } else {
          logger.i('No documents found');
        }
      }).catchError((error) => logger.e('Failed to get documents: $error'));
    } on Exception catch (e) {
      // TODO
      logger.i(e);
    }
  }
}
