import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import 'learnersHome.dart';

class LearnerViewMarks extends StatefulWidget {
  List<dynamic> indexMarks = [];

  LearnerViewMarks({
    Key? key,
    required this.indexMarks,
  }) : super(key: key);

  @override
  State<LearnerViewMarks> createState() => _LearnerViewMarksState();
}

class _LearnerViewMarksState extends State<LearnerViewMarks> {
  List<dynamic> newDataArray = [];

  ///TODO TERM 1///
  String termOneTestMarkOne = "";
  String termOneTestMarkTwo = "";
  String termOneTestMarkThree = "";
  String termOneTestMarkFour = "";

  String termOneAssignmentMarkOne = "";
  String termOneAssignmentMarkTwo = "";
  String termOneAssignmentMarkThree = "";
  String termOneAssignmentMarkFour = "";

  String termOneExamMarkOne = "";
  String termOneExamMarkTwo = "";

  ///TODO TERM 2///
  String termTwoTestMarkOne = "";
  String termTwoTestMarkTwo = "";
  String termTwoTestMarkThree = "";
  String termTwoTestMarkFour = "";

  String termTwoAssignmentMarkOne = "";
  String termTwoAssignmentMarkTwo = "";
  String termTwoAssignmentMarkThree = "";
  String termTwoAssignmentMarkFour = "";

  String termTwoExamMarkOne = "";
  String termTwoExamMarkTwo = "";

  ///TODO TERM 3///
  String termThreeTestMarkOne = "";
  String termThreeTestMarkTwo = "";
  String termThreeTestMarkThree = "";
  String termThreeTestMarkFour = "";

  String termThreeAssignmentMarkOne = "";
  String termThreeAssignmentMarkTwo = "";
  String termThreeAssignmentMarkThree = "";
  String termThreeAssignmentMarkFour = "";

  String termThreeExamMarkOne = "";
  String termThreeExamMarkTwo = "";

  ///TODO TERM 4///
  String termFourTestMarkOne = "";
  String termFourTestMarkTwo = "";
  String termFourTestMarkThree = "";
  String termFourTestMarkFour = "";

  String termFourAssignmentMarkOne = "";
  String termFourAssignmentMarkTwo = "";
  String termFourAssignmentMarkThree = "";
  String termFourAssignmentMarkFour = "";

  String termFourExamMarkTwo = "";
  String termFourExamMarkOne = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      newDataArray = widget.indexMarks;
    });
  }

  @override
  void dispose() {
    widget.indexMarks.clear();
    newDataArray.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///TODO SHOW MARKS Term One///
    termOneTestMarkOne =
        (newDataArray[0]["0"]["tests"]["test1mark"]).toString();
    termOneTestMarkTwo =
        (newDataArray[0]["0"]["tests"]["test2mark"]).toString();
    termOneTestMarkThree =
        (newDataArray[0]["0"]["tests"]["test3mark"]).toString();
    termOneTestMarkFour =
        (newDataArray[0]["0"]["tests"]["test4mark"]).toString();

    //Assignments
    termOneAssignmentMarkOne =
        (newDataArray[0]["0"]["assignments"]["assignment1mark"]).toString();
    termOneAssignmentMarkTwo =
        (newDataArray[0]["0"]["assignments"]["assignment2mark"]).toString();
    termOneAssignmentMarkThree =
        (newDataArray[0]["0"]["assignments"]["assignment3mark"]).toString();
    termOneAssignmentMarkFour =
        (newDataArray[0]["0"]["assignments"]["assignment4mark"]).toString();

    //Exams
    termOneExamMarkOne =
        (newDataArray[0]["0"]["exams"]["exam1mark"]).toString();
    termOneExamMarkTwo =
        (newDataArray[0]["0"]["exams"]["exam2mark"]).toString();

    ///TODO SHOW MARKS Term Two///
    termTwoTestMarkOne =
        (newDataArray[0]["1"]["tests"]["test1mark"]).toString();
    termTwoTestMarkTwo =
        (newDataArray[0]["1"]["tests"]["test2mark"]).toString();
    termTwoTestMarkThree =
        (newDataArray[0]["1"]["tests"]["test3mark"]).toString();
    termTwoTestMarkFour =
        (newDataArray[0]["1"]["tests"]["test4mark"]).toString();

    //Assignments
    termTwoAssignmentMarkOne =
        (newDataArray[0]["1"]["assignments"]["assignment1mark"]).toString();
    termTwoAssignmentMarkTwo =
        (newDataArray[0]["1"]["assignments"]["assignment2mark"]).toString();
    termTwoAssignmentMarkThree =
        (newDataArray[0]["1"]["assignments"]["assignment3mark"]).toString();
    termTwoAssignmentMarkFour =
        (newDataArray[0]["1"]["assignments"]["assignment4mark"]).toString();

    //Exams
    termTwoExamMarkOne =
        (newDataArray[0]["1"]["exams"]["exam1mark"]).toString();
    termTwoExamMarkTwo =
        (newDataArray[0]["1"]["exams"]["exam2mark"]).toString();

    ///TODO SHOW MARKS Term Three///
    termThreeTestMarkOne =
        (newDataArray[0]["2"]["tests"]["test1mark"]).toString();
    termThreeTestMarkTwo =
        (newDataArray[0]["2"]["tests"]["test2mark"]).toString();
    termThreeTestMarkThree =
        (newDataArray[0]["2"]["tests"]["test3mark"]).toString();
    termThreeTestMarkFour =
        (newDataArray[0]["2"]["tests"]["test4mark"]).toString();

    //Assignments
    termThreeAssignmentMarkOne =
        (newDataArray[0]["2"]["assignments"]["assignment1mark"]).toString();
    termThreeAssignmentMarkTwo =
        (newDataArray[0]["2"]["assignments"]["assignment2mark"]).toString();
    termThreeAssignmentMarkThree =
        (newDataArray[0]["2"]["assignments"]["assignment3mark"]).toString();
    termThreeAssignmentMarkFour =
        (newDataArray[0]["2"]["assignments"]["assignment4mark"]).toString();

    //Exams
    termThreeExamMarkOne =
        (newDataArray[0]["2"]["exams"]["exam1mark"]).toString();
    termThreeExamMarkTwo =
        (newDataArray[0]["2"]["exams"]["exam2mark"]).toString();

    ///TODO SHOW MARKS Term Three///
    termFourTestMarkOne =
        (newDataArray[0]["3"]["tests"]["test1mark"]).toString();
    termFourTestMarkTwo =
        (newDataArray[0]["3"]["tests"]["test2mark"]).toString();
    termFourTestMarkThree =
        (newDataArray[0]["3"]["tests"]["test3mark"]).toString();
    termFourTestMarkFour =
        (newDataArray[0]["3"]["tests"]["test4mark"]).toString();

    //Assignments
    termFourAssignmentMarkOne =
        (newDataArray[0]["3"]["assignments"]["assignment1mark"]).toString();
    termFourAssignmentMarkTwo =
        (newDataArray[0]["3"]["assignments"]["assignment2mark"]).toString();
    termFourAssignmentMarkThree =
        (newDataArray[0]["3"]["assignments"]["assignment3mark"]).toString();
    termFourAssignmentMarkFour =
        (newDataArray[0]["3"]["assignments"]["assignment4mark"]).toString();

    //Exams
    termFourExamMarkOne =
        (newDataArray[0]["3"]["exams"]["exam1mark"]).toString();
    termFourExamMarkTwo =
        (newDataArray[0]["3"]["exams"]["exam2mark"]).toString();

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
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0x00cccccc), Color(0xE7791971)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: OutlinedButton(
                    style: buttonRound,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LearnerHome()));
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            "Term One",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Test Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termOneTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneTestMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Assignment Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termOneAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneAssignmentMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Exams Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 2"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termOneExamMarkTwo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///TODO TERM TWO///
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            "Term Two",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Test Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termTwoTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoTestMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Assignment Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termTwoAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoAssignmentMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Exams Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 2"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termTwoExamMarkTwo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///TODO TERM THREE///
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            "Term Three",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Test Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termThreeTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeTestMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Assignment Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termThreeAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              termThreeAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              termThreeAssignmentMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Exams Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 2"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termThreeExamMarkTwo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///TODO TERM Four///
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            "Term Four",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Test Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Test 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termFourTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourTestMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Assignment Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelText("Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Assignment 4"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          labelText(termFourAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              termFourAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourAssignmentMarkFour),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Exams Marks",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText("Exam 2"),
                                        ],
                                      ),
                                    ),
                                    /////TODO ACTUAL MARKS/////
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(termFourExamMarkTwo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
    );
  }

  Text labelText(String labelName) {
    return Text(
      labelName,
      style: TextStyle(
        color: Theme.of(context).primaryColor.withOpacity(.7),
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
  }

  navigateBack() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LearnerHome()));
  }
}
