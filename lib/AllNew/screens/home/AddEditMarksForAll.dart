import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String subjectName = "";

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
    widget.getMarksFromFirestore.clear();
    super.dispose();
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
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
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
                      //var allSubjects = snapshot.data!["allSubjects"];

                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                "Add marks For every Term",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                              children: <Widget>[
                                ////////////// Term One Marks ///////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: Text(
                                        "Term One",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: Text(
                                              "Test Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                                hintText:
                                                                    "Test 1",
                                                                label: Text(
                                                                  "Test Mark 1",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                )),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label: Text(
                                                        "Test Mark 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label: Text(
                                                        "Test Mark 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label: Text(
                                                        "Test Mark 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            try {
                                                              setState(() {
                                                                loading = true;
                                                                subjectName = widget
                                                                    .subjectName;
                                                              });
                                                              ////////////TODO Term 1 tests////////

                                                              //check if the document exits
                                                              if (allSubjects !=
                                                                  null) {
                                                                //go to the field in the document
                                                                //check if the data is a List
                                                                if (allSubjects
                                                                    is List) {
                                                                  bool
                                                                      foundCatIndex =
                                                                      false;
                                                                  //for every item in the list
                                                                  for (var item
                                                                      in allSubjects) {
                                                                    //if the item is==$userSubject
                                                                    if (item.containsKey(
                                                                        subjectName)) {
                                                                      //index is present
                                                                      foundCatIndex =
                                                                          true;

                                                                      var itemIndex =
                                                                          allSubjects
                                                                              .indexOf(item);
                                                                      //get the teacher subject from the list
                                                                      logger.i(
                                                                          "$subjectName Found Subject at index $itemIndex");

                                                                      logger.i(allSubjects[itemIndex][subjectName]["0"]
                                                                              [
                                                                              "tests"]
                                                                          [
                                                                          "test1mark"]);
                                                                      ////////////////////////////////

                                                                      allSubjects[itemIndex][subjectName]["0"]["tests"]
                                                                              [
                                                                              "test1mark"] =
                                                                          testOneMark
                                                                              .text;

                                                                      allSubjects[itemIndex][subjectName]["0"]["tests"]
                                                                              [
                                                                              "test2mark"] =
                                                                          testTwoMark
                                                                              .text;
                                                                      allSubjects[itemIndex][subjectName]["0"]["tests"]
                                                                              [
                                                                              "test3mark"] =
                                                                          testThreeMark
                                                                              .text;
                                                                      allSubjects[itemIndex][subjectName]["0"]["tests"]
                                                                              [
                                                                              "test4mark"] =
                                                                          testFourMark
                                                                              .text;

                                                                      // Update the "allSubjects" field with the modified array
                                                                      await identityDocument
                                                                          .set({
                                                                        'allSubjects':
                                                                            allSubjects
                                                                      }, SetOptions(merge: true)).then(
                                                                        (value) => Fluttertoast.showToast(
                                                                            backgroundColor:
                                                                                Theme.of(context).primaryColor,
                                                                            msg: "Added marks"),
                                                                      );

                                                                      // do something with the 'CAT' data, such as print it
                                                                      break;
                                                                    }
                                                                  }
                                                                  //if the teacherSubject is not found

                                                                  if (!foundCatIndex) {
                                                                    // handle case where 'CAT' index does not exist
                                                                    logger.i(
                                                                        'No $subjectName index found');
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content: Text(
                                                                          'The learner is not registered to do $subjectName'),
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              1),
                                                                    ));
                                                                  }
                                                                  //check if the stored data is a Map
                                                                } else if (allSubjects
                                                                        is Map &&
                                                                    allSubjects
                                                                        .containsKey(
                                                                            subjectName)) {
                                                                  //store the teacherSubject here
                                                                  var teacherSubject =
                                                                      allSubjects[
                                                                          subjectName];
                                                                  // do something with the 'CAT' data, such as print it
                                                                  logger.i(
                                                                      teacherSubject);
                                                                } else {
                                                                  // handle case where teacherSubject index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                }
                                                              } else {
                                                                // handle case where document does not exist
                                                                logger.i(
                                                                    'Document does not exist');
                                                              }

                                                              setState(() {
                                                                loading = false;
                                                              });
                                                            } catch (e) {
                                                              logger.i(e);
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg: e
                                                                          .toString());
                                                            }
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
                                            title: Text(
                                              "Assignment Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: Text(
                                                        "Assignment 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: Text(
                                                        "Assignment 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: Text(
                                                        "Assignment 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: Text(
                                                        "Assignment 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO term 1 Assignments////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["0"]["assignments"]
                                                                            [
                                                                            "assignment1mark"] =
                                                                        assignmentOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["0"]["assignments"]
                                                                            [
                                                                            "assignment2mark"] =
                                                                        assignmentTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["0"]["assignments"]
                                                                            [
                                                                            "assignment3mark"] =
                                                                        assignmentThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["0"]["assignments"]
                                                                            [
                                                                            "assignment4mark"] =
                                                                        assignmentFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

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
                                            title: Text(
                                              "Exam Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label: Text(
                                                        "Exam 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label: Text(
                                                        "Exam 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                              subjectName = widget
                                                                  .subjectName;
                                                            });
                                                            ////////////TODO term 1 Exams ////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["0"]["exams"]
                                                                            [
                                                                            "exam1mark"] =
                                                                        examOneMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["0"]["exams"]
                                                                            [
                                                                            "exam2mark"] =
                                                                        examTwoMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
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
                                //////////////////// TODO Term 2 ///////////
                                /////////////  Term Two Marks /////////////
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ExpansionTile(
                                      title: Text(
                                        "Term Two",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: Text(
                                              "Test Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label: Text(
                                                        "Test 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label: Text(
                                                        "Test 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label: Text(
                                                        "Test 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label: Text(
                                                        "Test 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 tests////////
//check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    //get the teacher subject from the list
                                                                    logger.i(
                                                                        "$subjectName Found Subject at index $itemIndex");

                                                                    logger.i(allSubjects[itemIndex][subjectName]["0"]
                                                                            [
                                                                            "tests"]
                                                                        [
                                                                        "test1mark"]);
                                                                    ////////////////////////////////

                                                                    allSubjects[itemIndex][subjectName]["1"]["tests"]
                                                                            [
                                                                            "test1mark"] =
                                                                        termTwoTestOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["1"]["tests"]
                                                                            [
                                                                            "test2mark"] =
                                                                        termTwoTestTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["1"]["tests"]
                                                                            [
                                                                            "test3mark"] =
                                                                        termTwoTestThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["1"]["tests"]
                                                                            [
                                                                            "test4mark"] =
                                                                        termTwoTestFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }

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
                                            title: Text(
                                              "Assignment Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: Text(
                                                        "Assignment 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: Text(
                                                        "Assignment 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: Text(
                                                        "Assignment 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: Text(
                                                        "Assignment 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 assignments////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["1"]["assignments"]
                                                                            [
                                                                            "assignment1mark"] =
                                                                        termTwoAssignmentOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["1"]["assignments"]
                                                                            [
                                                                            "assignment2mark"] =
                                                                        termTwoAssignmentTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["1"]["assignments"]
                                                                            [
                                                                            "assignment3mark"] =
                                                                        termTwoAssignmentThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["1"]["assignments"]
                                                                            [
                                                                            "assignment4mark"] =
                                                                        termTwoAssignmentFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

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
                                            title: Text(
                                              "Exam Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label: Text(
                                                        "Exam 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label: Text(
                                                        "Exam 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 2 Exam////////
                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["1"]["exams"]
                                                                            [
                                                                            "exam1mark"] =
                                                                        termTwoExamOneMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["1"]["exams"]
                                                                            [
                                                                            "exam2mark"] =
                                                                        termTwoExamTwoMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) =>
                                                                          Fluttertoast.showToast(
                                                                              msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
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
                                      title: Text(
                                        "Term Three",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: Text(
                                              "Test Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label: Text(
                                                        "Test 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label: Text(
                                                        "Test 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label: Text(
                                                        "Test 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label: Text(
                                                        "Test 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 test////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);

                                                                    allSubjects[itemIndex][subjectName]["2"]["tests"]
                                                                            [
                                                                            "test1mark"] =
                                                                        termThreeTestOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["2"]["tests"]
                                                                            [
                                                                            "test2mark"] =
                                                                        termThreeTestTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["2"]["tests"]
                                                                            [
                                                                            "test3mark"] =
                                                                        termThreeTestThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["2"]["tests"]
                                                                            [
                                                                            "test4mark"] =
                                                                        termThreeTestFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
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
                                            title: Text(
                                              "Assignment Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: Text(
                                                        "Assignment 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: Text(
                                                        "Assignment 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: Text(
                                                        "Assignment 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: Text(
                                                        "Assignment 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 assignments////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["2"]["assignments"]
                                                                            [
                                                                            "assignment1mark"] =
                                                                        termThreeAssignmentOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["2"]["assignments"]
                                                                            [
                                                                            "assignment2mark"] =
                                                                        termThreeAssignmentTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["2"]["assignments"]
                                                                            [
                                                                            "assignment3mark"] =
                                                                        termThreeAssignmentThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["2"]["assignments"]
                                                                            [
                                                                            "assignment4mark"] =
                                                                        termThreeAssignmentFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

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
                                            title: Text(
                                              "Exam Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label: Text(
                                                        "Exam 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label: Text(
                                                        "Exam 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 3 exams////////
//check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["2"]["exams"]
                                                                            [
                                                                            "exam1mark"] =
                                                                        termThreeExamOneMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["2"]["exams"]
                                                                            [
                                                                            "exam2mark"] =
                                                                        termThreeExamTwoMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  snack(
                                                                      "Leaner is not registered to do $subjectName",
                                                                      context);
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }

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
                                      title: Text(
                                        "Term Four",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10, right: 20),
                                          child: ExpansionTile(
                                            title: Text(
                                              "Test Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 1",
                                                      label: Text(
                                                        "Test 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 2",
                                                      label: Text(
                                                        "Test 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 3",
                                                      label: Text(
                                                        "Test 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Test 4",
                                                      label: Text(
                                                        "Test 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 tests////////

                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);

                                                                    allSubjects[itemIndex][subjectName]["3"]["tests"]
                                                                            [
                                                                            "test1mark"] =
                                                                        termFourTestOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["3"]["tests"]
                                                                            [
                                                                            "test2mark"] =
                                                                        termFourTestTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["3"]["tests"]
                                                                            [
                                                                            "test3mark"] =
                                                                        termFourTestThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["3"]["tests"]
                                                                            [
                                                                            "test4mark"] =
                                                                        termFourTestFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) =>
                                                                          Fluttertoast
                                                                              .showToast(
                                                                        backgroundColor:
                                                                            Theme.of(context).primaryColor,
                                                                        msg:
                                                                            "Added marks",
                                                                      ),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    backgroundColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                    content:
                                                                        Text(
                                                                      'The learner is not registered to do $subjectName',
                                                                    ),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }

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
                                            title: Text(
                                              "Assignment Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 1",
                                                      label: Text(
                                                        "Assignment 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 2",
                                                      label: Text(
                                                        "Assignment 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 3",
                                                      label: Text(
                                                        "Assignment 3",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Assignment 4",
                                                      label: Text(
                                                        "Assignment 4",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 assignments////////
                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["3"]["assignments"]
                                                                            [
                                                                            "assignment1mark"] =
                                                                        termFourAssignmentOneMark
                                                                            .text;

                                                                    allSubjects[itemIndex][subjectName]["3"]["assignments"]
                                                                            [
                                                                            "assignment2mark"] =
                                                                        termFourAssignmentTwoMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["3"]["assignments"]
                                                                            [
                                                                            "assignment3mark"] =
                                                                        termFourAssignmentThreeMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["3"]["assignments"]
                                                                            [
                                                                            "assignment4mark"] =
                                                                        termFourAssignmentFourMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }
                                                            // Update the "allSubjects" field with the modified array
                                                            identityDocument.set(
                                                                {
                                                                  'allSubjects':
                                                                      allSubjects
                                                                },
                                                                SetOptions(
                                                                    merge:
                                                                        true));
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
                                            title: Text(
                                              "Exam Marks",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 1",
                                                      label: Text(
                                                        "Exam 1",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        textInputDecoration
                                                            .copyWith(
                                                      hintText: "Exam 2",
                                                      label: Text(
                                                        "Exam 2",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    style:
                                                        textStyleText(context),
                                                    textAlign: TextAlign.center,
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
                                                    height: 10,
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
                                                              : Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            ////////////TODO Term 4 exam////////
                                                            //check if the document exits
                                                            if (allSubjects !=
                                                                null) {
                                                              //go to the field in the document
                                                              //check if the data is a List
                                                              if (allSubjects
                                                                  is List) {
                                                                bool
                                                                    foundCatIndex =
                                                                    false;
                                                                //for every item in the list
                                                                for (var item
                                                                    in allSubjects) {
                                                                  //if the item is==$userSubject
                                                                  if (item.containsKey(
                                                                      subjectName)) {
                                                                    //index is present
                                                                    foundCatIndex =
                                                                        true;

                                                                    var itemIndex =
                                                                        allSubjects
                                                                            .indexOf(item);
                                                                    logger.i(
                                                                        itemIndex);

                                                                    allSubjects[itemIndex][subjectName]["3"]["exams"]
                                                                            [
                                                                            "exam1mark"] =
                                                                        termFourExamOneMark
                                                                            .text;
                                                                    allSubjects[itemIndex][subjectName]["3"]["exams"]
                                                                            [
                                                                            "exam2mark"] =
                                                                        termFourExamTwoMark
                                                                            .text;

                                                                    // Update the "allSubjects" field with the modified array
                                                                    await identityDocument
                                                                        .set({
                                                                      'allSubjects':
                                                                          allSubjects
                                                                    }, SetOptions(merge: true)).then(
                                                                      (value) => Fluttertoast.showToast(
                                                                          backgroundColor:
                                                                              Theme.of(context).primaryColor,
                                                                          msg: "Added marks"),
                                                                    );

                                                                    // do something with the 'CAT' data, such as print it
                                                                    break;
                                                                  }
                                                                }
                                                                //if the teacherSubject is not found

                                                                if (!foundCatIndex) {
                                                                  // handle case where 'CAT' index does not exist
                                                                  logger.i(
                                                                      'No $subjectName index found');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'The learner is not registered to do $subjectName'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ));
                                                                }
                                                                //check if the stored data is a Map
                                                              } else if (allSubjects
                                                                      is Map &&
                                                                  allSubjects
                                                                      .containsKey(
                                                                          subjectName)) {
                                                                //store the teacherSubject here
                                                                var teacherSubject =
                                                                    allSubjects[
                                                                        subjectName];
                                                                // do something with the 'CAT' data, such as print it
                                                                logger.i(
                                                                    teacherSubject);
                                                              } else {
                                                                // handle case where teacherSubject index does not exist
                                                                logger.i(
                                                                    'No $subjectName index found');
                                                              }
                                                            } else {
                                                              // handle case where document does not exist
                                                              logger.i(
                                                                  'Document does not exist');
                                                            }

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
                              ],
                            ),
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
