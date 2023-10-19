import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

class DetailedMarks extends StatefulWidget {
  var indexMarks = {};
  final String subjectName;
  final String nameOfL;

  DetailedMarks(
      {Key? key,
      required this.subjectName,
      required this.nameOfL,
      required this.indexMarks})
      : super(key: key);

  @override
  State<DetailedMarks> createState() => _DetailedMarksState();
}

class _DetailedMarksState extends State<DetailedMarks> {
  var newDataArray = {};

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

  String subjectOfTeacher = "";

  @override
  void initState() {
    super.initState();
    subjectOfTeacher = widget.subjectName;
    newDataArray = widget.indexMarks;

    // Utils.logger.i(
    //     "name of learner\n${widget.nameOfL}\nParsed List\n${widget.subjectName}\n${widget.indexMarks}");
    // Utils.logger.i(
    //     "name of learner\n${widget.nameOfL}instantiated list\n${subjectOfTeacher}\n${newDataArray}");
  }

  @override
  void dispose() {
    // widget.indexMarks.clear();
    // newDataArray.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///TODO SHOW MARKS Term One///
    termOneTestMarkOne =
        newDataArray[subjectOfTeacher][0]["tests"]['test1mark'] ?? "0";
    termOneTestMarkTwo =
        newDataArray[subjectOfTeacher][0]["tests"]['test2mark'] ?? "0";
    termOneTestMarkThree =
        newDataArray[subjectOfTeacher][0]["tests"]['test3mark'] ?? "0";
    termOneTestMarkFour =
        newDataArray[subjectOfTeacher][0]["tests"]['test4mark'] ?? "0";
    //
    // //Assignments
    termOneAssignmentMarkOne = newDataArray[subjectOfTeacher][0]["assignments"]
            ['assignment1mark'] ??
        "0";
    termOneAssignmentMarkTwo = newDataArray[subjectOfTeacher][0]["assignments"]
            ['assignment2mark'] ??
        "0";
    termOneAssignmentMarkThree = newDataArray[subjectOfTeacher][0]
            ["assignments"]['assignment3mark'] ??
        "0";
    termOneAssignmentMarkFour = newDataArray[subjectOfTeacher][0]["assignments"]
            ['assignment4mark'] ??
        "0";
    //
    // //Exams
    termOneExamMarkOne =
        newDataArray[subjectOfTeacher][0]["exams"]['exam1mark'] ?? "0";
    termOneExamMarkTwo =
        newDataArray[subjectOfTeacher][0]["exams"]['exam2mark'] ?? "0";

    ///TODO SHOW MARKS Term Two///
    termTwoTestMarkOne =
        newDataArray[subjectOfTeacher][1]["tests"]['test1mark'] ?? "0";
    termTwoTestMarkTwo =
        newDataArray[subjectOfTeacher][1]["tests"]["test2mark"] ?? "0";
    termTwoTestMarkThree =
        newDataArray[subjectOfTeacher][1]["tests"]["test3mark"] ?? "0";
    termTwoTestMarkFour =
        newDataArray[subjectOfTeacher][1]["tests"]["test4mark"] ?? "0";

    // //Assignments
    termTwoAssignmentMarkOne = newDataArray[subjectOfTeacher][1]["assignments"]
            ['assignment1mark'] ??
        "0";
    termTwoAssignmentMarkTwo = newDataArray[subjectOfTeacher][1]["assignments"]
            ['assignment2mark'] ??
        "0";
    termTwoAssignmentMarkThree = newDataArray[subjectOfTeacher][1]
            ["assignments"]['assignment3mark'] ??
        "0";
    termTwoAssignmentMarkFour = newDataArray[subjectOfTeacher][1]["assignments"]
            ['assignment4mark'] ??
        "0";

    // //Exams
    termTwoExamMarkOne =
        newDataArray[subjectOfTeacher][1]["exams"]['exam1mark'] ?? "0";
    termTwoExamMarkTwo =
        newDataArray[subjectOfTeacher][1]["exams"]['exam2mark'] ?? "0";

    ///TODO SHOW MARKS Term Three///
    termThreeTestMarkOne =
        newDataArray[subjectOfTeacher][2]["tests"]["test1mark"] ?? "0";
    termThreeTestMarkTwo =
        newDataArray[subjectOfTeacher][2]["tests"]["test2mark"] ?? "0";
    termThreeTestMarkThree =
        newDataArray[subjectOfTeacher][2]["tests"]["test3mark"] ?? "0";
    termThreeTestMarkFour =
        newDataArray[subjectOfTeacher][2]["tests"]["test4mark"] ?? "0";

    //Assignments
    termThreeAssignmentMarkOne = newDataArray[subjectOfTeacher][2]
            ["assignments"]["assignment1mark"] ??
        "";
    termThreeAssignmentMarkTwo = newDataArray[subjectOfTeacher][2]
            ["assignments"]["assignment2mark"] ??
        "";
    termThreeAssignmentMarkThree = newDataArray[subjectOfTeacher][2]
            ["assignments"]["assignment3mark"] ??
        "";
    termThreeAssignmentMarkFour = newDataArray[subjectOfTeacher][2]
            ["assignments"]["assignment4mark"] ??
        "";

    //Exams
    termThreeExamMarkOne =
        newDataArray[subjectOfTeacher][2]["exams"]['exam1mark'] ?? "0";
    termThreeExamMarkTwo =
        newDataArray[subjectOfTeacher][2]["exams"]['exam2mark'] ?? "0";

    ///TODO SHOW MARKS Term Four///
    termFourTestMarkOne =
        newDataArray[subjectOfTeacher][3]["tests"]["test1mark"] ?? "0";
    termFourTestMarkTwo =
        newDataArray[subjectOfTeacher][3]["tests"]["test2mark"] ?? "0";
    termFourTestMarkThree =
        newDataArray[subjectOfTeacher][3]["tests"]["test3mark"] ?? "0";
    termFourTestMarkFour =
        newDataArray[subjectOfTeacher][3]["tests"]["test4mark"] ?? "0";

    //Assignments
    termFourAssignmentMarkOne = newDataArray[subjectOfTeacher][3]["assignments"]
            ["assignment1mark"] ??
        "";
    termFourAssignmentMarkTwo = newDataArray[subjectOfTeacher][3]["assignments"]
            ["assignment2mark"] ??
        "";
    termFourAssignmentMarkThree = newDataArray[subjectOfTeacher][3]
            ["assignments"]["assignment3mark"] ??
        "";
    termFourAssignmentMarkFour = newDataArray[subjectOfTeacher][3]
            ["assignments"]["assignment4mark"] ??
        "";

    // //Exams
    termFourExamMarkOne =
        newDataArray[subjectOfTeacher][3]["exams"]['exam1mark'] ?? "0";
    termFourExamMarkTwo =
        newDataArray[subjectOfTeacher][3]["exams"]['exam2mark'] ?? "0";

    return widget.indexMarks.isNotEmpty || widget.indexMarks != null
        ? Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3.0,
                  )
                ],
              ),
              margin: const EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      child: Container(
                        color: Theme.of(context).primaryColor.withOpacity(.7),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Marks for ${widget.nameOfL}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Apple SD Gothic Neo',
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              "Term One",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 4"),
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
                                          labelText(
                                              context, termOneTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termOneTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termOneTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termOneTestMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 4"),
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
                                          labelText(context,
                                              termOneAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termOneAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termOneAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termOneAssignmentMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Exam 2"),
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
                                          labelText(
                                              context, termOneExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termOneExamMarkTwo),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 4"),
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
                                          labelText(
                                              context, termTwoTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termTwoTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termTwoTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termTwoTestMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 4"),
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
                                          labelText(context,
                                              termTwoAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termTwoAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termTwoAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termTwoAssignmentMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Exam 2"),
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
                                          labelText(
                                              context, termTwoExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termTwoExamMarkTwo),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 4"),
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
                                          labelText(
                                              context, termThreeTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termThreeTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termThreeTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termThreeTestMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 4"),
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
                                          labelText(context,
                                              termThreeAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termThreeAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termThreeAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                          labelText(context, "Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Exam 2"),
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
                                          labelText(
                                              context, termThreeExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termThreeExamMarkTwo),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Test 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Test 4"),
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
                                          labelText(
                                              context, termFourTestMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termFourTestMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termFourTestMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termFourTestMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Assignment 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 2"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 3"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Assignment 4"),
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
                                          labelText(context,
                                              termFourAssignmentMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termFourAssignmentMarkTwo),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termFourAssignmentMarkThree),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context,
                                              termFourAssignmentMarkFour),
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
                            height: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                          labelText(context, "Exam 1"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(context, "Exam 2"),
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
                                          labelText(
                                              context, termFourExamMarkOne),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          labelText(
                                              context, termFourExamMarkTwo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          )
        // ? GestureDetector(
        //     onTap: () {
        //       Utils.logger.e("$subjectOfTeacher\n${widget.indexMarks}\n\n");
        //     },
        //     child: const Text("Data"))
        : Center(
            child: Text(
              "No marks have been added for this learner",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
          );
  }
}
