import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/Admin.dart';
import '../../../model/ConnectionChecker.dart';
import '../../../model/VerificationModel.dart';
import '../../../shared/constants.dart';
import '../../home/learnersHome.dart';
import '../Authenticate.dart';

var user = FirebaseAuth.instance.currentUser!;

class UserEditProfile {
  final String email;
  final String name;
  final String secondName;
  final String grade;
  final String documentID;

  UserEditProfile(
    this.email,
    this.name,
    this.secondName,
    this.grade,
    this.documentID,
  );

  final userEditData =
      FirebaseFirestore.instance.collection('learnersData').doc();

  // final CollectionReference learnersCollection =
  // FirebaseFirestore.instance
  //     .collection('messagesWithTextOnly');

  Future<void> addUser() {
    //get document ID
    final documentID = userEditData.id;
    return userEditData
        .update({
          'email': email.trim().toLowerCase(), // John Doe
          'name': name.trim(),
          'secondName': secondName.trim(),
          'grade': grade.trim(),
        })
        .then((value) => print("User edited Data"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class LearnersProfile extends StatefulWidget {
  const LearnersProfile({Key? key}) : super(key: key);

  @override
  State<LearnersProfile> createState() => _LearnersProfileState();
}

class _LearnersProfileState extends State<LearnersProfile> {
  String learnersName = "";
  String learnersSecondName = "";
  String learnersGrade = '';
  String learnersEmail = "";
  List<dynamic> learnersSubjects = [];
  String documentIDinitial = '';

  bool isLoading = false;
  bool isLoadingVerify = true;

  TextEditingController editNameOfLearner = TextEditingController();
  TextEditingController editSecondNameOfLearner = TextEditingController();
  TextEditingController editGradeOfLearner = TextEditingController();
  TextEditingController editEmailOfLearner = TextEditingController();

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserFields(learnersGrade, learnersEmail, learnersName,learnersSecondName,
        learnersSubjects, documentIDinitial);
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
                                      builder: (context) =>
                                          const LearnerHome()));
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
                                learnersName,
                                learnersSecondName,
                                learnersEmail,
                                learnersGrade,
                                documentIDinitial,
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
                                labelText(learnersName.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText("Email"),
                                Wrap(
                                  children: [
                                    labelText(learnersEmail.toString()),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText("Grade"),
                                labelText(learnersGrade.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
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
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  alignment: WrapAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        labelText(learnersSubjects
                                            .join("\n")
                                            .toString()),
                                      ],
                                    ),
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
                    OutlinedButton(
                      style: buttonRound,
                      onPressed: () async {
                        setState(() {
                          isLoadingVerify = true;
                        });
                        try {
                          await showCupertinoDialog<String>(
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
                                  onPressed: () async {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                                isLoading
                                    ? SpinKitChasingDots(
                                        color: Theme.of(context).primaryColor,
                                        size: 13,
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            // TODO First delete my data in store
                                            await _deleteMyDocumentWithData();

                                            // TODO then delete my current account
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .delete();

                                            if (FirebaseAuth
                                                    .instance.currentUser ==
                                                null) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Authenticate()),
                                              );
                                            } else {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Authenticate()),
                                              );
                                            }
                                          } on Exception catch (e) {
                                            snack(e.toString(), context);
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: const Text('Delete'),
                                      ),
                              ],
                              content: Text(
                                "You are about to delete your account permanently and every data you created, it can't be retrieved after this action is fulfilled!.",
                                style: textStyleText(context).copyWith(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          );
                        } catch (e) {
                          snack(e.toString(), context);
                        }
                      },
                      child: isLoading
                          ? SpinKitChasingDots(
                              color: Theme.of(context).primaryColorLight,
                              size: 12,
                            )
                          : Text(
                              "Delete my account permanently?",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(70),
                        topLeft: Radius.circular(70),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        height: 40,
                        color: Theme.of(context).primaryColor,
                        child: TextButton(
                          onPressed: () async {
                            signOut(context);
                          },
                          child: isLoading
                              ? SpinKitChasingDots(
                                  color: Theme.of(context).primaryColorLight,
                                  size: 13,
                                )
                              : Text(
                                  "Sign Out",
                                  style: textStyleText(context).copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0),
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          bool verifiedUser = false;
                          verifiedUser =
                              FirebaseAuth.instance.currentUser!.emailVerified;

                          var currentUser = FirebaseAuth.instance.currentUser;
                          logger.e(currentUser);
                          VerificationModel.checkEmailVerified();
                          VerificationModel.sendVerificationEmail();

                          if (verifiedUser == false) {
                            setState(() {
                              isLoadingVerify = true;
                            });
                          } else {
                            snack("Verified", context);
                          }
                          //await _deleteMyDocumentWithData();
                        },
                        child: isLoadingVerify
                            ? Text("Verify email")
                            : Text("Get Data"))
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
      direction: Axis.horizontal,
      children: [
        Text(
          labelText,
          style: textStyleText(context).copyWith(
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  //TODO This code below loops through the collection of learners and gets
  //TODO the document needed
  Future<void> _deleteMyDocumentWithData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Query<Map<String, dynamic>> userQuery =
        firestore.collection('learnersData').where('uid', isEqualTo: user.uid);
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userQuery.get();
      if (querySnapshot.size > 0) {
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        final String documentID = documentSnapshot.get('documentID');
        await FirebaseFirestore.instance
            .collection('learnersData')
            .doc(documentID)
            .delete();
      } else {
        logger.i('No document found');
        snack("data already doesn't exist", context);
        //snack("No data stored for you currently.", context);
      }
    } catch (error) {
      snack(error.toString(), context);
    }
  }

  //get the field required for the current logged in user
  Future<void> _getCurrentUserFields(
      String nameOfLeaner,
      String secondNameOfLeaner,
      String gradeOfLearner,
      String emailOfLeaner,
      List<dynamic> subjectsOfLearner,
      String documentID) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> userQuery =
        firestore.collection('learnersData').where('uid', isEqualTo: user.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();

        //get the learners details
        subjectsOfLearner = documentSnapshot.get('subjects');

        nameOfLeaner = documentSnapshot.get('name').toString();
        secondNameOfLeaner = documentSnapshot.get('secondName').toString();
        emailOfLeaner = documentSnapshot.get('email').toString();
        gradeOfLearner = documentSnapshot.get('grade').toString();
        documentID = documentSnapshot.get('documentID').toString();


        setState(() {
          learnersName = nameOfLeaner.toString();
          learnersSecondName = nameOfLeaner.toString();
          learnersEmail = emailOfLeaner.toString();
          learnersGrade = gradeOfLearner.toString();
          learnersSubjects = subjectsOfLearner.toList();
          documentIDinitial = documentID.toString();

          editEmailOfLearner.text = learnersEmail.toString();
          editGradeOfLearner.text = learnersGrade.toString();
          editNameOfLearner.text = learnersName.toString();
          editSecondNameOfLearner.text = learnersSecondName.toString();
        });
        logger.i("inside getField $learnersGrade");
        logger.i("inside getField $learnersEmail");
        logger.i("inside getField $learnersName");
        logger.i("inside getField $learnersSubjects");
        logger.i("inside getField $documentIDinitial");
      } else {}
    }).catchError((error) => print('Failed to get document: $error'));
  }

  Future signOut(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ))
          .whenComplete(
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Authenticate())),
          );
    } catch (e) {
      logger.i(e.toString());
      snack("Failed to sign out", context);
    }
    setState(() {
      isLoading = false;
    });
  }

  ///show bottom Sheet for editing
  showSheetToEditForProfile(
      String nameOfLearnerFromEdit,
      String SecondNameOfLearnerFromEdit,
      String gradeOfLearnerFromEdit,
      String emailOfLearnerFromEdit,
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
                          child: Column(
                            children: [
                              TextFormField(
                                controller: editNameOfLearner,
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
                                    editNameOfLearner.text = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: editSecondNameOfLearner,
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
                                    editSecondNameOfLearner.text = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: editEmailOfLearner,
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
                                    editEmailOfLearner.text = learnersEmail;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: editGradeOfLearner,
                                decoration: textInputDecoration.copyWith(
                                  hintText: "Grade",
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
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  //Do something with the user input.
                                  setState(() {
                                    editGradeOfLearner.text = value!;
                                  });
                                },
                              ),
                            ],
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
                              isLoading
                                  ? SpinKitChasingDots(
                                      color: Theme.of(context).primaryColor,
                                      size: 13,
                                    )
                                  : OutlinedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          if (editNameOfLearner.text.isEmpty ||
                                              editEmailOfLearner.text.isEmpty ||
                                              editGradeOfLearner.text.isEmpty) {
                                            snack(
                                                "Insert data in the provided space above.",
                                                context);
                                          } else {
                                            logger.e("We are here");
                                            final CollectionReference
                                                learnersCollection =
                                                FirebaseFirestore.instance
                                                    .collection('learnersData');
                                            final DocumentReference
                                                identityDocument =
                                                learnersCollection
                                                    .doc(documentIdEdit);

                                            await identityDocument.set({
                                              'grade': editGradeOfLearner.text
                                                  .toString(),
                                              'name': editNameOfLearner.text.toString(),
                                              'secondName': editSecondNameOfLearner.text.toString(),
                                              'email': editEmailOfLearner.text
                                                  .toString(),
                                            }, SetOptions(merge: true)).then(
                                              (value) => Fluttertoast.showToast(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  msg: "Edited Notifications"),
                                            );
                                            UserModel.getAllUserProfiles();
                                            Navigator.of(context).pop();
                                            showSheetToEditForResettingEmail(
                                                editEmailOfLearner.text
                                                    .trim()
                                                    .toLowerCase());
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code ==
                                              'requires-recent-login') {
                                            Fluttertoast.showToast(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                msg:
                                                    "Sign out before re-attempting");
                                            logger.i(e);
                                          } else if (e.code ==
                                              'invalid-email') {
                                            Fluttertoast.showToast(
                                                msg: 'Invalid email');
                                          } else if (e.code ==
                                              'email-already-in-use') {
                                            Fluttertoast.showToast(
                                                msg: 'Email is already in use');
                                          }
                                        } on Exception catch (e) {
                                          logger.e(e);
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      style: buttonRound,
                                      child: Text(
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
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  showSheetToEditForResettingEmail(
    String emailOfLearnerFromEdit,
  ) {
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
                                "Retype the email to change.",
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
                              controller: editEmailOfLearner,
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
                                  editEmailOfLearner.text = learnersEmail;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
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
                                        if (editEmailOfLearner.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: "Insert a valid email");
                                        } else {
                                          logger.e("We are here");
                                          // await FirebaseAuth.instance
                                          //     .sendPasswordResetEmail(email: learnersEmail);

                                          await FirebaseAuth.instance
                                              .sendSignInLinkToEmail(
                                                  email:
                                                      editEmailOfLearner
                                                          .text
                                                          .trim()
                                                          .toLowerCase(),
                                                  actionCodeSettings: ActionCodeSettings(
                                                      url:
                                                          'https://example.firebaseapp.com/emailSignInLink',
                                                      handleCodeInApp: true,
                                                      iOSBundleId:null,
                                                      androidPackageName:
                                                          'com.example.levy',
                                                      androidInstallApp: true,
                                                      androidMinimumVersion:
                                                          '16'));
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'requires-recent-login') {
                                          Fluttertoast.showToast(
                                              msg: "Sign Out and login again");
                                        } else if (e.code == 'invalid-email') {
                                          Fluttertoast.showToast(
                                              msg: 'Invalid email');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          Fluttertoast.showToast(
                                              msg: 'Email is already in use');
                                        }
                                      } on Exception catch (e) {
                                        logger.e(e);
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    style: buttonRound,
                                    child: isLoading
                                        ? Text(
                                            "An email link has been sent to your new email.",
                                            style: textStyleText(context)
                                                .copyWith(fontSize: 14),
                                          )
                                        : Text(
                                            "Reset Email",
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
}
