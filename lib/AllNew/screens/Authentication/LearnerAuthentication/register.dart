import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:yueway/main.dart';

import '../../../model/ConnectionChecker.dart';
import '../../../shared/constants.dart';
import '../Authenticate.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

//A Model to grab and store data
class User {
  final String email;
  final uid;
  final String password;
  final String name;
  final String secondName;
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
    this.secondName,
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
          'secondName': secondName.trim(),
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
  String? valueChoose10;

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
  String? valueTeacher10;

  //String? selectedValue;

  //save the selected strings into these lists
  List<String> subjects = [];
  List<String> teachersID = ["not applicable"];

  Map<String, dynamic> testsMarks = {};
  Map<String, dynamic> assignmentsMarks = {};
  Map<String, dynamic> examMarks = {};
  Map<String, dynamic> addAllMark = {};
  Map<String, dynamic> finalMarks = {};

  //List
  List<String> listItem = [
    "arts and culture",
    "accounting",
    "afrikaans",
    "agriculture",
    "business studies",
    "cat",
    "consumer studies",
    "economic m s",
    "geography",
    "history",
    "isiZulu",
    "life sciences",
    "life orientation",
    "natural sciences",
    "physical sciences",
    "social sciences",
    "siphedi",
    "sisotho",
    "technology",
    "tourism",
    "not applicable",
  ];
  List<String> listMathematicsType = [
    "mathematics",
    "mathematics literacy",
  ];
  List<String> listEnglishType = [
    "english home language",
    "english second additional language",
  ];

  //Strings to store inputs from the user
  String email = '';
  String password = '';
  String confirmPassword = '';
  String uid = '';
  String name = '';
  String secondName = '';
  String grade = '';
  String role = "Learner";
  String documentID = '';
  Map<String, dynamic> allSubjects = {};
  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  // final user = FirebaseAuth.instance.currentUser;
  var user = FirebaseAuth.instance.currentUser;

  bool _isValid = false;

  _validateForm(String selectedItem) {
    _isValid = _formKey.currentState!.validate();

    if (selectedItem == null) {
      setState(() => selectedItem = "Please select an option!");
      _isValid = false;
    }

    if (_isValid) {
      //form is valid
    }
  }

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
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0x0fffffff), Color(0xE7791971)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(280),
                              topLeft: Radius.circular(280),
                            ),
                            child: Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
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
                            style: textStyleText(context).copyWith(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Learner',
                              style: textStyleText(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                    'First Name',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Enter your First name"),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Second Name',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Enter your second name"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter your second name";
                                } else if (val.length < 3) {
                                  return "enter your correct name";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  secondName = val;
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
                                color: Theme.of(context)
                                    .primaryColorLight
                                    .withOpacity(.8),
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
                                                      style: textStyleText(
                                                          context),
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
                                                        " ${doc['secondName']} ${doc['name']}",
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
                                                        //valueTeacher1
                                                        value: valueTeacher1,
                                                        items: dropdownItems,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            //valueTeacher1
                                                            valueTeacher1 =
                                                                newValue;
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
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
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
                                                        " ${doc['secondName']} ${doc['name']}",
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
                                                      value: valueTeacher2,
                                                      items: dropdownItems,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          valueTeacher2 =
                                                              newValue!;
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
                                                return Text(
                                                    'Error retrieving names',
                                                    style:
                                                        textStyleText(context));
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
                                                    'No teachers yet',
                                                    style:
                                                        textStyleText(context),
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
                                                          " ${doc['secondName']} ${doc['name']}",
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
                                                        value: valueTeacher3,
                                                        items: dropdownItems,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            valueTeacher3 =
                                                                newValue!;
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
                                                      style: textStyleText(
                                                          context));
                                                }
                                                //subject3 end,
                                              }),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No teachers yet',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];

                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher4,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher4 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher4 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                              //subject3 ends
                                            ],
                                          ),
                                          //////////////////////new Streams////////
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No Teacher',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];

                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher5,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher5 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher5 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                              //subject3 ends
                                            ],
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No teacher yet',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];

                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher6,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher6 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher6 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                              //subject3 ends
                                            ],
                                          ),
                                          //      /////////////////////////////////////////////////////////////////////
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No teacher yet',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];

                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher7,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher7 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher7 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                              //subject3 ends
                                            ],
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No teacher yet',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];

                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher8,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher8 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher8 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                              //subject3 ends
                                            ],
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceEvenly,
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
                                                        DropdownMenuItem<
                                                            String>>(
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
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                        'No teacher yet',
                                                        style: textStyleText(
                                                            context),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<
                                                              DropdownMenuItem<
                                                                  String>>
                                                          dropdownItems = [];
                                                      snapshot.data?.docs
                                                          .forEach((doc) {
                                                        dropdownItems.add(
                                                          DropdownMenuItem(
                                                            value: doc['uid'],
                                                            child: Text(
                                                              " ${doc['secondName']} ${doc['name']}",
                                                              style:
                                                                  textStyleText(
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
                                                            style:
                                                                textStyleText(
                                                                    context),
                                                          ),
                                                        ),
                                                      );
                                                      return Column(
                                                        children: [
                                                          DropdownButton(
                                                            hint: Text(
                                                              "Teachers name",
                                                              style:
                                                                  textStyleText(
                                                                      context),
                                                            ),
                                                            value:
                                                                valueTeacher9,
                                                            items:
                                                                dropdownItems,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                valueTeacher9 =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                          if (valueTeacher9 ==
                                                              null)
                                                            const Text(
                                                              "Please select a teachers name",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                          'Error retrieving names',
                                                          style: textStyleText(
                                                              context));
                                                    }
                                                  }),
                                            ],
                                          ),
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
                                            value: valueChoose10,
                                            items: listItem
                                                .map<DropdownMenuItem<String>>(
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
                                                valueChoose10 = value;
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
                                                    'No teacher yet',
                                                    style:
                                                        textStyleText(context),
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
                                                          " ${doc['secondName']} ${doc['name']}",
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
                                                        value: valueTeacher10,
                                                        items: dropdownItems,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            valueTeacher10 =
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
                                                      style: textStyleText(
                                                          context));
                                                }
                                              }),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ]),
                                    //================= Row nine ends ============//
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await signUp()
                                                .then(
                                                  (value) async => snack(
                                                      "Account created, now sign in.",
                                                      context),
                                                )
                                                .whenComplete(
                                                  () =>
                                                      Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Authenticate(),
                                                    ),
                                                  ),
                                                );
                                          } else {
                                            snack(
                                                "Insert all the details required",
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
                                                style: textStyleText(context)
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                          style: textStyleText(context)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                ],
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

    // setState(() {
    //   teachersID;
    // });
  }

  Future signUp() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.toLowerCase().trim(), password: password.trim());

      final FirebaseAuth auth = FirebaseAuth.instance;
      final userCurrent = auth.currentUser!.uid;
      uid = userCurrent.toString();

      subjects.add(valueChoose1!);
      subjects.add(valueChoose2!);
      subjects.add(valueChoose3!);
      subjects.add(valueChoose4!);
      subjects.add(valueChoose5!);
      subjects.add(valueChoose6!);
      subjects.add(valueChoose7!);
      subjects.add(valueChoose8!);
      subjects.add(valueChoose9!);
      subjects.add(valueChoose10!);



      teachersID.add(valueTeacher1!);
      teachersID.add(valueTeacher2!);
      teachersID.add(valueTeacher3!);
      teachersID.add(valueTeacher4!);
      teachersID.add(valueTeacher5!);
      teachersID.add(valueTeacher6!);
      teachersID.add(valueTeacher7!);
      teachersID.add(valueTeacher8!);
      teachersID.add(valueTeacher10!);

      User _user = User(
        email.trim().toLowerCase(),
        uid,
        password.trim(),
        name.trim(),
        secondName.trim(),
        grade.trim(),
        documentID,
        role,
        subjects,
        teachersID,
        allSubjects,
      );

      //add user to the database
      _user.addUser();
      logger.i("user added");
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const LearnerHome()));

      //catch exceptions
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snack("your password is weak", context);
      } else if (e.code == 'email-already-in-use') {
        snack("email already in use", context);
      }
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
    setState(() {
      loading = false;
    });
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
