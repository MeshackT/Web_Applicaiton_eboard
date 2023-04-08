import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/gradeList/grade12.dart';
import 'package:levy/AllNew/shared/constants.dart';

import '../../../main.dart';

//A Model to grab and store data
class User {
  final String email;
  final String uid;
  final String password;
  final String name;
  final String documentID;
  final String grade;
  final String role;
  List<String> subjects;
  List<String> teachersID;
  Map<String, dynamic> allSubjects;

  User(
    this.email,
    this.uid,
    this.password,
    this.name,
    this.grade,
    this.documentID,
    this.role,
    this.subjects,
    this.teachersID,
    this.allSubjects,
  );

  final userData = FirebaseFirestore.instance.collection('learnersData').doc();

  Future<void> addUser() {
    //get document ID
    final documentID = userData.id;

    // Call the user's CollectionReference to add a new user
    return userData
        .set({
          'documentID': documentID,
          'email': email.trim().toLowerCase(), // John Doe
          'uid': uid, // Stokes and Sons
          'password': password.trim(), //
          'name': name.trim(),
          'grade': grade.trim(),
          'role': role.trim().toLowerCase(),
          'subjects': subjects,
          //added teachers list of IDs
          'teachersID': teachersID,
          "allSubjects": allSubjects,
        })
        .then((value) => print("User Data"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

//=======================================================

///////////////////////////////////////////////////////////
class LearnerRegister extends StatefulWidget {
  final Function toggleView;

  const LearnerRegister({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LearnerRegister> createState() => _LearnerRegisterState();
}

class _LearnerRegisterState extends State<LearnerRegister> {
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
  List<String> subjects = [];
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
  String email = '';
  String password = '';
  String confirmPassword = '';
  String uid = '';
  String name = '';
  String grade = '';
  String role = "Learner";
  String documentID = '';
  Map<String, dynamic> allSubjects = {};
  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  // final user = FirebaseAuth.instance.currentUser;
  User? user = FirebaseAuth.instance.currentUser as User?;

  @override
  Widget build(BuildContext context) {
    CollectionReference teachersRegistered =
        FirebaseFirestore.instance.collection('userData');

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        topRight: Radius.circular(280),
                        topLeft: Radius.circular(280),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 1.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Learner\nSign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150),
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Learner',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Learner"),
                              onChanged: (val) {
                                setState(() {
                                  email = role;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Email',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "examle@gmail.com"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter an email";
                                } else if (!val.contains("@")) {
                                  return "enter a correct email";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            //Name
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Name',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Enter your names"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter your names";
                                } else if (val.length < 3) {
                                  return "enter your correct name";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                            //subject
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                label: Text(
                                  'Grade',
                                  style: textStyleText(context),
                                ),
                                hintText: "10",
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter your grade";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  grade = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(
                                            Icons.visibility,
                                            color: IconTheme.of(context).color,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: IconTheme.of(context).color,
                                          ),
                                  ),
                                  label: const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1),
                                  ),
                                  hintText: "Enter your password"),
                              obscureText: passwordVisible,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "enter a password greater than 5";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(
                                            Icons.visibility,
                                            color: IconTheme.of(context).color,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: IconTheme.of(context).color,
                                          ),
                                  ),
                                  label: const Text(
                                    'Confirm Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1),
                                  ),
                                  hintText: "confirm your password"),
                              obscureText: passwordVisible,
                              validator: (val) {
                                if (!confirmPassword
                                    .trim()
                                    .contains(password.trim())) {
                                  return "Passwords don't match";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  confirmPassword = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Select My Subjects',
                                  style: textStyleText(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //==============================================//
                                  //====================== Row one ================//
                                  SizedBox(
                                    child: Column(
                                      children: [
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
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? value) =>
                                                  setState(
                                                () {
                                                  //valueChoose1
                                                  valueChoose1 = value;
                                                },
                                              ),
                                            ),
                                            //subject 2 ends
                                            //Teachers name
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData)
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );

                                                List<DropdownMenuItem<String>>
                                                    dropdownItems = [];
                                                snapshot.data?.docs
                                                    .forEach((doc) {
                                                  dropdownItems.add(
                                                    DropdownMenuItem(
                                                      value: doc['uid'] ?? "",
                                                      child: Text(
                                                        doc['name'] ?? "",
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  );
                                                });
                                                return DropdownButton(
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
                                                  },
                                                );
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
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? value) =>
                                                  setState(
                                                () {
                                                  valueChoose2 = value;
                                                },
                                              ),
                                            ),
                                            //subject 2 ends
                                            //Teachers name
                                            StreamBuilder<QuerySnapshot>(
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData)
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );

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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher2,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher2 = newValue!;
                                                    });
                                                  },
                                                );
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
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? value) =>
                                                  setState(
                                                () {
                                                  valueChoose3 = value;
                                                },
                                              ),
                                            ),
                                            //subject 2 ends
                                            //Teachers name
                                            StreamBuilder<QuerySnapshot>(
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
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
                                                );
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
                                              value: valueChoose4,
                                              items: listItem
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher4,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher4 = newValue;
                                                    });
                                                  },
                                                );
                                              },
                                            ),
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
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher5,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher5 = newValue;
                                                    });
                                                  },
                                                );
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
                                              value: valueChoose6,
                                              items: listItem
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher6,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher6 = newValue;
                                                    });
                                                  },
                                                );
                                              },
                                            ),
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
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher7,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher7 = newValue;
                                                    });
                                                  },
                                                );
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
                                              value: valueChoose8,
                                              items: listItem
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher8,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher8 = newValue;
                                                    });
                                                  },
                                                );
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
                                              value: valueChoose9,
                                              items: listItem
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: textStyleText(
                                                            context),
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
                                              stream: teachersRegistered
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                    'loading data',
                                                    style:
                                                        textStyleText(context),
                                                  );
                                                }
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
                                                return DropdownButton(
                                                  hint: Text(
                                                    "Teachers name",
                                                    style:
                                                        textStyleText(context),
                                                  ),
                                                  value: valueTeacher9,
                                                  items: dropdownItems,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueTeacher9 = newValue;
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                            //subject3 ends
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  //================= Row nine ends ============//
                                ],
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
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () async {
                                    //check if the form is validated
                                    if (_formKey.currentState!.validate()) {
                                      signUp();
                                    } else {
                                      snack("Insert all the details required",
                                          context);
                                    }
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: loading
                                      ? SpinKitChasingDots(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        )
                                      : Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      teachersID;
    });
  }

  Future signUp() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

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
      User _user = User(
        email.trim().toLowerCase(),
        uid,
        password.trim(),
        name.trim(),
        grade.trim(),
        documentID,
        role,
        subjects,
        teachersID,
        allSubjects,
      );
      //this should add the registered user to the userData collection with UID
      _user.addUser();

      logger.i(_user.addUser());
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (error == 'email-already-in-use') {
        snack(error.toString(), context);
        logger.i(error.toString());
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if (error == "ERROR_INVALID_EMAIL") {
        snack(error.toString(), context);
      } else if (error == "ERROR_WRONG_PASSWORD") {
        snack(error.toString(), context);
        logger.i(error);
      } else if (error == "ERROR_USER_NOT_FOUND") {
        snack(error.toString(), context);
        logger.i(error);
      } else if (error == "ERROR_USER_DISABLED") {
        snack(error.toString(), context);
      } else if (error == "ERROR_TOO_MANY_REQUESTS") {
        snack(error.toString(), context);
        logger.i(error);
      } else if (error == "ERROR_OPERATION_NOT_ALLOWED") {
        snack(error.toString(), context);
        logger.i(error);
      } else {
        snack(error.toString(), context);
        logger.i(error);
      }
    }
    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
