import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/gradeList/grade12.dart';

import '../../shared/constants.dart';

//get current logged in user
User? user = FirebaseAuth.instance.currentUser;

class AddEditForAll extends StatefulWidget {
  Map<String, dynamic> getMarksFromFirestore = {};
  String subjectName = "";
  String documentIDToEdit = "";

  AddEditForAll({
    Key? key,
    required this.getMarksFromFirestore,
    required this.subjectName,
    required this.documentIDToEdit,
  }) : super(key: key);
  static const routeName = '/addEditAll';

  @override
  State<AddEditForAll> createState() => _AddEditForAllState();
}

class _AddEditForAllState extends State<AddEditForAll> {
  //get the collection of the document
  final CollectionReference learnersCollection =
      FirebaseFirestore.instance.collection('learnersData');

  //how to uses these boxes 40 times without duplicate?
  //////////////////////////////////////////////////////////
  //tests 1 term 1
  TextEditingController testOneMark = TextEditingController();
  TextEditingController testTwoMark = TextEditingController();
  TextEditingController testThreeMark = TextEditingController();
  TextEditingController testFourMark = TextEditingController();

  //assignment 1 term 1
  TextEditingController assignmentOneMark = TextEditingController();
  TextEditingController assignmentTwoMark = TextEditingController();
  TextEditingController assignmentThreeMark = TextEditingController();
  TextEditingController assignmentFourMark = TextEditingController();

  //exam 1 term 1
  TextEditingController examOneMark = TextEditingController();
  TextEditingController examTwoMark = TextEditingController();

  ///////////////////////end of term 1////////////////////////////
  ////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////
  //////////////////////  Term Two tests 1 //////////////////////
  TextEditingController termTwoTestOneMark = TextEditingController();
  TextEditingController termTwoTestTwoMark = TextEditingController();
  TextEditingController termTwoTestThreeMark = TextEditingController();
  TextEditingController termTwoTestFourMark = TextEditingController();

  //assignment 1 term 2
  TextEditingController termTwoAssignmentOneMark = TextEditingController();
  TextEditingController termTwoAssignmentTwoMark = TextEditingController();
  TextEditingController termTwoAssignmentThreeMark = TextEditingController();
  TextEditingController termTwoAssignmentFourMark = TextEditingController();

  //exam 1 term 2
  TextEditingController termTwoExamOneMark = TextEditingController();
  TextEditingController termTwoExamTwoMark = TextEditingController();

  ///////////////////////end of term 2////////////////////////////
  ////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////
  //////////////////////  Term Two tests 1 //////////////////////
  TextEditingController termThreeTestOneMark = TextEditingController();
  TextEditingController termThreeTestTwoMark = TextEditingController();
  TextEditingController termThreeTestThreeMark = TextEditingController();
  TextEditingController termThreeTestFourMark = TextEditingController();

  //assignment 1 term 2
  TextEditingController termThreeAssignmentOneMark = TextEditingController();
  TextEditingController termThreeAssignmentTwoMark = TextEditingController();
  TextEditingController termThreeAssignmentThreeMark = TextEditingController();
  TextEditingController termThreeAssignmentFourMark = TextEditingController();

  //exam 1 term 2
  TextEditingController termThreeExamOneMark = TextEditingController();
  TextEditingController termThreeExamTwoMark = TextEditingController();

  ///////////////////////end of term 2////////////////////////////
  ////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////
  //////////////////////  Term Two tests 1 //////////////////////
  TextEditingController termFourTestOneMark = TextEditingController();
  TextEditingController termFourTestTwoMark = TextEditingController();
  TextEditingController termFourTestThreeMark = TextEditingController();
  TextEditingController termFourTestFourMark = TextEditingController();

  //assignment 1 term 2
  TextEditingController termFourAssignmentOneMark = TextEditingController();
  TextEditingController termFourAssignmentTwoMark = TextEditingController();
  TextEditingController termFourAssignmentThreeMark = TextEditingController();
  TextEditingController termFourAssignmentFourMark = TextEditingController();

  //exam 1 term 2
  TextEditingController termFourExamOneMark = TextEditingController();
  TextEditingController termFourExamTwoMark = TextEditingController();

  ///////////////////////end of term 2////////////////////////////
  ////////////////////////////////////////////////////////////////

  //on click loader
  bool loading = false;

  @override
  void initState() {
    widget.getMarksFromFirestore;
    widget.documentIDToEdit;
    super.initState();
    assignData(
      widget.subjectName,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.getMarksFromFirestore.clear();
    widget.subjectName = "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference identityDocument =
        learnersCollection.doc(widget.documentIDToEdit);
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                navigate(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        title: const Text("Add or Edit Marks"),
        titleSpacing: 2,
        centerTitle: false,
        elevation: .5,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream: identityDocument.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var allSubjects = snapshot.data!.get('allSubjects');

                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ExpansionTile(
                              title: const Text(
                                "Add marks For every Term",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              children: <Widget>[
                                ////////////// Term One Marks ///////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: const Text("Term One"),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Test Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText: "Test 1",
                                                            label: const Text(
                                                                "Test Mark 1")),
                                                    controller: testOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        testOneMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label: const Text(
                                                          "Test Mark 2"),
                                                    ),
                                                    controller: testTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        testTwoMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label: const Text(
                                                          "Test Mark 3"),
                                                    ),
                                                    controller: testThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        testThreeMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label: const Text(
                                                          "Test Mark 4"),
                                                    ),
                                                    controller: testFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        testFourMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 1 tests////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "0"]["tests"]
                                                                ["test1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test1mark"] =
                                                                testOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test2mark"] =
                                                                testTwoMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test3mark"] =
                                                                testThreeMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test4mark"] =
                                                                testFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "0"]["tests"]
                                                                ["test1mark"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title:
                                                const Text("Assignment Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: const Text(
                                                          "Assignment 1"),
                                                    ),
                                                    controller:
                                                        assignmentOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        assignmentOneMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: const Text(
                                                          "Assignment 2"),
                                                    ),
                                                    controller:
                                                        assignmentTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        assignmentTwoMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: const Text(
                                                          "Assignment 3"),
                                                    ),
                                                    controller:
                                                        assignmentThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        assignmentThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: const Text(
                                                          "Assignment 4"),
                                                    ),
                                                    controller:
                                                        assignmentFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        assignmentFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO term 1 Assignments////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]["0"]
                                                                    [
                                                                    "assignments"]
                                                                [
                                                                "assignment1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment1mark"] =
                                                                assignmentOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment2mark"] =
                                                                assignmentTwoMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment3mark"] =
                                                                assignmentThreeMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment4mark"] =
                                                                assignmentFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    ["0"][
                                                                "assignments"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Exam Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label:
                                                          const Text("Exam 1"),
                                                    ),
                                                    controller: examOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        examOneMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label:
                                                          const Text("Exam 2"),
                                                    ),
                                                    controller: examTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        examTwoMark.text =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO term 1 Exams ////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "0"]["exams"]
                                                                ["exam1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam1mark"] =
                                                                examOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "0"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam2mark"] =
                                                                examTwoMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["0"]["exams"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                                ////////////// Term One End Marks ///////////
                                //////////////////// TODO Term 4 ///////////
                                /////////////  Term Two Marks /////////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: const Text("Term Two"),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Test Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label:
                                                          const Text("Test 1"),
                                                    ),
                                                    controller:
                                                        termTwoTestOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoTestOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label:
                                                          const Text("Test 2"),
                                                    ),
                                                    controller:
                                                        termTwoTestTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoTestTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label:
                                                          const Text("Test 3"),
                                                    ),
                                                    controller:
                                                        termTwoTestThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoTestThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label:
                                                          const Text("Test 4"),
                                                    ),
                                                    controller:
                                                        termTwoTestFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoTestFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 tests////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "1"]["tests"]
                                                                ["test1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test1mark"] =
                                                                termTwoTestOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test2mark"] =
                                                                termTwoTestTwoMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test3mark"] =
                                                                termTwoTestThreeMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test4mark"] =
                                                                termTwoTestFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["1"]["tests"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title:
                                                const Text("Assignment Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: const Text(
                                                          "Assignment 1"),
                                                    ),
                                                    controller:
                                                        termTwoAssignmentOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoAssignmentOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: const Text(
                                                          "Assignment 2"),
                                                    ),
                                                    controller:
                                                        termTwoAssignmentTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoAssignmentTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: const Text(
                                                          "Assignment 3"),
                                                    ),
                                                    controller:
                                                        termTwoAssignmentThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoAssignmentThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: const Text(
                                                          "Assignment 4"),
                                                    ),
                                                    controller:
                                                        termTwoAssignmentFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoAssignmentFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 assignments////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]["1"]
                                                                    [
                                                                    "assignments"]
                                                                ["test1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment1mark"] =
                                                                termTwoAssignmentOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment2mark"] =
                                                                termTwoAssignmentTwoMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment3mark"] =
                                                                termTwoAssignmentThreeMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment4mark"] =
                                                                termTwoAssignmentFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    ["1"]
                                                                ["assignment"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Exam Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label:
                                                          const Text("Exam 1"),
                                                    ),
                                                    controller:
                                                        termTwoExamOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoExamTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label:
                                                          const Text("Exam 2"),
                                                    ),
                                                    controller:
                                                        termTwoExamTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termTwoExamTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 Exam////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "1"]["exams"]
                                                                ["exam1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam1mark"] =
                                                                termTwoExamOneMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "1"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam2mark"] =
                                                                termTwoExamTwoMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["1"]["exams"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                                ///////////////// End of term Two //////////////

                                ///////////////// Term Three Marks ///////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: const Text("Term Three"),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Test Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label:
                                                          const Text("Test 1"),
                                                    ),
                                                    controller:
                                                        termThreeTestOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeTestTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label:
                                                          const Text("Test 2"),
                                                    ),
                                                    controller:
                                                        termThreeTestTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeTestTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label:
                                                          const Text("Test 3"),
                                                    ),
                                                    controller:
                                                        termThreeTestThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeTestThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label:
                                                          const Text("Test 4"),
                                                    ),
                                                    controller:
                                                        termThreeTestFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeTestFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 test////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "2"]["tests"]
                                                                ["test1mark"]);
                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test1mark"] =
                                                                termThreeTestOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test2mark"] =
                                                                termThreeTestTwoMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test3mark"] =
                                                                termThreeTestThreeMark
                                                                    .text;
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test4mark"] =
                                                                termThreeTestFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["2"]["tests"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title:
                                                const Text("Assignment Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: const Text(
                                                          "Assignment 1"),
                                                    ),
                                                    controller:
                                                        termThreeAssignmentOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeAssignmentOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: const Text(
                                                          "Assignment 2"),
                                                    ),
                                                    controller:
                                                        termThreeAssignmentTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeAssignmentTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: const Text(
                                                          "Assignment 3"),
                                                    ),
                                                    controller:
                                                        termThreeAssignmentThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeAssignmentThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: const Text(
                                                          "Assignment 4"),
                                                    ),
                                                    controller:
                                                        termThreeAssignmentFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeAssignmentFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 assignments////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]["2"]
                                                                    [
                                                                    "assignments"]
                                                                [
                                                                "assignment1mark"]);

                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';
                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment1mark"] =
                                                                termThreeAssignmentOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment2mark"] =
                                                                termThreeAssignmentTwoMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment3mark"] =
                                                                termThreeAssignmentThreeMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment4mark"] =
                                                                termThreeAssignmentFourMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    ["2"][
                                                                "assignments"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Exam Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label:
                                                          const Text("Exam 1"),
                                                    ),
                                                    controller:
                                                        termThreeExamOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeExamOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label:
                                                          const Text("Exam 2"),
                                                    ),
                                                    controller:
                                                        termThreeExamTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termThreeExamTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 exams////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "2"]["exams"]
                                                                ["exam1mark"]);

                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam1mark"] =
                                                                termThreeExamOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "2"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam2mark"] =
                                                                termThreeExamTwoMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["2"]["exams"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                                ////////////// End of Term Three////////////////

                                /////////////////  Term Four Marks  ////////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: const Text("Term Four"),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Test Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label:
                                                          const Text("Test 1"),
                                                    ),
                                                    controller:
                                                        termFourTestOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourTestOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label:
                                                          const Text("Test 2"),
                                                    ),
                                                    controller:
                                                        termFourTestTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourTestTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label:
                                                          const Text("Test 3"),
                                                    ),
                                                    controller:
                                                        termFourTestThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourTestThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label:
                                                          const Text("Test 2"),
                                                    ),
                                                    controller:
                                                        termFourTestFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourTestFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 tests////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    [
                                                                    "3"]["tests"]
                                                                ["test1mark"]);

                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test1mark"] =
                                                                termFourTestOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test2mark"] =
                                                                termFourTestTwoMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test4mark"] =
                                                                termFourTestFourMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "tests"]
                                                                    [
                                                                    "test3mark"] =
                                                                termFourTestThreeMark
                                                                    .text;
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["2"]["tests"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title:
                                                const Text("Assignment Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: const Text(
                                                          "Assignment 1"),
                                                    ),
                                                    controller:
                                                        termFourAssignmentOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourAssignmentOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: const Text(
                                                          "Assignment 2"),
                                                    ),
                                                    controller:
                                                        termFourAssignmentTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourAssignmentTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: const Text(
                                                          "Assignment 3"),
                                                    ),
                                                    controller:
                                                        termFourAssignmentThreeMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourAssignmentThreeMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: const Text(
                                                          "Assignment 4"),
                                                    ),
                                                    controller:
                                                        termFourAssignmentFourMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourAssignmentFourMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 assignments////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]["3"]
                                                                    [
                                                                    "assignments"]
                                                                [
                                                                "assignment1mark"]);

                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment1mark"] =
                                                                termFourAssignmentOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment2mark"] =
                                                                termFourAssignmentTwoMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment3mark"] =
                                                                termFourAssignmentThreeMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "assignments"]
                                                                    [
                                                                    "assignment4mark"] =
                                                                termFourAssignmentFourMark
                                                                    .text;
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                            0][
                                                                        widget
                                                                            .subjectName]
                                                                    ["3"][
                                                                "assignments"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: const Text("Exam Marks"),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label:
                                                          const Text("Exam 1"),
                                                    ),
                                                    controller:
                                                        termFourExamOneMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourExamOneMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label:
                                                          const Text("Exam 2"),
                                                    ),
                                                    controller:
                                                        termFourExamTwoMark,
                                                    onSaved: (value) {
                                                      //Do something with the user input.
                                                      setState(() {
                                                        termFourExamTwoMark
                                                            .text = value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      MaterialButton(
                                                          child: loading
                                                              ? const SpinKitChasingDots(
                                                                  color: Colors
                                                                      .purple,
                                                                )
                                                              : const Text(
                                                                  "Update"),
                                                          onPressed: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 assignments////////

                                                            logger
                                                                .i(allSubjects);

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["3"]["exams"]);

                                                            // Make the necessary changes to the "test1mark" field
                                                            //allSubjects['CAT']['0']['tests']['test1mark'] = '100';

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam1mark"] =
                                                                termFourExamOneMark
                                                                    .text;

                                                            allSubjects[0][widget.subjectName]
                                                                            [
                                                                            "3"]
                                                                        [
                                                                        "exams"]
                                                                    [
                                                                    "exam2mark"] =
                                                                termFourExamTwoMark
                                                                    .text;

                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                            logger.i(allSubjects[
                                                                        0][
                                                                    widget
                                                                        .subjectName]
                                                                ["3"]["exams"]);

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                        child: Text(
                      'Document does not exist',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ));
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  //gets data from firestore for term 1 tests, assignments, and exams
  assignData(String userSubject) {
    Map<String, dynamic> newMap = {};

    setState(() {
      //Testing
      logger.i(userSubject);
      //Adding data to a newList
      newMap[widget.subjectName] = widget.getMarksFromFirestore;
      //Testing
      logger.i(newMap);
      logger.i(newMap[userSubject][userSubject]["0"]);

      //store the position of the data to access from the list
      var accessMapData = newMap[userSubject][userSubject];

      //////////////////TODO Term ONE////////////////////
      //tests 1 Term 1
      testOneMark.text = accessMapData["0"]["tests"]["test1mark"] ?? "0";
      testTwoMark.text = accessMapData["0"]["tests"]["test2mark"] ?? "0";
      testThreeMark.text = accessMapData["0"]["tests"]["test3mark"] ?? "0";
      testFourMark.text = accessMapData["0"]["tests"]["test4mark"] ?? "0";

      //assignment 1 Term 1
      assignmentOneMark.text =
          accessMapData["0"]["assignments"]["assignment1mark"] ?? "0";
      assignmentTwoMark.text =
          accessMapData["0"]["assignments"]["assignment2mark"] ?? "0";
      assignmentThreeMark.text =
          accessMapData["0"]["assignments"]["assignment3mark"] ?? "0";
      assignmentFourMark.text =
          accessMapData["0"]["assignments"]["assignment4mark"] ?? "0";

      //assignment 1 Term 1
      examOneMark.text = accessMapData["0"]["exams"]["exam1mark"] ?? "0";
      examTwoMark.text = accessMapData["0"]["exams"]["exam2mark"] ?? "0";
      //////////////////// End of Term ONE/////////////////////////////

      //////////////////TODO Term Two////////////////////
      //tests 1 Term 2
      termTwoTestOneMark.text = accessMapData["1"]["tests"]["test1mark"] ?? "0";
      termTwoTestTwoMark.text = accessMapData["1"]["tests"]["test2mark"] ?? "0";
      termTwoTestThreeMark.text =
          accessMapData["1"]["tests"]["test3mark"] ?? "0";
      termTwoTestFourMark.text =
          accessMapData["1"]["tests"]["test4mark"] ?? "0";

      //assignment 1 Term 2
      termTwoAssignmentOneMark.text =
          accessMapData["1"]["assignments"]["assignment1mark"] ?? "0";
      termTwoAssignmentTwoMark.text =
          accessMapData["1"]["assignments"]["assignment2mark"] ?? "0";
      termTwoAssignmentThreeMark.text =
          accessMapData["1"]["assignments"]["assignment3mark"] ?? "0";
      termTwoAssignmentFourMark.text =
          accessMapData["1"]["assignments"]["assignment4mark"] ?? "0";

      //assignment 1 Term 2
      termTwoExamOneMark.text = accessMapData["1"]["exams"]["exam1mark"] ?? "0";
      termTwoExamTwoMark.text = accessMapData["1"]["exams"]["exam2mark"] ?? "0";
      ////////////////end of term 2////////////////////////////////////

      //////////////////TODO Term Three ////////////////////
      //tests 1 Term 3
      termThreeTestOneMark.text =
          accessMapData["2"]["tests"]["test1mark"] ?? "0";
      termThreeTestTwoMark.text =
          accessMapData["2"]["tests"]["test2mark"] ?? "0";
      termThreeTestThreeMark.text =
          accessMapData["2"]["tests"]["test3mark"] ?? "0";
      termThreeTestFourMark.text =
          accessMapData["2"]["tests"]["test4mark"] ?? "0";

      //assignment 1 Term 3
      termThreeAssignmentOneMark.text =
          accessMapData["2"]["assignments"]["assignment1mark"] ?? "0";
      termThreeAssignmentTwoMark.text =
          accessMapData["2"]["assignments"]["assignment2mark"] ?? "0";
      termThreeAssignmentThreeMark.text =
          accessMapData["2"]["assignments"]["assignment3mark"] ?? "0";
      termThreeAssignmentFourMark.text =
          accessMapData["2"]["assignments"]["assignment4mark"] ?? "0";

      //assignment 1 Term 3
      termThreeExamOneMark.text =
          accessMapData["2"]["exams"]["exam1mark"] ?? "0";
      termThreeExamTwoMark.text =
          accessMapData["2"]["exams"]["exam2mark"] ?? "0";
      ////////////////end of term THREE////////////////////////////////////

      //////////////////TODO Term Four ////////////////////
      //tests 1 Term 4
      termFourTestOneMark.text =
          accessMapData["3"]["tests"]["test1mark"] ?? "0";
      termFourTestTwoMark.text =
          accessMapData["3"]["tests"]["test2mark"] ?? "0";
      termFourTestThreeMark.text =
          accessMapData["3"]["tests"]["test3mark"] ?? "0";
      termFourTestFourMark.text =
          accessMapData["3"]["tests"]["test4mark"] ?? "0";

      //assignment 1 Term 4
      termFourAssignmentOneMark.text =
          accessMapData["3"]["assignments"]["assignment1mark"] ?? "0";
      termFourAssignmentTwoMark.text =
          accessMapData["3"]["assignments"]["assignment2mark"] ?? "0";
      termFourAssignmentThreeMark.text =
          accessMapData["3"]["assignments"]["assignment3mark"] ?? "0";
      termFourAssignmentFourMark.text =
          accessMapData["3"]["assignments"]["assignment4mark"] ?? "0";

      //assignment 1 Term 4
      termFourExamOneMark.text =
          accessMapData["3"]["exams"]["exam1mark"] ?? "0";
      termFourExamTwoMark.text =
          accessMapData["3"]["exams"]["exam2mark"] ?? "0";
      ////////////////end of term THREE////////////////////////////////////
    });
  }

  //used to lesson duplicate code
  TextFormField textField(String titleHint, String numberEdit) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: titleHint),
      onChanged: (val) {
        setState(() {
          numberEdit = val;
        });
      },
      onSaved: (value) {
        //Do something with the user input.
        setState(() {
          value = numberEdit;
        });
      },
    );
  }
}

//Navigate to the previous page
Future navigate(BuildContext context) {
  return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Grade12()));
}
