import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import '../../../main.dart';
import '../../../model/ConnectionChecker.dart';
import '../../../shared/constants.dart';
import '../../home/learnersHome.dart';
import '../Authenticate.dart';
import 'LearnersProfile.dart';

var userLoggedIn = FirebaseAuth.instance.currentUser!.uid;
Logger logger = Logger(printer: PrettyPrinter(colors: true));

//A Model to grab and store data
class UserEditSubjects {
  List<String> subjects;
  List<String> teachersID;
  String documentId;

  UserEditSubjects(
    this.subjects,
    this.teachersID,
    this.documentId,
  );

  final userDataEdit = FirebaseFirestore.instance.collection('learnersData');

  //get a document that has current users ID and edit it
  Future<void> addUser(String documentID) async {
    // Update Marks
    return userDataEdit
        .doc(documentId)
        .set({
          'subjects': subjects,
          //added teachers list of IDs
          'teachersID': teachersID,
        }, SetOptions(merge: true))
        .then((value) => logger.e("User edited Marks"))
        .catchError((error) => logger.e("Failed to edit user: $error"));
  }
}

//=======================================================

///////////////////////////////////////////////////////////
class LearnerEditSubjects extends StatefulWidget {
  const LearnerEditSubjects({Key? key}) : super(key: key);

  @override
  State<LearnerEditSubjects> createState() => _LearnerEditSubjectsState();
}

class _LearnerEditSubjectsState extends State<LearnerEditSubjects> {
  final _formKey = GlobalKey<FormState>();

  //we access signing privileges using this class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //strings used for subjects selected
  String? valueChoose1;
  String? valueChoose2;
  String? valueChoose3;
  String? valueChoose4;
  String? valueChoose5;
  String? valueChoose6;
  String? valueChoose7;
  String? valueChoose8;
  String? valueChoose9;

  //Strings used for Teachers Names selected
  String? valueTeacher1;
  String? valueTeacher2;
  String? valueTeacher3;
  String? valueTeacher4;
  String? valueTeacher5;
  String? valueTeacher6;
  String? valueTeacher7;
  String? valueTeacher8;
  String? valueTeacher9;

  //String? selectedValue;

  //save the selected strings into these lists
  List<String> subjects = ["Not Applicable"];
  List<String> teachersID = ["Not Applicable"];

  Map<String, dynamic> testsMarks = {};
  Map<String, dynamic> assignmentsMarks = {};
  Map<String, dynamic> examMarks = {};
  Map<String, dynamic> addAllMark = {};
  Map<String, dynamic> finalMarks = {};

  //List
  List<String> listItem = [
    "Accounting",
    "Afrikaans",
    "Agriculture",
    "Business Studies",
    "CAT",
    "Consumer Studies",
    "English H Language",
    "English S Language",
    "Economic M S",
    "Geography",
    "History",
    "Isizulu",
    "Life Sciences",
    "Life Orientation",
    "Mathematics",
    "Mathematics Lit.",
    "Natural Sciences",
    "Physical Sciences",
    "Social Sciences",
    "Siphedi",
    "Sisotho",
    "Technology",
    "Tourism",
    "Not applicable",
  ];
  List<String> listMathematicsType = [
    "Mathematics",
    "Mathematics Lit.",
  ];
  List<String> listEnglishType = [
    "English H Language",
    "English S Language",
  ];

  //Strings to store inputs from the user

  String uid = '';

  String documentID = '';
  Map<String, dynamic> allSubjects = {};
  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  // final user = FirebaseAuth.instance.currentUser;
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    CollectionReference teachersRegistered =
        FirebaseFirestore.instance.collection('userData');

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
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Edit your subjects",
                      style: textStyleText(context).copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Editing these subjects with marks already added by your teacher will delete the marks permanently.",
                      textAlign: TextAlign.center,
                      style: textStyleText(context).copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.8),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.spaceEvenly,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //subject 2
                                    DropdownButton(
                                      isExpanded: false,
                                      hint: Text(
                                        "Select a subject",
                                        style: textStyleText(context),
                                      ),
                                      //ValueChoose1
                                      value: valueChoose1,
                                      //listMathematics
                                      items: listMathematicsType
                                          .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          valueChoose1 = value;
                                        });
                                      },
                                    ),
                                    //subject 2 ends
                                    //Teachers name
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: teachersRegistered.snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            'No teachers yet',
                                            style: textStyleText(context),
                                          );
                                        } else if (snapshot.hasData) {
                                          List<DropdownMenuItem<String>>
                                              dropdownItems = [];
                                          snapshot.data?.docs.forEach((doc) {
                                            dropdownItems.add(
                                              DropdownMenuItem(
                                                value: doc['uid'] ?? "",
                                                child: Text(
                                                  doc['name'] ?? "",
                                                  style: textStyleText(context),
                                                ),
                                              ),
                                            );
                                          });
                                          dropdownItems.add(
                                            DropdownMenuItem(
                                              value: "N/A",
                                              child: Text(
                                                "Not Applicable",
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          );
                                          return Column(
                                            children: [
                                              DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  //valueTeacher1
                                                  value: valueTeacher1,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      //valueTeacher1
                                                      valueTeacher1 = newValue;
                                                    });
                                                  }),
                                              if (valueTeacher1 == null)
                                                const Text(
                                                  "Please select a teachers name",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
                                          );
                                        } else {
                                          return Text('Error retrieving names',
                                              style: textStyleText(context));
                                        }
                                      },
                                    ),
                                    //subject3 ends
                                  ],
                                ),
                                Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.spaceEvenly,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //subject 2
                                    DropdownButton(
                                      isExpanded: false,
                                      hint: Text(
                                        "Select a subject",
                                        style: textStyleText(context),
                                      ),
                                      value: valueChoose2,
                                      items: listEnglishType
                                          .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) => setState(
                                        () {
                                          valueChoose2 = value;
                                        },
                                      ),
                                    ),
                                    //subject 2 ends
                                    //Teachers name
                                    StreamBuilder<QuerySnapshot>(
                                      stream: teachersRegistered.snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            'No teachers yet',
                                            style: textStyleText(context),
                                          );
                                        } else if (snapshot.hasData) {
                                          List<DropdownMenuItem<String>>
                                              dropdownItems = [];
                                          snapshot.data?.docs.forEach((doc) {
                                            dropdownItems.add(
                                              DropdownMenuItem(
                                                value: doc['uid'],
                                                child: Text(
                                                  doc['name'],
                                                  style: textStyleText(context),
                                                ),
                                              ),
                                            );
                                          });
                                          dropdownItems.add(
                                            DropdownMenuItem(
                                              value: "N/A",
                                              child: Text(
                                                "Not Applicable",
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          );
                                          return Column(
                                            children: [
                                              DropdownButton(
                                                hint: Text(
                                                  "Teachers name",
                                                  style: textStyleText(context),
                                                ),
                                                value: valueTeacher2,
                                                items: dropdownItems,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    valueTeacher2 = newValue!;
                                                  });
                                                },
                                              ),
                                              if (valueTeacher2 == null)
                                                const Text(
                                                  "Please select a teachers name",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
                                          );
                                        } else {
                                          return Text('Error retrieving names',
                                              style: textStyleText(context));
                                        }
                                      },
                                    ),
                                    //subject3 ends
                                  ],
                                ),
                                /////////////////////////////////////////////////////////////////////
                                Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.spaceEvenly,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //subject 2
                                    DropdownButton(
                                      isExpanded: false,
                                      hint: Text(
                                        "Select a subject",
                                        style: textStyleText(context),
                                      ),
                                      value: valueChoose3,
                                      items: listItem
                                          .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) => setState(
                                        () {
                                          valueChoose3 = value;
                                        },
                                      ),
                                    ),
                                    //subject 2 ends
                                    //Teachers name
                                    StreamBuilder<QuerySnapshot>(
                                        stream: teachersRegistered.snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text(
                                              'No teachers yet',
                                              style: textStyleText(context),
                                            );
                                          } else if (snapshot.hasData) {
                                            List<DropdownMenuItem<String>>
                                                dropdownItems = [];

                                            snapshot.data?.docs.forEach((doc) {
                                              dropdownItems.add(
                                                DropdownMenuItem(
                                                  value: doc['uid'],
                                                  child: Text(
                                                    doc['name'],
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              );
                                            });
                                            dropdownItems.add(
                                              DropdownMenuItem(
                                                value: "N/A",
                                                child: Text(
                                                  "Not Applicable",
                                                  style: textStyleText(context),
                                                ),
                                              ),
                                            );

                                            return Column(
                                              children: [
                                                DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher3,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher3 = newValue!;
                                                    });
                                                  },
                                                ),
                                                if (valueTeacher3 == null)
                                                  const Text(
                                                    "Please select a teachers name",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          } else {
                                            return Text(
                                                'Error retrieving names',
                                                style: textStyleText(context));
                                          }
                                          //subject3 end,
                                        }),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose4,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) => setState(
                                            () {
                                              valueChoose4 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No teachers yet',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];

                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher4,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher4 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher4 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                        //subject3 ends
                                      ],
                                    ),
                                    //////////////////////new Streams////////
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose5,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) => setState(
                                            () {
                                              valueChoose5 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No Teacher',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];

                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher5,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher5 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher5 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                        //subject3 ends
                                      ],
                                    ),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose6,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) => setState(
                                            () {
                                              valueChoose6 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No teacher yet',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];

                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher6,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher6 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher6 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                        //subject3 ends
                                      ],
                                    ),
                                    //      /////////////////////////////////////////////////////////////////////
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose7,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (String? value) =>
                                              setState(
                                            () {
                                              valueChoose7 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No teacher yet',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];

                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher7,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher7 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher7 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                        //subject3 ends
                                      ],
                                    ),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose8,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (String? value) =>
                                              setState(
                                            () {
                                              valueChoose8 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No teacher yet',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];

                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher8,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher8 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher8 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                        //subject3 ends
                                      ],
                                    ),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceEvenly,
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //subject 2
                                        DropdownButton(
                                          isExpanded: false,
                                          hint: Text(
                                            "Select a subject",
                                            style: textStyleText(context),
                                          ),
                                          value: valueChoose9,
                                          items: listItem
                                              .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (String? value) =>
                                              setState(
                                            () {
                                              valueChoose9 = value;
                                            },
                                          ),
                                        ),
                                        //subject 2 ends
                                        //Teachers name
                                        StreamBuilder<QuerySnapshot>(
                                            stream:
                                                teachersRegistered.snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  'No teacher yet',
                                                  style: textStyleText(context),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];
                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'],
                                                      child: Text(
                                                        doc['name'],
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                dropdownItems.add(
                                                  DropdownMenuItem(
                                                    value: "N/A",
                                                    child: Text(
                                                      "Not Applicable",
                                                      style: textStyleText(
                                                          context),
                                                    ),
                                                  ),
                                                );
                                                return Column(
                                                  children: [
                                                    DropdownButton(
                                                      hint: Text(
                                                        "Teachers name",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                      value: valueTeacher9,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher9 =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (valueTeacher9 == null)
                                                      const Text(
                                                        "Please select a teachers name",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
                                              }
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ]),
                              //================= Row nine ends ============//
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(70),
                                topLeft: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () async {
                                    //check if the form is validated
                                    await showCupertinoDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoAlertDialog(
                                        title: Text(
                                          "Change my subjects?",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              try {
                                                // TODO replace my current subjects with thses
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
                                                            const Authenticate()),
                                                  );
                                                } else {
                                                  //TODO Update the subjects and ID's
                                                  await updateSubjects(
                                                          documentID)
                                                      .then(
                                                        (value) => snack(
                                                            "Update complete.",
                                                            context),
                                                      )
                                                      .whenComplete(
                                                        () => Navigator.of(
                                                                context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LearnersProfile(),
                                                          ),
                                                        ),
                                                      );
                                                }
                                              } on Exception catch (e) {
                                                snack(e.toString(), context);
                                              }

                                              setState(() {
                                                loading = false;
                                              });
                                            },
                                            child: const Text('Update'),
                                          ),
                                        ],
                                        content: Text(
                                          "Are you sure you want to proceed with this action?",
                                          style: textStyleText(context)
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      ),
                                    );
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: loading
                                      ? SpinKitChasingDots(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          size: 13,
                                        )
                                      : Text(
                                          "Update",
                                          style: textStyleText(context)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
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

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserFields();
    setState(() {
      teachersID;
    });
    logger.i("inside init after getting data: $documentID");
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future updateSubjects(String documentIdCurrent) async {
    setState(() {
      loading = true;
    });
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      //get Current User
      final userCurrent = auth.currentUser!.uid;
      //store user in a string/
      uid = userCurrent.toString();

      //add subjects to the list
      subjects.add(valueChoose1!);
      subjects.add(valueChoose2!);
      subjects.add(valueChoose3!);
      subjects.add(valueChoose4!);
      subjects.add(valueChoose5!);
      subjects.add(valueChoose6!);
      subjects.add(valueChoose7!);
      subjects.add(valueChoose8!);
      subjects.add(valueChoose9!);

      teachersID.add(valueTeacher1!);
      teachersID.add(valueTeacher2!);
      teachersID.add(valueTeacher3!);
      teachersID.add(valueTeacher4!);
      teachersID.add(valueTeacher5!);
      teachersID.add(valueTeacher6!);
      teachersID.add(valueTeacher7!);
      teachersID.add(valueTeacher8!);
      teachersID.add(valueTeacher9!);

      logger.i(teachersID);
      logger.i(subjects);
      logger.i(addAllMark);

      //insert data using a class
      UserEditSubjects _user = UserEditSubjects(
        subjects,
        teachersID,
        documentIdCurrent,
      );
      //TODO this should add the registered user to the userData
      //TODO collection with UID
      _user.addUser(documentID);
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      snack(error.toString(), context);
    } catch (error) {
      if (error == "ERROR_INVALID_EMAIL") {
        snack(error.toString(), context);
      } else if (error == "ERROR_WRONG_PASSWORD") {
        snack(error.toString(), context);
      } else if (error == "ERROR_USER_NOT_FOUND") {
        snack(error.toString(), context);
      } else if (error == "ERROR_USER_DISABLED") {
        snack(error.toString(), context);
      } else if (error == "ERROR_TOO_MANY_REQUESTS") {
        snack(error.toString(), context);
      } else if (error == "ERROR_OPERATION_NOT_ALLOWED") {
        snack(error.toString(), context);
      } else {
        snack(error.toString(), context);
      }
    }
    //Navigator.current
    setState(() {
      loading = false;
    });
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }

  ////////////////////////////////////////
  Future<void> _getCurrentUserFields() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> userQuery =
        firestore.collection('learnersData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();

        setState(() {
          //get the learners details
          documentID = documentSnapshot.id;
        });

        logger.i("inside getField $documentID");
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}
